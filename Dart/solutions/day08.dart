import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  Instructions parseInput() {
    final [directions, _, ...mapNodes] = input.getPerLine();
    final map = <String, Nodes>{};
    for (final e in mapNodes) {
      final nodes = e.replaceAll(RegExp(r'\s|\(|\)'), '');
      final [node, leftRight, ...] = nodes.split('=');
      final [left, right, ...] = leftRight.split(',');
      map.addAll({node: (left: left, right: right)});
    }
    return (directions: directions, map: map);
  }

  @override
  int solvePart1() {
    final (:directions, :map) = parseInput();
    var initialNode = 'AAA';
    var steps = 0;
    final directionsList = directions.split('');
    final length = directionsList.length;
    while (true) {
      var index = steps;
      while (index >= length) {
        index -= length;
      }
      final direction = directionsList[index];
      final directionNodes = map[initialNode]!;
      steps++;
      switch (direction) {
        case 'L':
          initialNode = directionNodes.left;

        case 'R':
          initialNode = directionNodes.right;
      }
      if (initialNode == 'ZZZ') {
        break;
      }
    }
    return steps;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

typedef Nodes = ({String left, String right});
typedef Instructions = ({String directions, Map<String, Nodes> map});
