import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  Grid<Char> parseInput() {
    return input
        .getPerLine()
        .map(
          (e) => e.split('').map(Char.new).toList(),
        )
        .toList();
  }

  @override
  int solvePart1() {
    var result = 0;
    final inputGrid = parseInput();
    final gridWidth = inputGrid.width;

    for (final (i, row) in inputGrid.indexed) {
      var foundDigit = false;
      var currentNumber = 0;
      var hasAdjacentSymbol = false;
      for (final (j, char) in row.indexed) {
        final digit = char.digit;
        if (digit != null) {
          foundDigit = true;
          currentNumber = currentNumber * 10 + digit;
          if (!hasAdjacentSymbol) {
            hasAdjacentSymbol = inputGrid.checkHasAdjacentSymbol(i, j);
          }
          if (j + 1 == gridWidth && hasAdjacentSymbol) {
            result += currentNumber;
          }
        } else if (foundDigit) {
          if (hasAdjacentSymbol) {
            result += currentNumber;
          }
          foundDigit = false;
          currentNumber = 0;
          hasAdjacentSymbol = false;
        }
      }
    }
    return result;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

class Char {
  Char(this._char)
      : assert(
          _char.length == 1,
          'Char must be a single character string.',
        );

  final String _char;

  late final int rune = _char.runes.elementAt(0);

  int? get digit {
    if (rune >= 48 && rune <= 57) {
      return rune - 48;
    }
    return null;
  }

  bool get isSymbol {
    if (digit != null) {
      return false;
    }
    if (_char == '.') {
      return false;
    }
    return true;
  }
}

typedef Grid<T> = List<List<T>>;

extension on Grid<Char> {
  int get width => this[0].length;
  int get height => length;

  /// Returns true if the given index (i, j) has a neighbor that is a symbol
  bool checkHasAdjacentSymbol(int i, int j) {
    final surroundingIndices = [
      (-1, -1),
      (-1, 0),
      (-1, 1),
      (0, -1),
      (0, 1),
      (1, -1),
      (1, 0),
      (1, 1),
    ].map((e) => (e.$1 + i, e.$2 + j)).toList();
    for (final (row, col) in surroundingIndices) {
      if (row >= 0 && row < height && col >= 0 && col < width) {
        final isSymbol = this[row][col].isSymbol;
        if (isSymbol) {
          return true;
        }
      }
    }
    return false;
  }
}
