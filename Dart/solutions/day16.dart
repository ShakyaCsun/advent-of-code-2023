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
    var energizedCount = 0;
    contraptionField.forEachItem((item) {
      if (item.isEnergized) {
        energizedCount++;
      }
    });
    return energizedCount;
  }

  @override
  int solvePart2() {
    return 0;
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
}
