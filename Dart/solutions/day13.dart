import 'dart:math' as math;

import '../utils/index.dart';

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  List<Field<Floor>> parseInput() {
    final fields = <Field<Floor>>[];
    for (final field in input.asString.trim().split('\n\n')) {
      final grid = <List<Floor>>[];
      for (final line in field.split('\n')) {
        grid.add(line.split('').map<Floor>(Floor.fromValue).toList());
      }
      fields.add(Field(grid));
    }
    return fields;
  }

  @override
  int solvePart1() {
    final fields = parseInput();
    var rowIndexSum = 0;
    var columnIndexSum = 0;
    for (final field in fields) {
      final max = math.max(field.height, field.width);
      final setRows = <String>{};
      final setColumns = <String>{};
      for (var i = 0; i < max; i++) {
        if (i < field.height) {
          final rowAdded = setRows.add(field.getRow(i).join());
          if (!rowAdded) {
            if (field.verifyReflection(ReflectionAxis.row, i)) {
              rowIndexSum += i;
              break;
            }
          }
        }
        if (i < field.width) {
          final columnAdded = setColumns.add(field.getColumn(i).join());
          if (!columnAdded) {
            if (field.verifyReflection(ReflectionAxis.column, i)) {
              columnIndexSum += i;
              break;
            }
          }
        }
      }
    }
    return rowIndexSum * 100 + columnIndexSum;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

extension FloorFieldX on Field<Floor> {
  bool verifyReflection(ReflectionAxis axis, int index) {
    bool verifyReflectionOnList(Iterable<List<Floor>> floorGrid) {
      final length = floorGrid.length;
      for (var i = 0; i < length - index; i++) {
        if (index - 1 - i < 0) {
          break;
        }
        if (floorGrid.elementAt(index + i).join() !=
            floorGrid.elementAt(index - 1 - i).join()) {
          return false;
        }
      }
      return true;
    }

    switch (axis) {
      case ReflectionAxis.row:
        return verifyReflectionOnList(rows);
      case ReflectionAxis.column:
        return verifyReflectionOnList(columns);
    }
  }
}

enum ReflectionAxis {
  row,
  column,
}

enum Floor {
  ash('.'),
  rock('#');

  const Floor(this.value);

  final String value;

  static Floor fromValue(String value) {
    return switch (value) {
      '.' => Floor.ash,
      '#' => Floor.rock,
      _ => throw StateError('Invalid Value for Floor'),
    };
  }

  @override
  String toString() {
    return value;
  }
}
