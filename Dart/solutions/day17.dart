import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class CityBlock extends Equatable implements Comparable<CityBlock> {
  const CityBlock({
    required this.position,
    required this.cost,
    required this.prevOffset,
    required this.stepsInOffset,
  });

  static const start = CityBlock(
    position: (0, 0),
    cost: 0,
    prevOffset: (0, 0),
    stepsInOffset: 0,
  );

  final Position position;
  final Position prevOffset;
  final int stepsInOffset;
  final int cost;

  int get x => position.$1;
  int get y => position.$2;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [stepsInOffset, prevOffset, position];

  @override
  int compareTo(CityBlock other) {
    return cost.compareTo(other.cost);
  }
}

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  Field<int> parseInput() {
    return input.toField(int.parse);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final path = aStar(
      start: CityBlock.start,
      goalCondition: (value) {
        return value.position == (field.width - 1, field.height - 1);
      },
      heuristics: (value) => 0,
      comparator: (a, b) {
        return a.compareTo(b);
      },
      neighbours: (value) {
        final possibleOffsets = {
          (-1, 0),
          (1, 0),
          (0, -1),
          (0, 1),
        }..remove((-value.prevOffset.$1, -value.prevOffset.$2));
        if (value.stepsInOffset == 3) {
          possibleOffsets.remove(value.prevOffset);
        }
        final neighbours = possibleOffsets
            .map<CityBlock?>((offset) {
              final newPosition = value.position + offset;
              if (!field.isOnField(newPosition)) {
                return null;
              }
              final block = CityBlock(
                position: newPosition,
                cost: value.cost + field.getValueAtPosition(newPosition),
                prevOffset: offset,
                stepsInOffset: (offset == value.prevOffset)
                    ? (value.stepsInOffset + 1)
                    : 1,
              );
              // print('Block $block');
              return block;
            })
            .whereNotNull()
            .toSet();
        return neighbours;
      },
      distance: (current, neighbour) {
        return neighbour.cost - current.cost;
      },
    );
    return path.last.cost;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final path = aStar(
      start: CityBlock.start,
      goalCondition: (value) {
        return value.position == (field.width - 1, field.height - 1) &&
            value.stepsInOffset >= 4;
      },
      heuristics: (value) => 0,
      comparator: (a, b) {
        return a.compareTo(b);
      },
      neighbours: (value) {
        final possibleOffsets = {
          (-1, 0),
          (1, 0),
          (0, -1),
          (0, 1),
        }..remove((-value.prevOffset.$1, -value.prevOffset.$2));
        if (value.stepsInOffset == 10) {
          possibleOffsets.remove(value.prevOffset);
        }
        if (value.stepsInOffset < 4 && value != CityBlock.start) {
          possibleOffsets.retainWhere((element) => element == value.prevOffset);
        }
        final neighbours = possibleOffsets
            .map<CityBlock?>((offset) {
              final newPosition = value.position + offset;
              if (!field.isOnField(newPosition)) {
                return null;
              }
              final block = CityBlock(
                position: newPosition,
                cost: value.cost + field.getValueAtPosition(newPosition),
                prevOffset: offset,
                stepsInOffset: (offset == value.prevOffset)
                    ? (value.stepsInOffset + 1)
                    : 1,
              );
              // print('Block $block');
              return block;
            })
            .whereNotNull()
            .toSet();
        return neighbours;
      },
      distance: (current, neighbour) {
        return neighbour.cost - current.cost;
      },
    );
    return path.last.cost;
  }
}

void printPath(List<CityBlock> path, Field<int> field) {
  final copy = field.copy();
  copy.forPositions(path.map((e) => e.position), (x, y) {
    copy.setValueAt(x, y, 0);
  });
  print(copy);
}

extension IntegerFieldX on Field<int> {
  int findPath() {
    const start = (0, 0);
    final end = (width - 1, height - 1);
    final fScore = <Position, int>{};
    fScore[start] = start.getDistance(end);
    final gScore = <Position, int>{};
    gScore[start] = 0;
    final openSet = PriorityQueue<Position>(
      (p0, p1) {
        final p0Score = fScore.getOrInfinite(p0);
        final p1Score = fScore.getOrInfinite(p1);
        return p0Score - p1Score;
      },
    )..add(start);
    final cameFrom = <Position, Position>{};
    while (openSet.isNotEmpty) {
      final current = openSet.first;
      if (current == end) {
        final pathField = Field<String>(
          List.generate(height, (index) => List.generate(width, (i) => ' ')),
        );
        pathField.forPositions(cameFrom.retracePath(end), (p0, p1) {
          pathField.setValueAt(p0, p1, '-');
        });
        print(pathField);
        return getHeatLost(cameFrom, current);
      }
      openSet.remove(current);
      for (final position in adjacent(current.$1, current.$2)) {
        if (position == cameFrom[current]) {
          continue;
        }
        final last4Positions = cameFrom.retracePath(current).take(4);
        if (last4Positions.length == 4 &&
            (last4Positions.every(
                  (element) => element.$1 == position.$1,
                ) ||
                last4Positions.every(
                  (element) => element.$2 == position.$2,
                ))) {
          continue;
        }
        final tentativeGScore =
            gScore.getOrInfinite(current) + getValueAtPosition(position);

        if (tentativeGScore < gScore.getOrInfinite(position)) {
          cameFrom[position] = current;
          gScore[position] = tentativeGScore;
          fScore[position] = tentativeGScore;
          // fScore[position] = tentativeGScore + position.getDistance(end);
          if (!openSet.contains(position)) {
            openSet.add(position);
          }
        }
      }
    }
    return -1;
  }

  int getHeatLost(Map<Position, Position> cameFrom, Position current) {
    var heatLost = 0;
    var currentPos = current;
    while (cameFrom.keys.contains(currentPos)) {
      heatLost += getValueAtPosition(currentPos);
      currentPos = cameFrom[currentPos]!;
    }
    return heatLost - getValueAtPosition((0, 0));
  }
}

extension PositionMap on Map<Position, Position> {
  Iterable<Position> retracePath(Position end) sync* {
    var current = end;
    yield current;
    while (containsKey(current)) {
      current = this[current]!;
      yield current;
    }
  }
}

extension DefaultMap on Map<Position, int> {
  int getOrInfinite(Position key) {
    if (containsKey(key)) {
      return this[key]!;
    } else {
      /// Maximum int value
      return -1 >>> 1;
    }
  }
}
