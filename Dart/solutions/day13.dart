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
    final fields = parseInput();
    var rowIndexSum = 0;
    var columnIndexSum = 0;
    for (final field in fields) {
      final max = math.max(field.height, field.width);

      smudgeCalculateLoop:
      for (var i = 0; i < max; i++) {
        final height = field.height;
        if (i < height) {
          for (var j = i + 1; j < height; j += 2) {
            if (field.rows.elementAt(i).hasOneSmudge(field.rows.elementAt(j))) {
              /// If smudge is found for rows 1 and 6, then the required
              /// row index for reflection is at 4.
              final index = (i + j + 1) ~/ 2;
              if (field.verifyReflectionWithSmudge(
                ReflectionAxis.row,
                index,
                j,
              )) {
                rowIndexSum += index;
                break smudgeCalculateLoop;
              }
            }
          }
        }
        final width = field.width;
        if (i < width) {
          for (var j = i + 1; j < width; j += 2) {
            if (field.columns
                .elementAt(i)
                .hasOneSmudge(field.columns.elementAt(j))) {
              /// If smudge is found for columns 1 and 6, then the required
              /// column index for reflection is at 4.
              final index = (i + j + 1) ~/ 2;
              if (field.verifyReflectionWithSmudge(
                ReflectionAxis.column,
                index,
                j,
              )) {
                columnIndexSum += index;
                break smudgeCalculateLoop;
              }
            }
          }
        }
      }
    }
    return rowIndexSum * 100 + columnIndexSum;
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

  bool verifyReflectionWithSmudge(
    ReflectionAxis axis,
    int index,
    int smudgeAt,
  ) {
    bool verifyReflectionOnList(Iterable<List<Floor>> floorGrid) {
      final length = floorGrid.length;
      for (var i = 0; i < length - index; i++) {
        if (index - 1 - i < 0) {
          break;
        }
        final upperIndex = index + i;
        final lowerIndex = index - 1 - i;
        if (upperIndex == smudgeAt || lowerIndex == smudgeAt) {
          continue;
        }
        if (floorGrid.elementAt(upperIndex).join() !=
            floorGrid.elementAt(lowerIndex).join()) {
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

extension FloorListX on Iterable<Floor> {
  bool hasOneSmudge(Iterable<Floor> other) {
    var smudgeCount = 0;
    for (final (i, floor) in indexed) {
      if (floor != other.elementAt(i)) {
        smudgeCount++;
      }
      if (smudgeCount > 1) {
        return false;
      }
    }
    return smudgeCount == 1;
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
