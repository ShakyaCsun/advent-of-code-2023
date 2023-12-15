import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  List<String> parseInput() {
    return input.asString.trim().split(',');
  }

  @override
  int solvePart1() {
    var result = 0;
    for (final step in parseInput()) {
      var hashedStep = 0;
      for (final code in step.codeUnits) {
        hashedStep += code;
        hashedStep *= 17;
        hashedStep %= 256;
      }
      result += hashedStep;
    }
    return result;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

