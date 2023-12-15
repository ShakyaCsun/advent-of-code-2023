import 'package:test/test.dart';

import '../solutions/day10.dart';

void main() {
  group(
    'Day 10',
    () {
      group('Part 1', () {
        test('works for sample 1', () {
          final day = Day10()..inputForTesting = _sampleMaze1;
          expect(day.solvePart1(), 4);
        });
        test('works for sample 2', () {
          final day = Day10()..inputForTesting = _sampleMaze2;
          expect(day.solvePart1(), 8);
        });
      });

      group('Part 2', () {
        test('works for sample 1', () {
          final day = Day10()..inputForTesting = _complexMaze1;
          expect(day.solvePart2(), 4);
        });
        test('works for sample 2', () {
          final day = Day10()..inputForTesting = _complexMaze2;
          expect(day.solvePart2(), 8);
        });
        test('works for sample 3', () {
          final day = Day10()..inputForTesting = _complexMaze3;
          expect(day.solvePart2(), 10);
        });
      });
    },
  );

  group(
    'Day 10 - Puzzle Input',
    () {
      final day = Day10();
      test(
        'Part 1',
        () => expect(day.solvePart1(), equals(6823)),
      );
      test(
        'Part 2',
        () => expect(day.solvePart2(), equals(415)),
      );
    },
  );
}

const _sampleMaze1 = '''
.....
.S-7.
.|.|.
.L-J.
.....
''';

const _sampleMaze2 = '''
..F7.
.FJ|.
SJ.L7
|F--J
LJ...''';

const _complexMaze1 = '''
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........''';

const _complexMaze2 = '''
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...''';

const _complexMaze3 = '''
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L''';
