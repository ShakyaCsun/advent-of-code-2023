import 'package:meta/meta.dart';

import '../utils/index.dart';

class Day24 extends GenericDay {
  Day24() : super(24);

  @override
  List<(Point3D position, Point3D velocity)> parseInput() {
    final hailPositions =
        input.getPerLine().map((e) => e.split(' @ ')).toList();
    final parsedData = <(Point3D, Point3D)>[];
    for (final hailPosition in hailPositions) {
      final [position, velocity, ...] = hailPosition;
      final [x, y, z, ...] = position.split(', ');
      final [vx, vy, vz, ...] = velocity.split(', ');
      parsedData.add(
        (
          (
            int.parse(x),
            int.parse(y),
            int.parse(z),
          ),
          (
            int.parse(vx),
            int.parse(vy),
            int.parse(vz),
          ),
        ),
      );
    }
    return parsedData;
  }

  @visibleForTesting
  set testRange(Line3D range) {
    _testRange = range;
  }

  Line3D get testRange => _testRange;

  Line3D _testRange = (
    (200000000000000, 200000000000000, 200000000000000),
    (400000000000000, 400000000000000, 400000000000000),
  );

  @override
  int solvePart1() {
    final positionVelocityData = parseInput();
    final lines = positionVelocityData
        .map(
          (e) => e.$1.getLineSegment(e.$2),
        )
        .toList();
    final linesLength = lines.length;
    var intersectingHailStones = 0;
    for (var i = 0; i < linesLength - 1; i++) {
      for (var j = i + 1; j < linesLength; j++) {
        final line1 = lines[i];
        final line2 = lines[j];
        final pointOfIntersection = line1.intersectionXY(line2);
        if (pointOfIntersection != null) {
          // print('$line1 - $line2 --> $pointOfIntersection');
          final (x, y) = pointOfIntersection;
          final containsPointXY = testRange.containsPointXY(x, y);
          // if (!containsPointXY) {
          //   print(pointOfIntersection);
          // }
          if (containsPointXY &&
              line1.willMeetPointXY(x, y) &&
              line2.willMeetPointXY(x, y)) {
            intersectingHailStones++;
          }
        }
      }
    }
    return intersectingHailStones;
  }

  @override
  int solvePart2() {
    return 0;
  }
}

typedef Point3D = (int, int, int);

extension PointExtensions on Point3D {
  int get x => $1;
  int get y => $2;
  int get z => $3;

  Line3D getLineSegment(Point3D velocity) {
    return (this, (x + velocity.x, y + velocity.y, z + velocity.z));
  }
}

typedef Line3D = (Point3D, Point3D);

extension LineExtensions on Line3D {
  Point3D get p1 => $1;
  Point3D get p2 => $2;
  BigInt get x1 => BigInt.from(p1.x);
  BigInt get y1 => BigInt.from(p1.y);
  BigInt get z1 => BigInt.from(p1.z);
  BigInt get x2 => BigInt.from(p2.x);
  BigInt get y2 => BigInt.from(p2.y);
  BigInt get z2 => BigInt.from(p2.z);

  bool containsPointXY(double x, double y) {
    if (x >= x1.toInt() &&
        x <= x2.toInt() &&
        y >= y1.toInt() &&
        y <= y2.toInt()) {
      return true;
    }
    return false;
  }

  bool willMeetPointXY(double x, double y) {
    final xGoesDecreasing = x1 >= x2 && x1 >= BigInt.from(x);
    final xGoesIncreasing = x1 <= x2 && x1 <= BigInt.from(x);
    final yGoesDecreasing = y1 >= y2 && y1 >= BigInt.from(y);
    final yGoesIncreasing = y1 <= y2 && y1 <= BigInt.from(y);
    return (xGoesIncreasing || xGoesDecreasing) &&
        (yGoesIncreasing || yGoesDecreasing);
  }

  /// Returns Point of Intersection with [other] Line if only considering
  /// (x, y) or 2D plane.
  /// Returns `null` if lines are parallel or coincident.
  (double x, double y)? intersectionXY(Line3D other) {
    final denominator = ((x1 - x2) * (other.y1 - other.y2)) -
        ((y1 - y2) * (other.x1 - other.x2));
    if (denominator == BigInt.zero) {
      // Lines are parallel
      return null;
    }
    final numeratorX = ((x1 * y2 - y1 * x2) * (other.x1 - other.x2)) -
        ((x1 - x2) * (other.x1 * other.y2 - other.y1 * other.x2));
    final numeratorY = ((x1 * y2 - y1 * x2) * (other.y1 - other.y2)) -
        ((y1 - y2) * (other.x1 * other.y2 - other.y1 * other.x2));
    return (numeratorX / denominator, numeratorY / denominator);
  }
}
