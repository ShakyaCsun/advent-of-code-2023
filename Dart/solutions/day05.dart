import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  (List<int> seeds, List<SourceMap> maps) parseInput() {
    final seeds = <int>[];
    final maps = <SourceMap>[];
    for (final element in input.asString.trim().split(RegExp(r'\n\n'))) {
      if (element.startsWith('seeds: ')) {
        seeds.addAll(element.split(': ')[1].split(' ').map(int.parse));
      } else {
        final sourceMap =
            <({int start, int end}), ({int destStart, int destEnd})>{};
        for (final mapNumbers in element.split(RegExp(r'\n')).sublist(1)) {
          final [dest, source, countStr, ...] = mapNumbers.split(' ');
          final destStart = int.parse(dest);
          final sourceStart = int.parse(source);
          final count = int.parse(countStr);
          sourceMap.addAll({
            (start: sourceStart, end: sourceStart + count): (
              destStart: destStart,
              destEnd: destStart + count
            ),
          });
        }
        maps.add(sourceMap);
      }
    }
    return (seeds, maps);
  }

  @override
  int solvePart1() {
    final (seeds, maps) = parseInput();
    final locations = <int>[];
    for (final seed in seeds) {
      final location = maps.fold(
        seed,
        (previousValue, element) => element.getDestination(previousValue),
      );
      locations.add(location);
    }
    return locations.min;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

typedef SourceMap = Map<({int start, int end}), ({int destStart, int destEnd})>;

extension on SourceMap {
  int getDestination(int source) {
    final key = keys.firstWhereOrNull(
      (element) => source >= element.start && source < element.end,
    );
    if (key != null) {
      return this[key]!.destStart + source - key.start;
    }
    return source;
  }
}
