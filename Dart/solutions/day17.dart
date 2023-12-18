import '../utils/index.dart';

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  Field<int> parseInput() {
    return input.toField(int.parse);
  }

  @override
  int solvePart1() {
    return parseInput().findPath();
  }

  @override
  int solvePart2() {
    return 0;
  }
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
          print('$last4Positions - $position');
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
