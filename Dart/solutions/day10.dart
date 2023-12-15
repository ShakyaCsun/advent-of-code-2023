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
  late final longestLoop = List<Position>.unmodifiable(field.getLongestLoop());

  @override
  int solvePart1() {
    return longestLoop.length ~/ 2;
  }

  @override
  int solvePart2() {
    var result = 0;

    final (x1, y1) = longestLoop[1];
    final (x2, y2) = longestLoop.last;
    final startPosition = field.findStart();

    // Replace Pipe.start with correct Pipe
    final actualField = field.copy()
      ..setValueAtPosition(
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

    final loopPositions = {...longestLoop};

    for (final (y, row) in actualField.field.indexed) {
      var numberOfIntersections = 0;
      var computingF = false;
      var computingL = false;
      for (final (x, pipe) in row.indexed) {
        if (loopPositions.remove((x, y))) {
          switch (pipe.value) {
            case 'F':
              computingF = true;
            case 'L':
              computingL = true;
            case '7':
              if (computingL) {
                numberOfIntersections++;
                computingL = false;
              } else {
                computingF = false;
              }
            case 'J':
              if (computingF) {
                numberOfIntersections++;
                computingF = false;
              } else {
                computingL = false;
              }
            case '|':
              numberOfIntersections++;
          }
        } else if (numberOfIntersections.isOdd) {
          result++;
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

  @override
  String toString() => value;
}

extension PipeFieldX on Field<Pipe> {
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
