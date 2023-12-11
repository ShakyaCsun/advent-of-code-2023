import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../solutions/day11.dart';
import '../utils/index.dart';

class MockInputUtil extends Mock implements InputUtil {}

InputUtil generateMock() {
  final input = MockInputUtil();
  when(input.getPerLine).thenReturn(
    '''
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....'''
        .split('\n')
        .toList(),
  );
  return input;
}

void main() {
  group('part 1', () {
    test('Expands the universe correctly', () {
      final input = generateMock();
      final expandedUniverse = Day11(input).parseInputPart1();
      expect(
        expandedUniverse.toString(),
        equals('''
....#........
.........#...
#............
.............
.............
........#....
.#...........
............#
.............
.............
.........#...
#....#.......
'''),
      );
    });

    test(
      'Works for sample 1',
      () {
        final input = generateMock();
        final solutionPart1 = Day11(input).solvePart1Solution1();
        expect(solutionPart1, equals(374));
      },
    );
  });

  group('part 2', () {
    test('Works when expanded by 2', () {
      final input = generateMock();
      final solutionPart1 = Day11(input).getSolution();
      expect(solutionPart1, equals(374));
    });

    test('Works when expanded by 10', () {
      final input = generateMock();
      final solutionPart1 = Day11(input).getSolution(expandEmptySpaceBy: 10);
      expect(solutionPart1, equals(1030));
    });

    test('Works when expanded by 100', () {
      final input = generateMock();
      final solutionPart1 = Day11(input).getSolution(expandEmptySpaceBy: 100);
      expect(solutionPart1, equals(8410));
    });
  });
}
