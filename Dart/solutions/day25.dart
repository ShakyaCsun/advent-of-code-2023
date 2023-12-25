import '../utils/index.dart';

class Day25 extends GenericDay {
  Day25() : super(25);

  @override
  List<(String, String)> parseInput() {
    final inputConnections = input.getPerLine().map((e) => e.split(': '));
    final connections = <(String, String)>[];
    for (final [left, right, ...] in inputConnections) {
      for (final node in right.split(' ')) {
        connections.add((left, node));
      }
    }
    return connections;
  }

  (String, String) getMostConnectedEdge(Map<String, Set<String>> graph) {
    final edgeFrequencies = <(String, String), int>{};
    final goodCandidateEdges = <(String, String)>{};
    for (final node in graph.keys) {
      final nodeEdges = graph[node]!;
      for (final neighbour in nodeEdges) {
        final neighbourEdges = graph[neighbour]!;
        if (nodeEdges.intersection(neighbourEdges).isEmpty) {
          goodCandidateEdges.add((node, neighbour).sorted);
        }
      }
    }

    for (final node in graph.keys) {
      final queue = QueueList.from([node]);
      final visited = <String>{node};
      while (queue.isNotEmpty) {
        final current = queue.removeFirst();
        for (final neighbour in graph[current]!) {
          if (visited.add(neighbour)) {
            queue.add(neighbour);
            final edge = (current, neighbour).sorted;
            if (goodCandidateEdges.contains(edge)) {
              edgeFrequencies[edge] = (edgeFrequencies[edge] ?? 0) + 1;
            }
          }
        }
      }
    }
    final sorted = edgeFrequencies.entries.sorted(
      (a, b) => -a.value.compareTo(b.value),
    );
    return sorted.first.key;
  }

  @override
  int solvePart1() {
    final connections = parseInput()
        .expand((element) => [element, (element.$2, element.$1)])
        .toSet();
    final graph = <String, Set<String>>{};
    for (final (left, right) in connections) {
      graph[left] = {...graph[left] ?? {}, right};
    }

    var newGraph = {...graph};
    for (var i = 0; i < 3; i++) {
      final (left, right) = getMostConnectedEdge(newGraph);
      newGraph = newGraph.removeConnection(left, right);
    }

    final components = stronglyConnectedComponents(newGraph);
    if (components.length == 2) {
      return components[0].length * components[1].length;
    }
    return -1;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

extension GraphExtensions on Map<String, Set<String>> {
  Map<String, Set<String>> removeConnection(String left, String right) {
    return {
      ...this,
      left: {...this[left] ?? {}}..remove(right),
      right: {...this[right] ?? {}}..remove(left),
    };
  }
}

extension EdgeX on (String, String) {
  (String, String) get sorted => $1.compareTo($2) < 0 ? ($1, $2) : ($2, $1);
}
