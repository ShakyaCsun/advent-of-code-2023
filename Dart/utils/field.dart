import 'package:equatable/equatable.dart';
import 'package:quiver/iterables.dart';

typedef Position = (int x, int y);
typedef VoidFieldCallback = void Function(int, int);

extension PositionX on Position {
  Position operator +(Position other) {
    return ($1 + other.$1, $2 + other.$2);
  }

  int getDistance(Position other) {
    final (x1, y1) = other;
    final (x0, y0) = this;
    return (x1 - x0).abs() + (y1 - y0).abs();
  }
}

/// A helper class for easier work with 2D data.
class Field<T> extends Equatable {
  Field(List<List<T>> field)
      : assert(field.isNotEmpty, 'Field must not be empty'),
        assert(field[0].isNotEmpty, 'First position must not be empty'),
        // creates a deep copy by value from given field to prevent unwarranted
        // overrides
        field = List<List<T>>.generate(
          field.length,
          (y) => List<T>.generate(
            field[0].length,
            (x) => field[y][x],
            growable: false,
          ),
          growable: false,
        ),
        height = field.length,
        width = field[0].length;

  Field.fromSize({
    required this.width,
    required this.height,
    required T defaultValue,
  }) : field = List<List<T>>.generate(
          height,
          (_) => List<T>.generate(width, (_) => defaultValue, growable: false),
          growable: false,
        );

  final List<List<T>> field;
  final int height;
  final int width;

  Iterable<List<T>> get rows => field.take(height);

  Iterable<List<T>> get columns {
    Iterable<List<T>> generateCols() sync* {
      for (var i = 0; i < width; i++) {
        yield getColumn(i).toList();
      }
    }

    return generateCols();
  }

  Field<T> transpose() {
    return Field([...columns]);
  }

  /// Returns the value at the given position.
  T getValueAtPosition(Position position) {
    final (x, y) = position;
    return field[y][x];
  }

  /// Returns the value at the given coordinates.
  T getValueAt(int x, int y) => getValueAtPosition((x, y));

  /// Sets the value at the given Position.
  void setValueAtPosition(Position position, T value) {
    final (x, y) = position;
    field[y][x] = value;
  }

  /// Sets the value at the given coordinates.
  void setValueAt(int x, int y, T value) => setValueAtPosition((x, y), value);

  /// Returns whether the given position is inside of this field.
  bool isOnField(Position position) {
    final (x, y) = position;
    return x >= 0 && y >= 0 && x < width && y < height;
  }

  /// Returns the whole row with given row index.
  Iterable<T> getRow(int row) => field[row];

  /// Returns the whole column with given column index.
  Iterable<T> getColumn(int column) => field.map((row) => row[column]);

  /// Returns the minimum value in this field.
  T get minValue => min<T>(field.expand((element) => element))!;

  /// Returns the maximum value in this field.
  T get maxValue => max<T>(field.expand((element) => element))!;

  /// Executes the given callback for every position on this field.
  void forEach(VoidFieldCallback callback) {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        callback(x, y);
      }
    }
  }

  /// Executes the given callback for every item on this field.
  void forEachItem(void Function(T item) callback) {
    for (final row in field) {
      for (final item in row) {
        callback(item);
      }
    }
  }

  Field<T> insertRow(int rowIndex, T value) {
    final newField = List<List<T>>.generate(
      height + 1,
      (y) {
        if (y == rowIndex) {
          return List<T>.generate(width, (x) => value);
        }
        if (y < rowIndex) {
          return List<T>.generate(width, (x) => field[y][x]);
        }
        return List<T>.generate(width, (x) => field[y - 1][x]);
      },
    );
    return Field<T>(newField);
  }

  Field<T> insertCol(int colIndex, T value) {
    final newField = List<List<T>>.generate(
      height,
      (y) {
        return List<T>.generate(width + 1, (x) {
          if (x < colIndex) {
            return field[y][x];
          }
          if (x == colIndex) {
            return value;
          }
          return field[y][x - 1];
        });
      },
    );
    return Field<T>(newField);
  }

  Position firstWhere(T value) {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (field[y][x] == value) {
          return (x, y);
        }
      }
    }
    throw StateError('$value is not on field.');
  }

  /// Returns the number of occurrences of given object in this field.
  int count(T searched) => field
      .expand((element) => element)
      .fold<int>(0, (acc, elem) => elem == searched ? acc + 1 : acc);

  /// Executes the given callback for all given positions.
  void forPositions(
    Iterable<Position> positions,
    VoidFieldCallback callback,
  ) {
    for (final (x, y) in positions) {
      callback(x, y);
    }
  }

  /// Returns all adjacent cells to the given position. This does `NOT` include
  /// diagonal neighbours.
  Iterable<Position> adjacent(int x, int y) {
    return <Position>{
      (x, y - 1),
      (x, y + 1),
      (x - 1, y),
      (x + 1, y),
    }..removeWhere(
        (pos) {
          final (x, y) = pos;
          return x < 0 || y < 0 || x >= width || y >= height;
        },
      );
  }

  /// Returns all positional neighbours of a point. This includes the adjacent
  /// `AND` diagonal neighbours.
  Iterable<Position> neighbours(int x, int y) {
    return <Position>{
      // positions are added in a circle, starting at the top middle
      (x, y - 1),
      (x + 1, y - 1),
      (x + 1, y),
      (x + 1, y + 1),
      (x, y + 1),
      (x - 1, y + 1),
      (x - 1, y),
      (x - 1, y - 1),
    }..removeWhere(
        (pos) {
          final (x, y) = pos;
          return x < 0 || y < 0 || x >= width || y >= height;
        },
      );
  }

  /// Returns a deep copy by value of this [Field].
  Field<T> copy() {
    final newField = List<List<T>>.generate(
      height,
      (y) => List<T>.generate(width, (x) => field[y][x]),
    );
    return Field<T>(newField);
  }

  @override
  String toString() {
    final result = StringBuffer();
    for (final row in field) {
      for (final elem in row) {
        result.write(elem.toString());
      }
      result.write('\n');
    }
    return result.toString();
  }

  @override
  List<Object> get props => [toString()];
}

/// Extension for [Field]s where `T` is of type [int].
extension IntegerField on Field<int> {
  /// Increments the values of Position `x` `y`.
  void increment(int x, int y) => setValueAt(x, y, getValueAt(x, y) + 1);

  /// Convenience method to create a Field from a single String, where the
  /// String is a "block" of integers.
  static Field<int> fromString(String string) {
    final lines = string
        .split('\n')
        .map((line) => line.trim().split('').map(int.parse).toList())
        .toList();
    return Field(lines);
  }
}

extension PositionExtensions on Position {
  int get x => $1;
  int get y => $2;
}
