import Algorithms

struct Day22: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let bricks: [Brick]

  init(data: String) {
    self.data = data
    self.bricks = data.lines.map {
      Brick.init(fromNotation: String($0))
    }.sorted(by: { brickA, brickB in brickA.start.z < brickB.start.z })
  }

  func part1() -> Int {
    let (settledBricks, _) = settle(bricks: bricks, recursive: true)
    return settledBricks.reduce(0) {
      safeBricks, brick in
      let bricksAfterRemoval = settledBricks.filter({ $0 != brick })
      let (_, affectedBricks) = settle(bricks: bricksAfterRemoval, recursive: false)

      if affectedBricks == 0 {
        return safeBricks + 1
      }
      return safeBricks
    }
  }

  func part2() -> Int {
    let (settledBricks, _) = settle(bricks: bricks, recursive: false)
    return settledBricks.reduce(0) {
      fallenBricks, brick in
      let bricksAfterRemoval = settledBricks.filter({ $0 != brick })
      let (_, affectedBricks) = settle(bricks: bricksAfterRemoval, recursive: false)
      return fallenBricks + affectedBricks
    }
  }

  func settle(bricks: [Brick], recursive: Bool) -> ([Brick], Int) {
    if recursive {
      func settleBrick(_ brick: Brick, seen: Set<Point3d>) -> Brick {
        let newBrick = brick.fall()
        if seen.isDisjoint(with: newBrick.points) && newBrick.start.z > 0 {
          return settleBrick(newBrick, seen: seen)
        }
        return brick
      }
      let (settledBricks, _, affectedBricks, _) = bricks.reduce(
        ([Brick](), Set<Point3d>(), 0, 1),
        {
          tuple, brick in
          let (bricks, seenPoints, affectedBricks, safeZValue) = tuple
          let safeBrick = brick.fall(by: brick.start.z - safeZValue)
          let settledBrick = settleBrick(safeBrick, seen: seenPoints)
          let possibleSafeZ = settledBrick.end.z + 1

          return (
            bricks + [settledBrick], seenPoints.union(settledBrick.points),
            settledBrick == brick ? affectedBricks : affectedBricks + 1,
            safeZValue > possibleSafeZ ? safeZValue : possibleSafeZ
          )
        })
      return (settledBricks, affectedBricks)
    }
    func settleBrickIterative(_ brick: Brick, seen: Set<Point3d>) -> Brick {
      var newBrick = brick
      while true {
        let fallenBrick = newBrick.fall()
        if seen.isDisjoint(with: fallenBrick.points) && fallenBrick.start.z > 0 {
          newBrick = fallenBrick
        } else {
          return newBrick
        }
      }
    }
    var settledBricks: [Brick] = []
    var affectedBricks: Int = 0
    var seenPoints: Set<Point3d> = []
    var safeZValue = 1
    for brick in bricks {
      let safeBrick = brick.fall(by: brick.start.z - safeZValue)
      let settledBrick = settleBrickIterative(safeBrick, seen: seenPoints)
      let possibleSafeZ = settledBrick.end.z + 1
      settledBricks.append(settledBrick)
      if settledBrick != brick {
        affectedBricks += 1
      }
      seenPoints.formUnion(settledBrick.points)
      safeZValue =
        if safeZValue > possibleSafeZ {
          safeZValue
        } else {
          possibleSafeZ
        }
    }
    return (settledBricks, affectedBricks)

  }
}

struct Brick: Hashable, CustomStringConvertible {

  let start: Point3d
  let end: Point3d

  let points: Set<Point3d>

  var description: String {
    "Brick(start: \(start), end: \(end))"
  }

  init(start: Point3d, end: Point3d) {
    self.start = start
    self.end = end

    let (sx, sy, sz) = start.tuple
    let (ex, ey, ez) = end.tuple

    self.points = Set(
      (sx...ex).map {
        start.copyWith(x: $0)
      }
        + (sy...ey).map {
          start.copyWith(y: $0)
        }
        + (sz...ez).map {
          start.copyWith(z: $0)
        })
  }

  init(fromNotation line: String) {
    let splits = line.split(separator: "~")
    assert(splits.count == 2, "Brick notation should have a single '~' separator.")
    let startPoints = splits[0].split(separator: ",").compactMap { Int($0) }
    let endPoints = splits[1].split(separator: ",").compactMap { Int($0) }
    let start = Point3d(startPoints[0], startPoints[1], startPoints[2])
    let end = Point3d(endPoints[0], endPoints[1], endPoints[2])
    self.init(start: start, end: end)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(start)
    hasher.combine(end)
  }

  func fall(by points: Int = 1) -> Brick {
    Brick(start: start.copyWith(z: start.z - points), end: end.copyWith(z: end.z - points))
  }
}

struct Point3d: Hashable {

  let x, y, z: Int
}

extension Point3d {

  init(_ x: Int, _ y: Int, _ z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }

  func copyWith(x: Int? = nil, y: Int? = nil, z: Int? = nil) -> Point3d {
    Point3d(x ?? self.x, y ?? self.y, z ?? self.z)
  }

  var tuple: (x: Int, y: Int, z: Int) {
    (x, y, z)
  }
}
