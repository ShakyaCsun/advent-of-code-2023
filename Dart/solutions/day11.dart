import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11([InputUtil? input]) : super(11, input);

  @override
  (
    Field<String> universe,
    List<int> emptyRows,
    List<int> emptyColumns,
  ) parseInput() {
    final observedUniverse = Field(
      input.getPerLine().map((e) => e.split('').toList()).toList(),
    );
    final rowsToExpand = <int>[];
    final colsToExpand = <int>[];
    for (var y = 0; y < observedUniverse.height; y++) {
      if (observedUniverse.getRow(y).every((element) => element == '.')) {
        rowsToExpand.add(y);
      }
    }
    for (var x = 0; x < observedUniverse.width; x++) {
      if (observedUniverse.getColumn(x).every((element) => element == '.')) {
        colsToExpand.add(x);
      }
    }
    return (observedUniverse, rowsToExpand, colsToExpand);
  }

  Field<String> parseInputPart1() {
    final observedUniverse = Field(
      input.getPerLine().map((e) => e.split('').toList()).toList(),
    );
    final rowsToExpand = <int>[];
    final colsToExpand = <int>[];
    for (var y = 0; y < observedUniverse.height; y++) {
      if (observedUniverse.getRow(y).every((element) => element == '.')) {
        rowsToExpand.add(y + rowsToExpand.length);
      }
    }
    for (var x = 0; x < observedUniverse.width; x++) {
      if (observedUniverse.getColumn(x).every((element) => element == '.')) {
        colsToExpand.add(x + colsToExpand.length);
      }
    }
    var expandedUniverse = observedUniverse.copy();
    for (final index in rowsToExpand) {
      expandedUniverse = expandedUniverse.insertRow(index, '.');
    }
    for (final index in colsToExpand) {
      expandedUniverse = expandedUniverse.insertCol(index, '.');
    }
    return expandedUniverse;
  }

  int solvePart1Solution1() {
    final universe = parseInputPart1();
    final galaxyLocation = <Position>[];
    universe.forEach((p0, p1) {
      if (universe.getValueAt(p0, p1) == '#') {
        galaxyLocation.add((p0, p1));
      }
    });

    var result = 0;
    final galaxiesCount = galaxyLocation.length;

    for (final (index, location) in galaxyLocation.indexed) {
      for (var i = index + 1; i < galaxiesCount; i++) {
        result += galaxyLocation[i].getDistance(location);
      }
    }
    return result;
  }

  @override
  int solvePart1() {
    return getSolution();
  }

  @override
  int solvePart2() {
    return getSolution(expandEmptySpaceBy: 1000000);
  }

  int getSolution({int expandEmptySpaceBy = 2}) {
    final (universe, rowsToExpand, colsToExpand) = parseInput();
    final galaxyLocation = <Position>[];
    universe.forEach((p0, p1) {
      if (universe.getValueAt(p0, p1) == '#') {
        galaxyLocation.add((p0, p1));
      }
    });

    var result = 0;
    final galaxiesCount = galaxyLocation.length;

    for (final (index, location) in galaxyLocation.indexed) {
      for (var i = index + 1; i < galaxiesCount; i++) {
        final nextLocation = galaxyLocation[i];
        result += nextLocation.getDistance(location);
        for (final rowIndex in rowsToExpand) {
          if (nextLocation.distanceIncludesRow(rowIndex, location)) {
            result += expandEmptySpaceBy - 1;
          }
        }
        for (final colIndex in colsToExpand) {
          if (nextLocation.distanceIncludesColumn(colIndex, location)) {
            result += expandEmptySpaceBy - 1;
          }
        }
      }
    }
    return result;
  }
}

extension on Position {
  bool distanceIncludesRow(int rowIndex, Position other) {
    return (other.$2 > rowIndex && $2 < rowIndex) ||
        (other.$2 < rowIndex && $2 > rowIndex);
  }

  bool distanceIncludesColumn(int colIndex, Position other) {
    return (other.$1 > colIndex && $1 < colIndex) ||
        (other.$1 < colIndex && $1 > colIndex);
  }
}
