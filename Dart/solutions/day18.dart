import '../utils/index.dart';

class Day18 extends GenericDay {
  Day18() : super(18);

  @override
  List<({Position position, String colorHex})> parseInput() {
    final positionsWithColor = <({Position position, String colorHex})>[];
    var lastPosition = (0, 0);
    var maxX = 0;
    var maxY = 0;
    var minX = 0;
    var minY = 0;
    for (final line in input.getPerLine()) {
      final [direction, meters, color, ...] = line.split(' ');
      final m = int.parse(meters);
      for (var i = 1; i <= m; i++) {
        final toAdd = switch (direction) {
          'R' => (1, 0),
          'L' => (-1, 0),
          'U' => (0, -1),
          'D' => (0, 1),
          _ => throw StateError('Direction $direction is invalid')
        };
        lastPosition += toAdd;
        final (x, y) = lastPosition;
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
        positionsWithColor.add((position: lastPosition, colorHex: color));
      }
    }
    return positionsWithColor.map((e) {
      return (position: e.position + (-minX, -minY), colorHex: e.colorHex);
    }).toList();
  }

  @override
  int solvePart1() {
    final positionsWithColor = parseInput();
    final positions = positionsWithColor.map((e) => e.position);
    final fieldWidth = positionsWithColor.map((e) => e.position.x).max + 1;
    final fieldHeight = positionsWithColor.map((e) => e.position.y).max + 1;
    final field = Field.fromSize(
      width: fieldWidth,
      height: fieldHeight,
      defaultValue: '.',
    );
    field.forPositions(positions, (x, y) {
      field.setValueAt(x, y, '#');
    });
    var insidePosition = (0, 0);

    rowLoop:
    for (final (y, row) in field.field.indexed) {
      for (final (x, item) in row.indexed) {
        if (item == '#') {
          if (field.isOnField((x + 1, y))) {
            if (field.getValueAt(x + 1, y) == '.') {
              insidePosition = (x + 1, y);
              break rowLoop;
            } else {
              break;
            }
          }
        }
      }
    }
    final queue = QueueList<Position>.from([insidePosition]);
    field.setValueAtPosition(insidePosition, '#');
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final position in field.adjacent(current.x, current.y)) {
        if (field.getValueAtPosition(position) == '.') {
          field.setValueAtPosition(position, '#');
          queue.add(position);
        }
      }
    }

    return field.count('#');
  }

  @override
  int solvePart2() {
    return 0;
  }
}
