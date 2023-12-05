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
    final (seeds, _) = parsedInput;
    final locations = <int>[];
    for (final seed in seeds) {
      final location = seedToLocation(seed);
      locations.add(location);
    }
    return locations.min;
  }

  @override
  int solvePart2() {
    final (seedsWithRange, maps) = parsedInput;
    final seeds = seedsWithRange.slices(2).expand(
          (element) => [(start: element[0], end: element[0] + element[1])],
        );
    final minRange = maps
        .expand((element) => element.values)
        .map((e) => e.destEnd - e.destStart)
        .min;

    bool checkSeedExists(int seed) {
      return seeds
          .any((element) => seed >= element.start && seed < element.end);
    }

    for (var location = 0;; location = location + minRange) {
      final seed = locationToSeed(location);
      if (checkSeedExists(seed)) {
        int searchMinLocationWithSeed(int minLimit, int maxLimit) {
          final range = maxLimit - minLimit;
          if (range < 69) {
            /// Once the range is sufficiently small, just force our solution
            for (var i = minLimit; i < maxLimit; i++) {
              if (checkSeedExists(locationToSeed(i))) {
                return i;
              }
            }
          }
          if (checkSeedExists(locationToSeed(minLimit))) {
            return minLimit;
          }
          final mid = (minLimit + maxLimit) ~/ 2;
          if (checkSeedExists(locationToSeed(mid))) {
            return searchMinLocationWithSeed(minLimit + 1, mid);
          } else {
            return searchMinLocationWithSeed(mid + 1, maxLimit);
          }
        }

        return searchMinLocationWithSeed(location - minRange, location);

        // /// Initial Solution for puzzle two: 50716416 - Took 163185705 microseconds
        // /// very bad/inefficient
        // // Once a valid location is found, go back until
        // // invalid location is found to find the shortest location.
        // for (var j = location; j > location - minRange; j--) {
        //   final newSeed = locationToSeed(j);
        //   if (!checkSeedExists(newSeed)) {
        //     return j + 1;
        //   }
        // }
      }
    }
  }

  late final parsedInput = parseInput();

  int seedToLocation(int seed) {
    return parsedInput.$2.fold(
      seed,
      (previousValue, element) => element.getDestination(previousValue),
    );
  }

  int locationToSeed(int location) {
    return parsedInput.$2.reversed.fold(
      location,
      (previousValue, element) => element.getSource(previousValue),
    );
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

  int getSource(int destination) {
    final entry = entries.firstWhereOrNull(
      (element) =>
          destination >= element.value.destStart &&
          destination < element.value.destEnd,
    );
    if (entry != null) {
      return destination + entry.key.start - entry.value.destStart;
    }
    return destination;
  }
}
