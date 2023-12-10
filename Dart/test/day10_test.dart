import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../solutions/day10.dart';
import '../utils/index.dart';

class MockInputUtil extends Mock implements InputUtil {}

void main() {
  group('part 2', () {
    test(
      'Works for sample 1',
      () {
        final input = MockInputUtil();
        when(input.getPerLine).thenReturn(
          '''
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........'''
              .split('\n')
              .toList(),
        );
        final solutionPart2 = Day10(input).solvePart2();
        expect(solutionPart2, equals(4));
      },
    );

    test(
      'Works for sample 2',
      () {
        final input = MockInputUtil();
        when(input.getPerLine).thenReturn(
          '''
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...'''
              .split('\n')
              .toList(),
        );
        final solutionPart2 = Day10(input).solvePart2();
        expect(solutionPart2, equals(8));
      },
    );

    test(
      'Works for sample 3',
      () {
        final input = MockInputUtil();
        when(input.getPerLine).thenReturn(
          '''
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L'''
              .split('\n')
              .toList(),
        );
        final solutionPart2 = Day10(input).solvePart2();
        expect(solutionPart2, equals(10));
      },
    );
  });
}
