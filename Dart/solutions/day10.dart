// ignore_for_file: prefer_final_locals

import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  Field<Pipe> parseInput() {
    return Field(
      input
          .getPerLine()
          .map<List<Pipe>>(
            (e) => e.split('').map<Pipe>(Pipe.fromString).toList(),
          )
          .toList(),
    );
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final longestLoop = field.getLongestLoop();
    return longestLoop.length ~/ 2;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

enum Pipe {
  horizontal('-'),
  vertical('|'),
  northEast('L'),
  northWest('J'),
  southEast('F'),
  southWest('7'),
  start('S'),
  ground('.');

  const Pipe(this.value);

  static Pipe fromString(String pipe) {
    return Pipe.values.firstWhere((element) => element.value == pipe);
  }

  final String value;
}

extension on Field<Pipe> {
  Position findStart() {
    return firstWhere(Pipe.start);
  }

  List<Position> getLongestLoop() {
    final startPosition = findStart();
    var currentPosition = startPosition;
    var path = <Position>[startPosition];

    forLoop:
    for (final position in getValidNeighbours(currentPosition)) {
      path.add(position);
      currentPosition = position;
      while (true) {
        final newPosition =
            getValidNeighbours(currentPosition).firstWhereOrNull(
          (element) => element != path[path.length - 2],
        );
        if (newPosition == null) {
          path = [startPosition];
          break;
        }
        path.add(newPosition);
        currentPosition = newPosition;
        if (currentPosition == startPosition) {
          break forLoop;
        }
      }
    }

    return path;
  }

  List<Position> getValidNeighbours(Position position) {
    final pipe = getValueAtPosition(position);
    final positions = <Position>[];
    for (final element in pipe.neighbours(position)) {
      if (isOnField(element)) {
        if (getValueAtPosition(element)
            .neighbours(element)
            .contains(position)) {
          positions.add(element);
        }
      }
    }
    return positions;
  }
}

extension on Pipe {
  List<Position> connections() {
    return switch (this) {
      Pipe.horizontal => [(-1, 0), (1, 0)],
      Pipe.vertical => [(0, -1), (0, 1)],
      Pipe.northEast => [(0, -1), (1, 0)],
      Pipe.northWest => [(0, -1), (-1, 0)],
      Pipe.southEast => [(0, 1), (1, 0)],
      Pipe.southWest => [(0, 1), (-1, 0)],
      Pipe.start => [(0, 1), (-1, 0), (0, -1), (1, 0)],
      Pipe.ground => <Position>[],
    };
  }

  List<Position> neighbours(Position position) {
    return connections().map((e) => e + position).toList();
  }
}
