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

  Iterable<CityBlock> neighboursPartOne(Field<int> field) {
    final (dx, dy) = prevOffset;
    var neighbours = <Position>{(-dy, dx), (dy, -dx)};
    if (stepsInOffset < 3) {
      neighbours.add(prevOffset);
    }
    if (prevOffset == start.prevOffset) {
      neighbours = {(1, 0), (0, 1)};
    }
    return neighbours.map((offset) {
      final newPosition = position + offset;
      if (!field.isOnField(newPosition)) {
        return null;
      }
      final block = CityBlock(
        position: newPosition,
        cost: cost + field.getValueAtPosition(newPosition),
        prevOffset: offset,
        stepsInOffset: (offset == prevOffset) ? (stepsInOffset + 1) : 1,
      );
      return block;
    }).whereNotNull();
  }

  Iterable<CityBlock> neighboursPartTwo(Field<int> field) {
    final (dx, dy) = prevOffset;
    var neighbours = <Position>{};
    if (stepsInOffset < 10) {
      neighbours.add(prevOffset);
    }
    if (stepsInOffset >= 4) {
      neighbours.addAll([(-dy, dx), (dy, -dx)]);
    }
    if (prevOffset == start.prevOffset) {
      neighbours = {(1, 0), (0, 1)};
    }
    return neighbours.map((offset) {
      final newPosition = position + offset;
      if (!field.isOnField(newPosition)) {
        return null;
      }
      final block = CityBlock(
        position: newPosition,
        cost: cost + field.getValueAtPosition(newPosition),
        prevOffset: offset,
        stepsInOffset: (offset == prevOffset) ? (stepsInOffset + 1) : 1,
      );
      return block;
    }).whereNotNull();
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [stepsInOffset, cost, prevOffset, position];

  (Position, Position, int) get key => (position, prevOffset, stepsInOffset);

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
    return field.findMinimumCost();
  }

  @override
  int solvePart2() {
    final field = parseInput();
    return field.findMinimumCost(part2: true);
  }
}

extension IntegerFieldX on Field<int> {
  int findMinimumCost({bool part2 = false}) {
    const start = CityBlock.start;
    final endPosition = (width - 1, height - 1);
    final gScore = <(Position, Position, int), int>{start.key: 0};
    final openSet = PriorityQueue<CityBlock>()..add(start);
    while (openSet.isNotEmpty) {
      final current = openSet.removeFirst();
      if (!part2 && current.position == endPosition) {
        return current.cost;
      }
      if (part2 &&
          current.position == endPosition &&
          current.stepsInOffset >= 4) {
        return current.cost;
      }
      final neighbourBlocks = part2
          ? current.neighboursPartTwo(this)
          : current.neighboursPartOne(this);
      for (final block in neighbourBlocks.whereNot(
        (element) => gScore.containsKey(element.key),
      )) {
        gScore[block.key] = block.cost;
        openSet.add(block);
      }
    }
    return -1;
  }
}
