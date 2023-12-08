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
    var currentNode = 'AAA';
    var steps = 0;
    final directionsList = directions.split('');
    final length = directionsList.length;
    while (true) {
      var index = steps;
      while (index >= length) {
        index -= length;
      }
      final direction = directionsList[index];
      steps++;
      currentNode = map.go(node: currentNode, direction: direction);
      if (currentNode == 'ZZZ') {
        break;
      }
    }
    return steps;
  }

  @override
  int solvePart2() {
    final (:directions, :map) = parseInput();
    final initialNodes = map.keys
        .where(
          (element) => element.endsWith('A'),
        )
        .toList();
    final directionsList = directions.split('');
    final directionsCount = directionsList.length;
    final repeatsZEvery = <int>[];

    for (final node in initialNodes) {
      var currentNode = node;
      var steps = 0;
      while (true) {
        var index = steps;
        while (index >= directionsCount) {
          index -= directionsCount;
        }
        final direction = directionsList[index];
        steps++;
        currentNode = map.go(
          direction: direction,
          node: currentNode,
        );
        if (currentNode.endsWith('Z') && steps % directionsCount == 0) {
          repeatsZEvery.add(steps);
          break;
        }
      }
    }
    return leastCommonMultiple(repeatsZEvery);
  }
}

/// Improved LCM algorithm
/// Ref: https://www.geeksforgeeks.org/finding-lcm-two-array-numbers-without-using-gcd/
int leastCommonMultiple(List<int> numbers) {
  final numbersCopy = [...numbers];
  final max = numbers.max;
  var lcm = 1;
  var factor = 2;
  while (factor <= max) {
    final indices = <int>[];
    for (final (index, element) in numbersCopy.indexed) {
      if (element % factor == 0) {
        indices.add(index);
      }
    }
    if (indices.length > 1) {
      for (final index in indices) {
        numbersCopy[index] = numbersCopy[index] ~/ factor;
      }
      lcm *= factor;
    } else {
      factor++;
    }
  }
  for (final number in numbersCopy) {
    lcm *= number;
  }
  return lcm;
}

/// Old brute force way of finding Least Common Multiple of numbers
int oldLCM(List<int> numbers) {
  final max = numbers.max;
  var i = 1;
  while (true) {
    final multiple = max * i;
    if (numbers.every((element) => multiple % element == 0)) {
      return multiple;
    }
    i++;
  }
}

typedef Nodes = ({String left, String right});
typedef Instructions = ({String directions, Map<String, Nodes> map});

extension on Map<String, Nodes> {
  String go({required String node, required String direction}) {
    return switch (direction) {
      'L' => this[node]!.left,
      'R' => this[node]!.right,
      _ => throw StateError('direction has to be L or R'),
    };
  }
}
