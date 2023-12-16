import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  Field<ContraptionItem> parseInput() {
    return Field(
      input
          .getPerLine()
          .map((e) => e.split('').map(ContraptionItem.new).toList())
          .toList(),
    );
  }

  @override
  int solvePart1() {
    final contraptionField = parseInput()
      ..beamToPosition((0, 0), Direction.right);
    return contraptionField.energizedTiles;
  }

  @override
  int solvePart2() {
    var maxTilesEnergized = 0;
    final contraptionField = parseInput();
    final width = contraptionField.width;
    final height = contraptionField.height;
    for (var x = 0; x < width; x++) {
      final tilesEnergizedFromTop = contraptionField.calculateTilesEnergized(
        (x, 0),
        Direction.down,
      );
      final tilesEnergizedFromBottom = contraptionField.calculateTilesEnergized(
        (x, height - 1),
        Direction.up,
      );
      if (tilesEnergizedFromTop > maxTilesEnergized) {
        maxTilesEnergized = tilesEnergizedFromTop;
      }
      if (tilesEnergizedFromBottom > maxTilesEnergized) {
        maxTilesEnergized = tilesEnergizedFromBottom;
      }
    }
    for (var y = 0; y < height; y++) {
      final tilesEnergizedFromLeft = contraptionField.calculateTilesEnergized(
        (0, y),
        Direction.right,
      );
      final tilesEnergizedFromRight = contraptionField.calculateTilesEnergized(
        (width - 1, y),
        Direction.left,
      );
      if (tilesEnergizedFromLeft > maxTilesEnergized) {
        maxTilesEnergized = tilesEnergizedFromLeft;
      }
      if (tilesEnergizedFromRight > maxTilesEnergized) {
        maxTilesEnergized = tilesEnergizedFromRight;
      }
    }
    return maxTilesEnergized;
  }
}

class ContraptionItem extends Equatable {
  const ContraptionItem(this.value, {this.beamDirections = const {}});

  final String value;
  final Set<Direction> beamDirections;

  bool get isEnergized => beamDirections.isNotEmpty;

  Set<Direction> nextDirection(Direction incomingBeam) {
    if (value == '.') {
      return {incomingBeam};
    }
    switch (incomingBeam) {
      case Direction.up:
        return switch (value) {
          r'\' => {Direction.left},
          '/' => {Direction.right},
          '|' => {Direction.up},
          '-' => {Direction.left, Direction.right},
          _ => throw StateError('$value is invalid for ContraptionItem'),
        };
      case Direction.down:
        return switch (value) {
          r'\' => {Direction.right},
          '/' => {Direction.left},
          '|' => {Direction.down},
          '-' => {Direction.left, Direction.right},
          _ => throw StateError('$value is invalid for ContraptionItem'),
        };
      case Direction.left:
        return switch (value) {
          r'\' => {Direction.up},
          '/' => {Direction.down},
          '|' => {Direction.up, Direction.down},
          '-' => {Direction.left},
          _ => throw StateError('$value is invalid for ContraptionItem'),
        };
      case Direction.right:
        return switch (value) {
          r'\' => {Direction.down},
          '/' => {Direction.up},
          '|' => {Direction.up, Direction.down},
          '-' => {Direction.right},
          _ => throw StateError('$value is invalid for ContraptionItem'),
        };
    }
  }

  (ContraptionItem item, Set<Direction> directions) hitWithBeam({
    required Direction goingTo,
  }) {
    final newItem = ContraptionItem(
      value,
      beamDirections: {...beamDirections, goingTo},
    );
    return (newItem, nextDirection(goingTo));
  }

  @override
  String toString() {
    if (beamDirections.isEmpty) {
      return value;
    }
    if (value != '.') {
      return value;
    }
    if (beamDirections.length == 1) {
      return beamDirections.first.value;
    }
    return beamDirections.length.toString();
  }

  @override
  List<Object> get props => [value, beamDirections];
}

enum Direction {
  up('^'),
  down('v'),
  left('<'),
  right('>');

  const Direction(this.value);

  final String value;

  @override
  String toString() => value;

  Position get offset {
    return switch (this) {
      Direction.up => (0, -1),
      Direction.down => (0, 1),
      Direction.left => (-1, 0),
      Direction.right => (1, 0),
    };
  }
}

extension ContraptionFieldX on Field<ContraptionItem> {
  void beamToPosition(
    Position position,
    Direction direction,
  ) {
    final item = getValueAtPosition(position);
    final (updatedItem, nextDirections) = item.hitWithBeam(goingTo: direction);
    if (updatedItem != item) {
      setValueAtPosition(position, updatedItem);
    } else {
      return;
    }
    for (final direction in nextDirections) {
      final newPosition = position + direction.offset;
      if (isOnField(newPosition)) {
        beamToPosition(newPosition, direction);
      }
    }
  }

  int get energizedTiles {
    var count = 0;
    forEachItem((item) {
      if (item.isEnergized) {
        count++;
      }
    });
    return count;
  }

  /// This method calculates the number of tiles energized when a beam going in
  /// [direction] direction is passed to initial position [position].
  ///
  /// This doesn't modify the actual [Field].
  int calculateTilesEnergized(
    Position position,
    Direction direction,
  ) {
    final newField = copy()..beamToPosition(position, direction);
    return newField.energizedTiles;
  }
}
