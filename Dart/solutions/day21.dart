import 'package:meta/meta.dart';

import '../utils/index.dart';

class Day21 extends GenericDay {
  Day21() : super(21);

  @override
  Field<String> parseInput() {
    return Field(input.getPerLine().map((e) => e.split('').toList()).toList());
  }

  @visibleForTesting
  // ignore: avoid_setters_without_getters
  set stepsForPart1(int steps) => _stepsForPart1 = steps;

  @visibleForTesting
  // ignore: avoid_setters_without_getters
  set stepsForPart2(int steps) => _stepsForPart2 = steps;

  var _stepsForPart1 = 64;
  var _stepsForPart2 = 26501365;

  @override
  int solvePart1() {
    final field = parseInput();
    final start = field.firstWhere('S');
    var currentPosition = <Position>{start};
    for (var i = 0; i < _stepsForPart1; i++) {
      final newPositions = <Position>{};
      for (final (x, y) in currentPosition) {
        final neighbours = field.adjacent(x, y);
        for (final neighbour in neighbours) {
          if (field.getValueAtPosition(neighbour) != '#') {
            newPositions.add(neighbour);
          }
        }
      }
      currentPosition = newPositions;
    }
    return currentPosition.length;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
