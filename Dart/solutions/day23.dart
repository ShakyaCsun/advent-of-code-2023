import '../utils/index.dart';

class Day23 extends GenericDay {
  Day23() : super(23);

  @override
  Field<String> parseInput() {
    return Field(input.getPerLine().map((e) => e.split('').toList()).toList());
  }

  @override
  int solvePart1() {
    return parseInput().findLongestTrail();
  }

  @override
  int solvePart2() {
    return 0;
  }
}

extension PathFinder on Field<String> {
  Iterable<Position> retracePath(
    Map<Position, Position> cameFrom,
    Position current,
  ) sync* {
    yield current;
    var currentPosition = current;
    while (cameFrom.containsKey(currentPosition)) {
      currentPosition = cameFrom[currentPosition]!;
      yield currentPosition;
    }
  }

  int findLongestTrail() {
    final start = firstWhere('.');
    final goal = (
      field[height - 1].lastIndexWhere((element) => element == '.'),
      height - 1,
    );
    final openSet = PriorityQueue<(Position, int)>(
      (p0, p1) {
        final (start0, cost0) = p0;
        final (start1, cost1) = p1;
        final distanceToGoalComparison =
            start1.getDistance(goal).compareTo(start0.getDistance(goal));
        if (distanceToGoalComparison != 0) {
          return distanceToGoalComparison;
        }

        return cost1.compareTo(cost0);
      },
    )..add((start, 0));
    final cameFrom = <Position, Position>{};
    final gScore = {start: 0};
    while (openSet.isNotEmpty) {
      final (current, cost) = openSet.removeFirst();

      if (current == goal) {
        return cost;
      }

      final currentValue = getValueAtPosition(current);
      final neighbours = <Position>[];
      switch (currentValue) {
        case '>':
          neighbours.add(current + (1, 0));
        case '<':
          neighbours.add(current + (-1, 0));
        case '^':
          neighbours.add(current + (0, -1));
        case 'v':
          neighbours.add(current + (0, 1));
        default:
          neighbours.addAll(adjacent(current.x, current.y));
      }
      for (final neighbour in neighbours) {
        final fieldValue = getValueAtPosition(neighbour);
        if (fieldValue == '#') {
          continue;
        }
        if (retracePath(cameFrom, current).contains(neighbour)) {
          continue;
        }
        final costToNeighbour = cost + 1;
        final prevCostToNeighbour = gScore.getOrElse(neighbour, orElse: -1);
        if (costToNeighbour > prevCostToNeighbour) {
          cameFrom[neighbour] = current;
          gScore[neighbour] = costToNeighbour;
          openSet.remove((neighbour, prevCostToNeighbour));
          if (!openSet.contains((neighbour, costToNeighbour))) {
            openSet.add((neighbour, costToNeighbour));
          }
        }
      }
    }
    return retracePath(cameFrom, goal).length - 1;
  }
}

extension MapExtension<K, V> on Map<K, V> {
  V getOrElse(K key, {required V orElse}) {
    if (containsKey(key)) {
      return this[key]!;
    }
    return orElse;
  }
}
