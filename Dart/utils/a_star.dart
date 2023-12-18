import 'package:collection/collection.dart';

typedef HeuristicsFunction<T> = int Function(T value);
typedef PriorityComparator<T> = int Function(T a, T b);
typedef DistanceCalculator<T> = int Function(T current, T neighbour);
typedef GenerateNeighbours<T> = Set<T> Function(T value);

/// A* search algorithm
/// https://en.wikipedia.org/wiki/A*_search_algorithm
///
/// [Node] should have value equality implemented
List<Node> aStar<Node>({
  required Node start,
  required Node goal,
  required HeuristicsFunction<Node> heuristics,
  required PriorityComparator<Node> comparator,
  required GenerateNeighbours<Node> neighbours,
  required DistanceCalculator<Node> distance,
  int defaultMax = -1 >>> 1,
}) {
  List<Node> reconstructPath(Map<Node, Node> cameFrom, Node current) {
    final path = [current];
    var currentNode = current;
    while (cameFrom.containsKey(currentNode)) {
      currentNode = cameFrom[currentNode] as Node;
      path.insert(0, currentNode);
    }
    return path;
  }

  final openSet = PriorityQueue<Node>(comparator)..add(start);
  final cameFrom = <Node, Node>{};
  final gScore = <Node, int>{start: 0};
  final fScore = <Node, int>{start: heuristics(start)};

  while (openSet.isNotEmpty) {
    final current = openSet.first;
    if (current == goal) {
      return reconstructPath(cameFrom, current);
    }

    openSet.remove(current);
    for (final neighbour in neighbours(current)) {
      final tentativeGScore = gScore.getOrElse(current, orElse: defaultMax) +
          distance(current, neighbour);
      if (tentativeGScore < gScore.getOrElse(neighbour, orElse: defaultMax)) {
        cameFrom[neighbour] = current;
        gScore[neighbour] = tentativeGScore;
        fScore[neighbour] = tentativeGScore + heuristics(neighbour);
        if (!openSet.contains(neighbour)) {
          openSet.add(neighbour);
        }
      }
    }
  }
  throw Exception('$goal cannot be reached from $start');
}

extension MapExtension<K, V> on Map<K, V> {
  V getOrElse(K key, {required V orElse}) {
    if (containsKey(key)) {
      return this[key]!;
    }
    return orElse;
  }
}
