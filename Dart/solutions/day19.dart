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

typedef WorkflowMap = Map<String, bool Function(Part)>;

class Day19 extends GenericDay {
  Day19() : super(19);

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
    return 0;
  }
}
