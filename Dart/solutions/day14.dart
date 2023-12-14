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
    final field = parseInput();
    var solution = 0;
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
    final field = parseInput();
    return field.cycle(times: 1000000000, useMemo: true).loadOnNorthSide;
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

extension RockListX on List<Rock> {
  List<Rock> slideLeft() {
    final data = <({int cubeIndex, int roundRocks})>[];
    var roundRocks = 0;
    for (final (i, rock) in indexed) {
      switch (rock) {
        case Rock.round:
          roundRocks++;
        case Rock.cube:
          data.add(
            (cubeIndex: i, roundRocks: roundRocks),
          );
          roundRocks = 0;
        case Rock.empty:
          break;
      }
    }
    data.add(
      (cubeIndex: length, roundRocks: roundRocks),
    );
    final newRockList = <Rock>[];
    for (final (:cubeIndex, :roundRocks) in data) {
      for (var i = 0; i < roundRocks; i++) {
        newRockList.add(Rock.round);
      }
      final currentLength = newRockList.length;
      for (var i = 0; i < cubeIndex - currentLength; i++) {
        newRockList.add(Rock.empty);
      }
      newRockList.add(Rock.cube);
    }
    return newRockList..removeLast();
  }

  List<Rock> slideRight() {
    return reversed.toList().slideLeft().reversed.toList();
  }
}

typedef CubeIndices = ({int lastCubeIndex, int cubeIndex});

extension RockFieldX on Field<Rock> {
  int get loadOnNorthSide {
    var solution = 0;
    for (final (i, row) in rows.indexed) {
      for (final rock in row) {
        if (rock == Rock.round) {
          solution += height - i;
        }
      }
    }

    return solution;
  }

  Field<Rock> cycle({int times = 1, bool useMemo = false}) {
    final memo = <String, (Field<Rock> field, int index)>{};
    var newField = this;
    for (var i = 0; i < times; i++) {
      final currentField = newField.toString();
      if (memo.containsKey(currentField) && useMemo) {
        final (field, index) = memo[currentField]!;
        final repeatsEvery = i - index;
        final distance = times - i;
        return field.cycle(times: distance % repeatsEvery - 1);
      }
      for (var i = 0; i < 4; i++) {
        if (i < 2) {
          newField = Field(newField.columns.map((e) => e.slideLeft()).toList());
        } else {
          newField = Field(
            newField.columns.map((e) => e.slideRight()).toList(),
          );
        }
      }
      memo[currentField] = (newField, i);
    }
    return newField;
  }
}
