import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Part extends Equatable {
  const Part({
    required this.x,
    required this.m,
    required this.a,
    required this.s,
  });

  factory Part.fromRatings(String part) {
    final ratings = part.substring(1, part.length - 1).split(',');
    final [x, m, a, s, ...] = ratings.map((e) {
      return int.parse(e.substring(2));
    }).toList();
    return Part(x: x, m: m, a: a, s: s);
  }

  final int x;
  final int m;
  final int a;
  final int s;

  int get total => x + m + a + s;

  Part copyWith({
    int? x,
    int? m,
    int? a,
    int? s,
  }) {
    return Part(
      x: x ?? this.x,
      m: m ?? this.m,
      a: a ?? this.a,
      s: s ?? this.s,
    );
  }

  String evalCondition(String condition) {
    if (condition.length < 5) {
      return condition;
    }
    int toCheck;
    switch (condition.substring(0, 1)) {
      case 'x':
        toCheck = x;
      case 'm':
        toCheck = m;
      case 'a':
        toCheck = a;
      case 's':
        toCheck = s;
      default:
        throw StateError('invalid part in condition $condition');
    }
    final [comparison, result, ...] = condition.substring(1).split(':');
    final amount = int.parse(comparison.substring(1));
    if (comparison.startsWith('<')) {
      if (toCheck < amount) {
        return result;
      }
      return '';
    } else {
      if (toCheck > amount) {
        return result;
      }
      return '';
    }
  }

  @override
  List<Object> get props => [x, m, a, s];
}

enum Comparison {
  lessThan,
  greaterThan,
}

enum RatingCategory {
  x,
  m,
  a,
  s,
}

class PartRange extends Equatable {
  const PartRange({required this.lower, required this.upper});
  const PartRange.initial()
      : this(
          lower: const Part(x: 1, m: 1, a: 1, s: 1),
          upper: const Part(x: 4000, m: 4000, a: 4000, s: 4000),
        );

  final Part lower;
  final Part upper;

  int get combinations {
    return (upper.x - lower.x + 1) *
        (upper.m - lower.m + 1) *
        (upper.a - lower.a + 1) *
        (upper.s - lower.s + 1);
  }

  bool get isValid {
    return upper.x >= lower.x &&
        upper.m >= lower.m &&
        upper.a >= lower.a &&
        upper.s >= lower.s;
  }

  ({PartRange valid, PartRange invalid}) splitRange(
    RatingCategory category,
    Comparison comparison,
    int value,
  ) {
    switch ((category, comparison)) {
      case (RatingCategory.x, Comparison.greaterThan):
        return (
          valid: PartRange(lower: lower.copyWith(x: value + 1), upper: upper),
          invalid: PartRange(lower: lower, upper: upper.copyWith(x: value))
        );
      case (RatingCategory.x, Comparison.lessThan):
        return (
          valid: PartRange(lower: lower, upper: upper.copyWith(x: value - 1)),
          invalid: PartRange(lower: lower.copyWith(x: value), upper: upper)
        );
      case (RatingCategory.m, Comparison.greaterThan):
        return (
          valid: PartRange(lower: lower.copyWith(m: value + 1), upper: upper),
          invalid: PartRange(lower: lower, upper: upper.copyWith(m: value))
        );
      case (RatingCategory.m, Comparison.lessThan):
        return (
          valid: PartRange(lower: lower, upper: upper.copyWith(m: value - 1)),
          invalid: PartRange(lower: lower.copyWith(m: value), upper: upper)
        );
      case (RatingCategory.a, Comparison.greaterThan):
        return (
          valid: PartRange(lower: lower.copyWith(a: value + 1), upper: upper),
          invalid: PartRange(lower: lower, upper: upper.copyWith(a: value))
        );
      case (RatingCategory.a, Comparison.lessThan):
        return (
          valid: PartRange(lower: lower, upper: upper.copyWith(a: value - 1)),
          invalid: PartRange(lower: lower.copyWith(a: value), upper: upper)
        );
      case (RatingCategory.s, Comparison.greaterThan):
        return (
          valid: PartRange(lower: lower.copyWith(s: value + 1), upper: upper),
          invalid: PartRange(lower: lower, upper: upper.copyWith(s: value))
        );
      case (RatingCategory.s, Comparison.lessThan):
        return (
          valid: PartRange(lower: lower, upper: upper.copyWith(s: value - 1)),
          invalid: PartRange(lower: lower.copyWith(s: value), upper: upper)
        );
    }
  }

