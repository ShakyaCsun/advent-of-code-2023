import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day22 extends GenericDay {
  Day22() : super(22);

  @override
  List<Brick> parseInput() {
    final snapshots = input.getPerLine().map((e) => e.split('~'));
    final bricks = <Brick>[];
    for (final [left, right] in snapshots) {
      final [sx, sy, sz] = left.split(',').map(int.parse).toList();
      final [ex, ey, ez] = right.split(',').map(int.parse).toList();

      bricks.add(
        Brick(
          cubes: {
            for (var x = sx; x <= ex; x++) (x, sy, sz),
            for (var y = sy; y <= ey; y++) (sx, y, sz),
            for (var z = sz; z <= ez; z++) (sx, sy, z),
          }.toList(),
        ),
      );
    }
    return bricks;
  }

  int? part2Answer;

  @override
  int solvePart1() {
    final bricks = parseInput().sorted(
      (a, b) => a.start.z.compareTo(b.start.z),
    );
    final (bricksAfterInitialFall, _) = simulateFinalPositions(bricks);
    final (:part1, :part2) = removeBricks(bricksAfterInitialFall);
    part2Answer = part2;
    return part1;
  }

  @override
  int solvePart2() {
    final answer = part2Answer;
    if (answer == null) {
      final bricks = parseInput().sorted(
        (a, b) => a.start.z.compareTo(b.start.z),
      );
      final (bricksAfterInitialFall, _) = simulateFinalPositions(bricks);
      final (part1: _, :part2) = removeBricks(bricksAfterInitialFall);
      part2Answer = part2;
      return part2;
    }
    return answer;
  }

  (List<Brick>, int) simulateFinalPositions(List<Brick> bricks) {
    final seen = <Point3D>{};
    final fallenBricks = <Brick>[];
    var bricksThatFell = 0;
    for (final brick in bricks) {
      var newBrick = brick.copy();
      var fallenBrick = newBrick.fall();
      while (fallenBrick.cubes.none(seen.contains) && fallenBrick.start.z > 0) {
        newBrick = fallenBrick;
        fallenBrick = newBrick.fall();
      }
      seen.addAll(newBrick.cubes);
      if (brick != newBrick) {
        bricksThatFell++;
      }
      fallenBricks.add(newBrick);
    }
    return (fallenBricks, bricksThatFell);
  }

  ({int part1, int part2}) removeBricks(List<Brick> bricks) {
    var safeToRemoveBricks = 0;
    var sumOfBricksAffected = 0;
    for (final brick in bricks) {
      final copy = [...bricks]..remove(brick);
      final (_, bricksAffected) = simulateFinalPositions(copy);
      if (bricksAffected == 0) {
        safeToRemoveBricks++;
      } else {
        sumOfBricksAffected += bricksAffected;
      }
    }
    return (part1: safeToRemoveBricks, part2: sumOfBricksAffected);
  }
}

class Brick extends Equatable {
  const Brick({required this.cubes});

  final List<Point3D> cubes;

  @override
  bool? get stringify => true;

  Brick fall() {
    return Brick(cubes: [...cubes].map((e) => (e.x, e.y, e.z - 1)).toList());
  }

  bool get isVertical => start.z < end.z;

  Point3D get start => cubes.first;
  Point3D get end => cubes.last;

  Brick copy() {
    return Brick(cubes: [...cubes]);
  }

  @override
  List<Object> get props => [cubes];
}
