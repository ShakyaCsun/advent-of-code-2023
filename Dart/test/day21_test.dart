// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

import '../solutions/day21.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed, apart from uncommenting
// the puzzle tests for regression testing.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart1` below.
/// Make sure to respect the multiline string format to avoid additional
/// newlines at the end.
const _exampleInput1 = '''
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
''';

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 16;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = 3598;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = 601441063166538;

void main() {
  group(
    'Day 21 - Example Input',
    () {
      test('Part 1', () {
        final day = Day21()
          ..inputForTesting = _exampleInput1
          ..stepsForPart1 = 6;
        expect(day.solvePart1(), _exampleSolutionPart1);
      });
      test('Part 2 - Works for any valid steps', () {
        final day = Day21();
        final field = day.parseInput();
        final start = field.firstWhere('S');
        final size = field.width;
        final validSteps = [
          for (var i = 1; i < 5; i++) size * i + size ~/ 2,
        ];
        final generalizedAnswers = <int>[];
        final bruteForceAnswers = <int>[];
        for (final steps in validSteps) {
          day.stepsForPart2 = steps;
          generalizedAnswers.add(day.solvePart2());
          bruteForceAnswers.add(
            day.solveBruteForce(field: field, start: start, steps: steps),
          );
        }
        expect(
          generalizedAnswers,
          equals(bruteForceAnswers),
        );
      });
    },
  );
  group(
    'Day 21 - Puzzle Input',
    () {
      final day = Day21();
      test(
        'Part 1',
        skip: _puzzleSolutionPart1 == null
            ? 'Skipped because _puzzleSolutionPart1 is null'
            : false,
        () => expect(day.solvePart1(), _puzzleSolutionPart1),
      );
      test(
        'Part 2',
        skip: _puzzleSolutionPart2 == null
            ? 'Skipped because _puzzleSolutionPart2 is null'
            : false,
        () => expect(day.solvePart2(), _puzzleSolutionPart2),
      );
    },
  );
}
