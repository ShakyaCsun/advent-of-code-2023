import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12([InputUtil? input]) : super(12, input);

  @override
  List<Reading> parseInput() {
    return input.getPerLine().map<Reading>((e) {
      final [springs, damagedCounts, ...] = e.split(' ');
      return Reading(
        springs.split('').map(Spring.fromString).toList(),
        damagedCounts.split(',').map(int.parse).toList(),
      );
    }).toList();
  }

  @override
  int solvePart1() {
    var result = 0;
    final records = parseInput();
    for (final reading in records) {
      result += reading.solve(memo: {});
    }
    return result;
  }

  @override
  int solvePart2() {
    var result = 0;
    final records = parseInput();
    for (final reading in records) {
      result += Reading(reading.springs.unfold(), [
        for (var i = 0; i < 5; i++) ...reading.damagedCounts,
      ]).solve(memo: {});
    }
    return result;
  }
}

class Reading extends Equatable {
  const Reading(this.springs, this.damagedCounts);

  final List<Spring> springs;
  final List<int> damagedCounts;

  Reading copyWith({List<Spring>? springs, List<int>? damagedCounts}) {
    return Reading(
      springs ?? this.springs,
      damagedCounts ?? this.damagedCounts,
    );
  }

  @override
  String toString() {
    return 'Reading(${springs.join()}, $damagedCounts)';
  }

  int solve({required Map<Reading, int> memo}) {
    if (memo.containsKey(this)) {
      return memo[this]!;
    }

    int memoize(int value) {
      memo[this] = value;
      return value;
    }

    if (springs.isEmpty) {
      if (damagedCounts.isEmpty) {
        return 1;
      }
      return 0;
    }
    if (damagedCounts.isEmpty) {
      if (springs.contains(Spring.damaged)) {
        return 0;
      }
      return 1;
    }

    final minimumValidSpringsLength = damagedCounts.fold(
          0,
          (previousValue, element) => previousValue + element,
        ) +
        damagedCounts.length -
        1;
    final springsLength = springs.length;

    if (minimumValidSpringsLength > springsLength) {
      return 0;
    } else if (minimumValidSpringsLength == springsLength) {
      var start = 0;
      for (final count in damagedCounts) {
        if (springs.sublist(start, start + count).allDamagedOrUnknown) {
          if (count + start < springsLength &&
              springs[count + start] == Spring.damaged) {
            return 0;
          }
        } else {
          return 0;
        }
        start += count + 1;
      }
      return memoize(1);
    }

    switch (springs.first) {
      case Spring.unknown:
        final damagedUnknown =
            copyWith(springs: [Spring.damaged, ...springs.skip(1)]);
        final operationalUnknown =
            copyWith(springs: [Spring.operational, ...springs.skip(1)]);
        return memoize(
          damagedUnknown.solve(memo: memo) +
              operationalUnknown.solve(memo: memo),
        );
      case Spring.damaged:
        if (springs.sublist(0, damagedCounts.first).allDamagedOrUnknown) {
          if (springs[damagedCounts.first] == Spring.damaged) {
            return 0;
          }
          return Reading(
            springs.sublist(damagedCounts.first + 1),
            damagedCounts.sublist(1),
          ).solve(memo: memo);
        }
        return 0;
      case Spring.operational:
        return copyWith(springs: springs.sublist(1)).solve(memo: memo);
    }
  }

  @override
  List<Object?> get props => [springs.join(), damagedCounts];
}

extension SpringListX on List<Spring> {
  /// Unfolded List of Spring for Part 2
  List<Spring> unfold() {
    final unfoldedSprings = <Spring>[];
    for (var i = 0; i < 5; i++) {
      unfoldedSprings
        ..addAll(this)
        ..add(Spring.unknown);
    }
    return unfoldedSprings..removeLast();
  }

  bool get allDamagedOrUnknown {
    return every((element) => element != Spring.operational);
  }
}

enum Spring {
  unknown('?'),
  damaged('#'),
  operational('.');

  const Spring(this.value);
  final String value;
  static Spring fromString(String value) {
    return switch (value) {
      '?' => Spring.unknown,
      '#' => Spring.damaged,
      '.' => Spring.operational,
      _ => throw StateError('Unknown Spring Value'),
    };
  }

  @override
  String toString() {
    return value;
  }
}
