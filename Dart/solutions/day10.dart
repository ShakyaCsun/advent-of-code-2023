import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10([InputUtil? input]) : super(10, input);

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

  late final field = parseInput();
  late final longestLoop = field.getLongestLoop();

  @override
  int solvePart1() {
    return longestLoop.length ~/ 2;
  }

  @override
  int solvePart2() {
    var result = 0;
    // print(longestLoop);
    // print(field.loop());
    // final newField = Field(field.field);
    // for (final position in longestLoop) {
    //   newField.setValueAtPosition(position, Pipe.start);
    // }
    // print(newField.toPrettyField());

    final (x1, y1) = longestLoop[1];
    final (x2, y2) = longestLoop[longestLoop.length - 1];
    // final isStartHorizontal = x1 == x2 || y1 == y2;
    // print(isStartHorizontal);
    // field.forEach((p0, p1) {
    //   if (longestLoop.contains((p0, p1))) {
    //     return;
    //   }
    //   if (longestLoop
    //       .where(
    //         (element) =>
    //             element.$1 > p0 &&
    //             element.$2 == p1 &&
    //             ![Pipe.horizontal, if (isStartHorizontal) Pipe.start]
    //                 .contains(field.getValueAtPosition(element)),
    //       )
    //       .length
    //       .isOdd) {
    //     result++;
    //   }
    // });

    final newField = Field(field.field);
    // Replace pipes that are not part of loop with Pipe.ground
    newField.forEach((p0, p1) {
      if (!longestLoop.contains((p0, p1))) {
        newField.setValueAt(p0, p1, Pipe.ground);
      }
    });

    final startPosition = field.findStart();

    // Replace Pipe.start with correct Pipe
    newField.setValueAtPosition(
      startPosition,
      [
        Pipe.horizontal,
        Pipe.vertical,
        Pipe.northEast,
        Pipe.northWest,
        Pipe.southEast,
        Pipe.southWest,
      ].firstWhere((element) {
        final neighbours = element.neighbours(startPosition);
        return neighbours.contains((x1, y1)) && neighbours.contains((x2, y2));
      }),
    );

    final pipeMaze = newField.toPrettyField();

    for (final row in pipeMaze.split('\n')) {
      final reducedMazeEdges = row
          .replaceAll('-', '')
          .replaceAll(RegExp('(F7)|(LJ)'), '')
          .replaceAll(RegExp('(FJ)|(L7)'), '|')
          .split('');
      var numberOfIntersections = 0;
      for (final element in reducedMazeEdges) {
        switch (element) {
          case '|':
            numberOfIntersections++;
          case '.':
            if (numberOfIntersections.isOdd) result++;
        }
      }
    }

    return result;
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

extension PipeFieldX on Field<Pipe> {
  String toPrettyField() {
    final buffer = StringBuffer();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        buffer.write(field[y][x].value);
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

  String loop() {
    final loopPos = getLongestLoop();
    final buffer = StringBuffer();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (loopPos.contains((x, y))) {
          buffer.write(field[y][x].value);
        } else {
          buffer.write(' ');
        }
      }
      buffer.writeln();
    }
    return buffer.toString();
  }

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
        currentPosition = newPosition;
        if (currentPosition == startPosition) {
          break forLoop;
        }
        path.add(newPosition);
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

extension PipeX on Pipe {
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
