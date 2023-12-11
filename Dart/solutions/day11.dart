import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11([InputUtil? input]) : super(11, input);

  @override
  Field<String> parseInput() {
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

  @override
  int solvePart1() {
    final universe = parseInput();
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
  int solvePart2() {
    return 0;
  }
}
