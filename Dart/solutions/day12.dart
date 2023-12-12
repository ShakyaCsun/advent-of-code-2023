import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12([InputUtil? input]) : super(12, input);

  @override
  List<(List<Spring> springs, List<int> damagedCounts)> parseInput() {
    return input
        .getPerLine()
        .map<(List<Spring> springs, List<int> damagedCounts)>((e) {
      final [springs, damagedCounts, ...] = e.split(' ');
      return (
        springs.split('').map(Spring.fromString).toList(),
        damagedCounts.split(',').map(int.parse).toList()
      );
    }).toList();
  }

  @override
  int solvePart1() {
    var result = 0;
    final records = parseInput();
    for (final (List<Spring> springs, List<int> damagedCounts) in records) {
      result += Reading(springs, damagedCounts).solve(memo: {});
    }
    return result;
  }

  @override
  int solvePart2() {
    var result = 0;
    final records = parseInput();
    for (final (List<Spring> springs, List<int> damagedCounts) in records) {
      result += Reading(springs.unfold(), [
        for (var i = 0; i < 5; i++) ...damagedCounts,
      ]).solve(memo: {});
    }
    return result;
  }
}

class Reading extends Equatable {
  const Reading(this.springs, this.damagedCounts);

  final List<Spring> springs;
  final List<int> damagedCounts;

  bool get valid {
    return currentDamagedCounts() == damagedCounts;
  }

  List<int> currentDamagedCounts() {
    return springs.consecutivePairs().map((e) => e.length).toList()
      ..retainWhere((element) => element != 0);
  }

  Reading copyWith({List<Spring>? springs, List<int>? damagedCounts}) {
    return Reading(
      springs ?? this.springs,
      damagedCounts ?? this.damagedCounts,
    );
  }

  int solve({required Map<Reading, int> memo}) {
    if (memo.containsKey(this)) {
      return memo[this]!;
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
    if (damagedCounts.fold(
              0,
              (previousValue, element) => previousValue + element,
            ) +
            damagedCounts.length -
            1 >
        springs.length) {
      return 0;
    }
    if (damagedCounts.length == 1) {
      if (springs.length == damagedCounts.first &&
          springs.allDamagedOrUnknown) {
        return 1;
      }
    }
    switch (springs.first) {
      case Spring.unknown:
        final damagedUnknown =
            copyWith(springs: [Spring.damaged, ...springs.skip(1)]);
        final operationalUnknown =
            copyWith(springs: [Spring.operational, ...springs.skip(1)]);
        memo[damagedUnknown] = damagedUnknown.solve(memo: memo);
        memo[operationalUnknown] = operationalUnknown.solve(memo: memo);
        return memo[damagedUnknown]! + memo[operationalUnknown]!;
      case Spring.damaged:
        if (springs.sublist(0, damagedCounts.first).allDamagedOrUnknown) {
          if (springs[damagedCounts.first] == Spring.damaged) {
            memo[this] = 0;
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

  bool get allDamaged => every((element) => element == Spring.damaged);
  bool get allDamagedOrUnknown =>
      every((element) => element != Spring.operational);
  bool get allUnknown => every((element) => element == Spring.unknown);
  List<List<Spring>> consecutivePairs() {
    final pairGroups = <List<Spring>>[];
    var start = 0;
    for (final (index, spring) in indexed) {
      if (spring == Spring.operational) {
        pairGroups.add(skip(start).take(index - start).toList());
        start = index + 1;
      }
    }
    pairGroups.add(skip(start).toList());
    return pairGroups;
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
