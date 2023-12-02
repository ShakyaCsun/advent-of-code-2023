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
    var result = 0;
    for (final game in input.getPerLine()) {
      var maxRed = 0;
      var maxGreen = 0;
      var maxBlue = 0;
      final [_, shownBalls, ...] = game.split(': ');
      // List is now in the form of [count, color, count, color, ...]
      final countColorList =
          shownBalls.replaceAll(RegExp(',|;'), '').split(' ');
      for (var i = 0; i < countColorList.length - 1; i = i + 2) {
        final count = int.parse(countColorList.elementAt(i));
        final color = countColorList.elementAt(i + 1);
        switch (color) {
          case 'red':
            if (count > maxRed) maxRed = count;
          case 'green':
            if (count > maxGreen) maxGreen = count;
          case 'blue':
            if (count > maxBlue) maxBlue = count;
        }
      }
      result += maxRed * maxGreen * maxBlue;
    }
    return result;
  }
}

typedef BallsCount = ({int green, int red, int blue});
