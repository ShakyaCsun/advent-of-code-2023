import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  void parseInput() {}

  @override
  int solvePart1() {
    var result = 0;

    for (final (index, game) in input.getPerLine().indexed) {
      final [_, shownBalls, ...] = game.split(': ');
      var validGame = true;

      matchLoop:
      for (final match in RegExp(r'(\d+)').allMatches(shownBalls)) {
        if (match.end - match.start > 1) {
          final ballCount = int.parse(match.group(0)!);
          final ballColor =
              shownBalls.substring(match.end + 1).split(RegExp(',|;'))[0];
          switch (ballColor) {
            case 'red':
              if (ballCount > 12) {
                validGame = false;
                break matchLoop;
              }
            case 'green':
              if (ballCount > 13) {
                validGame = false;
                break matchLoop;
              }
            case 'blue':
              if (ballCount > 14) {
                validGame = false;
                break matchLoop;
              }
          }
        }
      }

      if (validGame) {
        result += index + 1;
      }
    }
    return result;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

typedef BallsCount = ({int green, int red, int blue});
