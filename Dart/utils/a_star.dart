import 'package:collection/collection.dart';

typedef HeuristicsFunction<T> = int Function(T value);
typedef GoalCondition<T> = bool Function(T value);
typedef PriorityComparator<T> = int Function(
  T a,
  T b,
);
typedef DistanceCalculator<T> = int Function(T current, T neighbour);
typedef GenerateNeighbours<T> = Set<T> Function(T value);
typedef SkipCurrentNeighbour<T> = bool Function(
  T neighbour,
  Iterable<T> currentPath,
);
typedef PathTracer<T> = Iterable<T> Function(Map<T, T> cameFrom, T current);

/// A* search algorithm
/// https://en.wikipedia.org/wiki/A*_search_algorithm
///
/// [Node] should have value equality implemented
List<Node> aStar<Node>({
  required Node start,
  required GoalCondition<Node> goalCondition,
  required HeuristicsFunction<Node> heuristics,
  required PriorityComparator<Node> comparator,
  required GenerateNeighbours<Node> neighbours,
  required DistanceCalculator<Node> distance,
  SkipCurrentNeighbour<Node>? skipNeighbour,
  int defaultMax = -1 >>> 1,
}) {
  List<Node> reconstructPath(
    Map<Node, Node> cameFrom,
    Node current,
  ) {
    final path = [current];
    var currentNode = current;
    while (cameFrom.containsKey(currentNode)) {
      currentNode = cameFrom[currentNode] as Node;
      path.insert(0, currentNode);
    }
    return path;
  }

  Iterable<Node> retracePath(
    Map<Node, Node> cameFrom,
    Node current,
  ) sync* {
    var currentNode = current;
    yield currentNode;
    while (cameFrom.containsKey(currentNode)) {
      currentNode = cameFrom[currentNode] as Node;
      yield currentNode;
    }
  }

  final cameFrom = <Node, Node>{};
  final gScore = <Node, int>{start: 0};
  final fScore = <Node, int>{start: heuristics(start)};
  final openSet = PriorityQueue<Node>((a, b) => comparator(a, b))..add(start);
  while (openSet.isNotEmpty) {
    // print(openSet);
    final current = openSet.first;
    if (goalCondition(current)) {
      return reconstructPath(cameFrom, current);
    }

    openSet.remove(current);
    for (final neighbour in neighbours(current)) {
      if (skipNeighbour != null) {
        if (skipNeighbour(neighbour, retracePath(cameFrom, current))) continue;
      }
      final tentativeGScore = gScore.getOrElse(current, orElse: defaultMax) +
          distance(current, neighbour);
      // print(neighbour);
      if (tentativeGScore < gScore.getOrElse(neighbour, orElse: defaultMax)) {
        // print(tentativeGScore);
        cameFrom[neighbour] = current;
        gScore[neighbour] = tentativeGScore;
        fScore[neighbour] = tentativeGScore + heuristics(neighbour);
        if (!openSet.contains(neighbour)) {
          openSet.add(neighbour);
        }
      }
    }
  }
  throw Exception('$goalCondition condition cannot be reached from $start');
}

extension MapExtension<K, V> on Map<K, V> {
  V getOrElse(K key, {required V orElse}) {
    if (containsKey(key)) {
      return this[key]!;
    }
    return orElse;
  }
}
