import '../utils/index.dart';

class Day09 extends GenericDay {
  Day09() : super(9);

  @override
  List<List<int>> parseInput() {
    return input
        .getPerLine()
        .map<List<int>>((e) => e.split(' ').map(int.parse).toList())
        .toList();
  }

  late final parsedInput = parseInput();

  @override
  int solvePart1() {
    var result = 0;
    for (final numbers in parsedInput) {
      result += getNextNumber(numbers);
    }
    return result;
  }

  @override
  int solvePart2() {
    return parsedInput.fold(
      0,
      (previousValue, numbers) => previousValue += getPreviousNumber(numbers),
    );
  }

  int getNextNumber(List<int> numbers) {
    if (numbers.every((element) => element == 0)) {
      return 0;
    }
    final length = numbers.length;
    final differences = <int>[];
    for (var i = 0; i < length - 1; i++) {
      differences.add(numbers[i + 1] - numbers[i]);
    }
    return numbers[length - 1] + getNextNumber(differences);
  }

  int getPreviousNumber(List<int> numbers) {
    if (numbers.every((element) => element == 0)) {
      return 0;
    }
    final length = numbers.length;
    final differences = <int>[];
    for (var i = 0; i < length - 1; i++) {
      differences.add(numbers[i + 1] - numbers[i]);
    }
    return numbers[0] - getPreviousNumber(differences);
  }
}
