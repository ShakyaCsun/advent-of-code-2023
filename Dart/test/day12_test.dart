import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../solutions/day12.dart';
import '../utils/index.dart';

class MockInputUtil extends Mock implements InputUtil {}

InputUtil generateMock() {
  final input = MockInputUtil();
  when(input.getPerLine).thenReturn(
    '''
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1'''
        .split('\n')
        .toList(),
  );
  return input;
}

void main() {
  group('part 1', () {
    test(
      'Works for sample 1',
      () {
        final input = generateMock();
        final solutionPart1 = Day12(input).solvePart1();
        expect(solutionPart1, equals(21));
      },
    );
  });

  group('part 2', () {
    test('Works for sample', () {
      final input = generateMock();
      final solutionPart2 = Day12(input).solvePart2();
      expect(solutionPart2, equals(0));
    });
  });
}
