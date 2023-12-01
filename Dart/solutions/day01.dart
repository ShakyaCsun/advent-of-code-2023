import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  void parseInput() {}

  @override
  int solvePart1() {
    var solution = 0;
    for (final element in input.getPerLine()) {
      final matches = RegExp(r'(\d)').allMatches(element);
      solution += int.parse('${matches.first[0]}${matches.last[0]}');
    }
    return solution;
  }

  @override
  int solvePart2() {
    return 0;
  }
}
