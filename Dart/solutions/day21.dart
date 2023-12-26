import 'dart:math';

import 'package:meta/meta.dart';

import '../utils/index.dart';

class Day21 extends GenericDay {
  Day21() : super(21);

  @override
  Field<String> parseInput() {
    return Field(input.getPerLine().map((e) => e.split('').toList()).toList());
  }

  @visibleForTesting
  // ignore: avoid_setters_without_getters
  set stepsForPart1(int steps) => _stepsForPart1 = steps;

  @visibleForTesting
  // ignore: avoid_setters_without_getters
  set stepsForPart2(int steps) => _stepsForPart2 = steps;

  var _stepsForPart1 = 64;
  var _stepsForPart2 = 26501365;

  @override
  int solvePart1() {
    final field = parseInput();
    final start = field.firstWhere('S');
    return solve(field: field, start: start, steps: _stepsForPart1);
  }

  @override
  int solvePart2() {
    final field = parseInput();
    assert(field.isSquare, 'Assume rows == columns');
    final (startX, startY) = field.firstWhere('S');
    final size = field.width;
    final gridsOnEitherSide = _stepsForPart2 ~/ size - 1;

    final (oddGridsCount, evenGridsCount) = () {
      final gridsSameAsCenter = pow(gridsOnEitherSide ~/ 2 * 2 + 1, 2).toInt();
      final gridsDifferentToCenter =
          pow((gridsOnEitherSide + 1) ~/ 2 * 2, 2).toInt();

      if (_stepsForPart2.isEven) {
        return (gridsDifferentToCenter, gridsSameAsCenter);
      }
      return (gridsSameAsCenter, gridsDifferentToCenter);
    }();

    final oddGridTilesCount = solve(
      field: field,
      start: (startX, startY),
      // A sufficiently large `Odd` number to fill the [Field] i.e. grid
      steps: size * 2 + 1,
    );
    final evenGridTilesCount = solve(
      field: field,
      start: (startX, startY),
      // A sufficiently large `Even` number
      steps: size * 2,
    );

    final tilesOnTopCorner = solve(
      field: field,
      start: (startX, size - 1),
      steps: size - 1,
    );
    final tilesOnRightCorner = solve(
      field: field,
      start: (0, startY),
      steps: size - 1,
    );
    final tilesOnBottomCorner = solve(
      field: field,
      start: (startX, 0),
      steps: size - 1,
    );
    final tilesOnLeftCorner = solve(
      field: field,
      start: (size - 1, startY),
      steps: size - 1,
    );

    final tilesOnTopRightEdgeSmall = solve(
      field: field,
      start: (0, size - 1),
      steps: size ~/ 2 - 1,
    );
    final tilesOnBottomRightEdgeSmall = solve(
      field: field,
      start: (0, 0),
      steps: size ~/ 2 - 1,
    );
    final tilesOnBottomLeftEdgeSmall = solve(
      field: field,
      start: (size - 1, 0),
      steps: size ~/ 2 - 1,
    );
    final tilesOnTopLeftEdgeSmall = solve(
      field: field,
      start: (size - 1, size - 1),
      steps: size ~/ 2 - 1,
    );

    final tilesOnTopRightEdgeLarge = solve(
      field: field,
      start: (0, size - 1),
      steps: 3 * size ~/ 2 - 1,
    );
    final tilesOnBottomRightEdgeLarge = solve(
      field: field,
      start: (0, 0),
      steps: 3 * size ~/ 2 - 1,
    );
    final tilesOnBottomLeftEdgeLarge = solve(
      field: field,
      start: (size - 1, 0),
      steps: 3 * size ~/ 2 - 1,
    );
    final tilesOnTopLeftEdgeLarge = solve(
      field: field,
      start: (size - 1, size - 1),
      steps: 3 * size ~/ 2 - 1,
    );

    return (oddGridTilesCount * oddGridsCount) +
        (evenGridTilesCount * evenGridsCount) +
        (tilesOnTopCorner +
            tilesOnRightCorner +
            tilesOnBottomCorner +
            tilesOnLeftCorner) +
        ((gridsOnEitherSide + 1) *
            (tilesOnTopRightEdgeSmall +
                tilesOnBottomRightEdgeSmall +
                tilesOnBottomLeftEdgeSmall +
                tilesOnTopLeftEdgeSmall)) +
        (gridsOnEitherSide *
            (tilesOnTopRightEdgeLarge +
                tilesOnBottomRightEdgeLarge +
                tilesOnBottomLeftEdgeLarge +
                tilesOnTopLeftEdgeLarge));
  }

  int solve({
    required Field<String> field,
    required Position start,
    required int steps,
  }) {
    var currentPositions = <Position>{start};
    final possibleEndPositions = <Position>{};
    for (var i = 0; i < steps; i++) {
      final newPositions = <Position>{};
      for (final (x, y) in currentPositions) {
        final neighbours = field.adjacent(x, y);
        for (final neighbour in neighbours) {
          if (field.getValueAtPosition(neighbour) != '#') {
            if ((steps - i).isOdd) {
              if (!possibleEndPositions.contains(neighbour)) {
                possibleEndPositions.add(neighbour);
                newPositions.add(neighbour);
              }
            } else {
              newPositions.add(neighbour);
            }
          }
        }
      }
      currentPositions = newPositions;
    }
    return possibleEndPositions.length;
  }

  int solveBruteForce({
    required Field<String> field,
    required Position start,
    required int steps,
  }) {
    var currentPositions = <Position>{start};
    final possibleEndPositions = <Position>{};
    for (var i = 0; i < steps; i++) {
      final newPositions = <Position>{};
      for (final (x, y) in currentPositions) {
        final neighbours = field.adjacent(x, y, removeOutOfBounds: false);
        for (final neighbour in neighbours) {
          if (field.getValueAtInfinitePosition(neighbour) != '#') {
            if ((steps - i).isOdd) {
              if (!possibleEndPositions.contains(neighbour)) {
                possibleEndPositions.add(neighbour);
                newPositions.add(neighbour);
              }
            } else {
              newPositions.add(neighbour);
            }
          }
        }
      }
      currentPositions = newPositions;
    }
    return possibleEndPositions.length;
  }
}

extension PositionX on Position {
  bool withinRange(Position topLeft, Position bottomRight) {
    if (x >= topLeft.x && x <= bottomRight.x) {
      if (y >= topLeft.y && y <= bottomRight.y) {
        return true;
      }
    }
    return false;
  }
}

extension InfiniteField<T> on Field<T> {
  (Position topLeft, Position bottomRight) expand({int by = 0}) {
    assert(by >= 0, 'Cannot expand field by negative numbers');
    return (
      (-width * by, -height * by),
      (width * by + width - 1, height * by + height - 1)
    );
  }

  T getValueAtInfinitePosition(Position position) {
    if (isOnField(position)) {
      return getValueAtPosition(position);
    }
    final (x, y) = position;
    var adjustedX = x;
    var adjustedY = y;
    while (adjustedX >= width) {
      adjustedX -= width;
    }
    while (adjustedX < 0) {
      adjustedX += width;
    }
    while (adjustedY >= height) {
      adjustedY -= height;
    }
    while (adjustedY < 0) {
      adjustedY += height;
    }

    return getValueAt(adjustedX, adjustedY);
  }
}
