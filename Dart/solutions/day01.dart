import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  void parseInput() {}

  @override
  int solvePart1() {
    var solution = 0;
    for (final element in input.getPerLine()) {
      final matches = RegExp(r'\d').allMatches(element);
      solution += int.parse('${matches.first[0]}${matches.last[0]}');
    }
    return solution;
  }

  @override
  int solvePart2() {
    var solution = 0;
    String applyCorrection(String word) {
      const corrections = {
        'one': 'o1e',
        'two': 't2o',
        'three': 't3e',
        'four': 'f4r',
        'five': 'f5e',
        'six': 's6x',
        'seven': 's7n',
        'eight': 'e8t',
        'nine': 'n9e',
      };
      var correctWord = word;
      for (final MapEntry(:String key, :String value) in corrections.entries) {
        correctWord = correctWord.replaceAll(key, value);
      }
      return correctWord;
    }

    for (final element in input.getPerLine()) {
      final correctWord = applyCorrection(element);
      final matches = RegExp(r'\d').allMatches(correctWord);
      solution += int.parse('${matches.first[0]}${matches.last[0]}');
    }
    return solution;
  }
}
