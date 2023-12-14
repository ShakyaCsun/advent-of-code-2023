import '../utils/index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  Field<Rock> parseInput() {
    return Field(
      input
          .getPerLine()
          .map(
            (e) => e.split('').map(Rock.fromValue).toList(),
          )
          .toList(),
    );
  }

  @override
  int solvePart1() {
    var solution = 0;
    final field = parseInput();
    final columns = field.columns;
    final height = field.height;
    for (final column in columns) {
      var lastCubeIndex = -1;
      var blockingRocksCount = 1;
      for (final (index, rock) in column.indexed) {
        switch (rock) {
          case Rock.round:
            solution += height - lastCubeIndex - blockingRocksCount;
            blockingRocksCount += 1;
          case Rock.cube:
            lastCubeIndex = index;
            blockingRocksCount = 1;
          case Rock.empty:
        }
      }
    }

    return solution;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

enum Rock {
  round('O'),
  cube('#'),
  empty('.');

  const Rock(this.value);

  final String value;

  @override
  String toString() => value;

  static Rock fromValue(String value) {
    return switch (value) {
      'O' => Rock.round,
      '#' => Rock.cube,
      '.' => Rock.empty,
      _ => throw StateError('Invalid Rock value'),
    };
  }
}