  @override
  List<Object> get props => [lower, upper];
}

typedef WorkflowMap = Map<String, bool Function(Part)>;

class WorkflowRule extends Equatable {
  const WorkflowRule(this.category, this.comparison, this.value, this.result);

  final RatingCategory category;
  final Comparison comparison;
  final int value;
  final String result;

  static WorkflowRule? tryParse(String rule) {
    if (rule.length < 5) {
      return null;
    }
    final RatingCategory category;
    switch (rule.substring(0, 1)) {
      case 'x':
        category = RatingCategory.x;
      case 'm':
        category = RatingCategory.m;
      case 'a':
        category = RatingCategory.a;
      case 's':
        category = RatingCategory.s;
      default:
        throw StateError('invalid rule: $rule');
    }
    final [comparison, result, ...] = rule.substring(1).split(':');
    final value = int.parse(comparison.substring(1));
    return WorkflowRule(
      category,
      comparison.startsWith('<') ? Comparison.lessThan : Comparison.greaterThan,
      value,
      result,
    );
  }

  @override
  List<Object> get props => [category, comparison, value, result];
}

class Day19 extends GenericDay {
  Day19() : super(19);

  Map<String, List<String>> parseRules() {
    final [workflows, ...] = input.getBy('\n\n');
    final workflowRules = <String, List<String>>{};
    for (final workflow in const LineSplitter().convert(workflows)) {
      final [name, conditions, ...] =
          workflow.substring(0, workflow.length - 1).split('{');
      workflowRules[name] = conditions.split(',');
    }
    return workflowRules;
  }

  @override
  (WorkflowMap, List<Part>) parseInput() {
    final lineSplitter = const LineSplitter().convert;
    final [workflows, parts, ...] = input.getBy('\n\n');
    final workflowMap = <String, bool Function(Part)>{};
    for (final workflow in lineSplitter(workflows)) {
      final [name, conditions, ...] =
          workflow.substring(0, workflow.length - 1).split('{');
      bool checkPart(Part part) {
        for (final condition in conditions.split(',')) {
          final result = part.evalCondition(condition);
          if (result.isEmpty) {
            continue;
          }
          switch (result) {
            case 'R':
              return false;
            case 'A':
              return true;
            default:
              return workflowMap[result]!(part);
          }
        }
        throw StateError('Impossible: $part');
      }

      workflowMap[name] = checkPart;
    }
    final partsList = lineSplitter(parts).map(Part.fromRatings).toList();
    return (workflowMap, partsList);
  }

  @override
  int solvePart1() {
    final (workflow, parts) = parseInput();
    var result = 0;
    for (final part in parts) {
      if (workflow['in']!(part)) {
        result += part.total;
      }
    }
    return result;
  }

  @override
  int solvePart2() {
    final workflowRules = parseRules();
    final queue = QueueList<(String, PartRange)>()
      ..add(('in', const PartRange.initial()));
    var totalAcceptableCombinations = 0;
    while (queue.isNotEmpty) {
      final (name, range) = queue.removeFirst();
      switch (name) {
        case 'A':
          totalAcceptableCombinations += range.combinations;
        case 'R':
          continue;
        default:
          var rangeLeft = range;
          for (final rule in workflowRules[name]!) {
            final condition = WorkflowRule.tryParse(rule);
            if (condition == null) {
              queue.add((rule, rangeLeft));
            } else {
              final (:valid, :invalid) = rangeLeft.splitRange(
                condition.category,
                condition.comparison,
                condition.value,
              );
              queue.add((condition.result, valid));
              rangeLeft = invalid;
            }
          }
      }
    }

    return totalAcceptableCombinations;
  }
}
