import 'dart:math' as math;

import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  /// Get a list of Winning numbers that the cards have
  @override
  List<List<int>> parseInput() {
    return input.getPerLine().map((card) {
      final [_, numbers, ...] = card.split(': ');
      var foundSeparator = false;
      final winningNumbers = <int>[];
      final myWinningNumbers = <int>[];
      for (final number in numbers.trim().split(RegExp(r'\s+'))) {
        if (number == '|') {
          foundSeparator = true;
          continue;
        }
        if (!foundSeparator) {
          winningNumbers.add(int.parse(number));
        } else {
          final myNumber = int.parse(number);
          if (winningNumbers.contains(myNumber)) {
            myWinningNumbers.add(myNumber);
          }
        }
      }
      return myWinningNumbers;
    }).toList();
  }

  @override
  int solvePart1() {
    var result = 0;
    final myWinningNumbers = parseInput();
    for (final numbers in myWinningNumbers) {
      result += math.pow(2, numbers.length - 1).toInt();
    }
    return result;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
