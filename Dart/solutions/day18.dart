import '../utils/index.dart';

typedef OffsetCount = List<(Position, int)>;

class Day18 extends GenericDay {
  Day18() : super(18);

  @override
  ({OffsetCount one, OffsetCount two}) parseInput() {
    final offsetCountsOne = <(Position, int)>[];
    final offsetCountsTwo = <(Position, int)>[];
    for (final line in input.getPerLine()) {
      final [direction, meters, color, ...] = line.split(' ');
      final countOne = int.parse(meters);
      final offsetOne = switch (direction) {
        'R' => (1, 0),
        'L' => (-1, 0),
        'U' => (0, -1),
        'D' => (0, 1),
        _ => throw StateError('Direction $direction is invalid')
      };
      offsetCountsOne.add((offsetOne, countOne));

      final decodedDirection = color.substring(7, 8);
      final distance = int.parse(color.substring(2, 7), radix: 16);
      final offsetTwo = switch (decodedDirection) {
        '0' => (1, 0),
        '2' => (-1, 0),
        '3' => (0, -1),
        '1' => (0, 1),
        _ => throw StateError('Direction $direction is invalid')
      };
      offsetCountsTwo.add((offsetTwo, distance));
    }

    return (one: offsetCountsOne, two: offsetCountsTwo);
  }

  int solve(OffsetCount offsetCount) {
    final vertices = generateVertices(offsetCount);
    final area = areaUsingShoelace(vertices);
    final b = offsetCount.fold(
      0,
      (previousValue, element) => previousValue + element.$2,
    );
    final i = interiorPointsCount(area, b);
    return i + b;
  }

  /// pick's theorem:
  /// A = i + b / 2 - 1\
  /// So, i = A - b / 2 + 1
  ///
  /// https://en.wikipedia.org/wiki/Pick%27s_theorem
  int interiorPointsCount(int area, int boundaryCount) {
    return area - boundaryCount ~/ 2 + 1;
  }

  int areaUsingShoelace(List<Position> vertices) {
    var previous = vertices.first;
    var areaDouble = 0;
    for (final vertex in vertices.skip(1)) {
      areaDouble += previous.x * vertex.y - (previous.y * vertex.x);
      previous = vertex;
    }
    return areaDouble ~/ 2;
  }

  List<Position> generateVertices(OffsetCount offsetCount) {
    final vertices = <Position>[(0, 0)];
    var vertex = (0, 0);
    for (final (offset, count) in offsetCount) {
      vertex += (offset.x * count, offset.y * count);
      vertices.add(vertex);
    }
    return vertices;
  }

  late final parsedInput = parseInput();

  @override
  int solvePart1() {
    // return solveField(generateField(parsedInput.one));
    return solve(parsedInput.one);
  }

  @override
  int solvePart2() {
    return solve(parsedInput.two);
  }

  int solveField(Field<String> field) {
    final startPosition = getOneInsidePosition(field);
    final copy = field.copy();

    final queue = QueueList<Position>.from([startPosition]);
    copy.setValueAtPosition(startPosition, '#');
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final position in copy.adjacent(current.x, current.y)) {
        if (copy.getValueAtPosition(position) == '.') {
          copy.setValueAtPosition(position, '#');
          queue.add(position);
        }
      }
    }

    return copy.count('#');
  }

  Field<String> generateField(
    List<(Position offset, int count)> offsetCounts,
  ) {
    final positions = <Position>[];
    var position = (0, 0);
    var maxX = 0;
    var maxY = 0;
    var minX = 0;
    var minY = 0;
    for (final (offset, count) in offsetCounts) {
      for (var i = 1; i <= count; i++) {
        position += offset;
        final (x, y) = position;
        if (x > maxX) {
          maxX = x;
        } else if (x < minX) {
          minX = x;
        }
        if (y > maxY) {
          maxY = y;
        } else if (y < minY) {
          minY = y;
        }
        positions.add(position);
      }
    }
    maxX += -minX;
    maxY += -minY;

    final field = Field.fromSize(
      width: maxX + 1,
      height: maxY + 1,
      defaultValue: '.',
    );
    field.forPositions(positions.map((e) => e + (-minX, -minY)), (x, y) {
      field.setValueAt(x, y, '#');
    });
    return field;
  }

  Position getOneInsidePosition(Field<String> field) {
    for (final (y, row) in field.field.indexed) {
      for (final (x, item) in row.indexed) {
        if (item == '#') {
          if (field.isOnField((x + 1, y))) {
            if (field.getValueAt(x + 1, y) == '.') {
              return (x + 1, y);
            } else {
              break;
            }
          }
        }
      }
    }
    throw StateError('Invalid Field: $field');
  }
}
