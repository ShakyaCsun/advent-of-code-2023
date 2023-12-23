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
    final field = parseInput();

    return field.findAllPaths();
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

  Iterable<Position> validNeighbours(Position current) {
    return adjacent(current.x, current.y)
        .whereNot((element) => getValueAtPosition(element) == '#')
        .toSet();
  }

  bool isDecisionNode(Position position) {
    return validNeighbours(position).toList().length > 2;
  }

  ({Position next, int cost}) getStepsToNextDecisionNode(
    Position start,
    Position going,
  ) {
    var previous = start;
    var current = going;
    var steps = 1;

    while (true) {
      final next = validNeighbours(current)
          .where((element) => element != previous)
          .toSet();
      if (next.length == 1) {
        steps++;
        previous = current;
        current = next.first;
      } else {
        return (next: current, cost: steps);
      }
    }
  }

  int findAllPaths() {
    final start = firstWhere('.');
    final goal = (
      field[height - 1].lastIndexWhere((element) => element == '.'),
      height - 1,
    );
    final decisionNodes = <Position>{};
    forEach((p0, p1) {
      if (getValueAt(p0, p1) != '#' && isDecisionNode((p0, p1))) {
        decisionNodes.add((p0, p1));
      }
    });
    final nodeDestinations =
        <Position, Set<({Position destination, int cost})>>{};
    var firstDecisionNode = start;
    var costToFirstDecisionNode = 0;
    for (final decisionNode in decisionNodes) {
      for (final neighbour in validNeighbours(decisionNode)) {
        final (:next, :cost) =
            getStepsToNextDecisionNode(decisionNode, neighbour);
        if (next == start) {
          costToFirstDecisionNode = cost;
          firstDecisionNode = decisionNode;
          continue;
        }
        nodeDestinations[decisionNode] = {
          ...nodeDestinations[decisionNode] ?? {},
          (destination: next, cost: cost),
        };
      }
    }
    // final queue = <(Position, Set<Position>, int)>[
    //   (firstDecisionNode, {start, firstDecisionNode}, costToFirstDecisionNode),
    // ];
    var maxCost = 0;
    var pathCount = 0;
    final seen = nodeDestinations.map(
      (key, value) => MapEntry(key, false),
    );
    void dfs(Position vertex, int currentCost) {
      if (seen[vertex] ?? false) {
        return;
      }
      seen[vertex] = true;
      if (vertex == goal) {
        pathCount++;
        if (currentCost > maxCost) {
          maxCost = currentCost;
        }
        seen[vertex] = false;
        return;
      }
      for (final (:destination, :cost) in nodeDestinations[vertex]!) {
        dfs(destination, currentCost + cost);
      }
      seen[vertex] = false;
    }

    dfs(firstDecisionNode, costToFirstDecisionNode);
    // while (queue.isNotEmpty) {
    //   final (current, path, currentCost) = queue.removeAt(0);
    //   if (current == goal) {
    //     pathCount++;
    //     if (currentCost > maxCost) {
    //       maxCost = currentCost;
    //     }
    //     if (pathCount % 10000 == 0) {
    //       print(path);
    //       print('$pathCount) $currentCost - $maxCost');
    //     }
    //     continue;
    //   }
    //   for (final (:destination, :cost) in nodeDestinations[current]!) {
    //     final newPath = {...path};
    //     if (newPath.add(destination)) {
    //       queue.add((destination, newPath, currentCost + cost));
    //     }
    //   }
    // }
    // print(pathCount);

    return maxCost;
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

extension on ({Position from, Position to}) {
  ({Position from, Position to}) get reverse {
    return (from: to, to: from);
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
