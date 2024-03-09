import Algorithms

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let pipeMaze: Grid2d<Character>
  let startPoint: Point
  let startChar: Character

  init(data: String) {
    self.data = data
    let grid = Grid2d<Character>(fromString: data)
    self.pipeMaze = grid
    let startPoint = grid.firstWhere(value: "S")!
    self.startPoint = startPoint
    let validOffsets = grid.validConnections(point: startPoint).map { $0 - startPoint }
    self.startChar =
      if validOffsets.containsAll([Point.toLeft, Point.toUp]) {
        "J"
      } else if validOffsets.containsAll([Point.toLeft, Point.toRight]) {
        "-"
      } else if validOffsets.containsAll([Point.toLeft, Point.toDown]) {
        "7"
      } else if validOffsets.containsAll([Point.toUp, Point.toRight]) {
        "L"
      } else if validOffsets.containsAll([Point.toDown, Point.toRight]) {
        "F"
      } else if validOffsets.containsAll([Point.toUp, Point.toDown]) {
        "|"
      } else {
        // Not Happening
        "S"
      }
  }

  /// mutable = true, runs in ~12 ms
  /// mutable = false, runs in ~2200 ms
  func pipeLoop(mutable: Bool = true) -> OrderedSet<Point> {
    func generateLoopInOut(currentPoint: Point, path: inout OrderedSet<Point>) {
      let validNeighbors = pipeMaze.validConnections(point: currentPoint)
      if let nextPoint = validNeighbors.first(where: { !path.contains($0) }) {
        path.append(nextPoint)
        generateLoopInOut(currentPoint: nextPoint, path: &path)
      }
    }

    if mutable {
      var path = OrderedSet([startPoint])
      generateLoopInOut(currentPoint: startPoint, path: &path)
      return path
    }

    func generateLoop(currentPoint: Point, currentPath: OrderedSet<Point>) -> OrderedSet<Point> {
      let validNeighbors = pipeMaze.validConnections(point: currentPoint)
      if let nextPoint = validNeighbors.first(where: { !currentPath.contains($0) }) {
        return generateLoop(
          currentPoint: nextPoint, currentPath: currentPath.union(CollectionOfOne(nextPoint))
        )
      }
      return currentPath
    }

    return generateLoop(currentPoint: startPoint, currentPath: [startPoint])
  }

  func part1() -> Int {
    // pipeMaze.printValuesAt(points: pipeLoop())

    return pipeLoop().count / 2
  }

  func part2() -> Int {
    let loopPath = pipeLoop()
    let vertices = loopPath.filter {
      point in
      let value = pipeMaze.getValueAtPoint(point: point)
      return !["-", "|"].contains(value)
    }
    let area = areaShoeLace(vertices: vertices + [vertices[0]])
    return interiorPoints(area: area, boundaryCount: loopPath.count)
  }
}

extension Grid2d<Character> {

  fileprivate func validConnections(point: Point) -> [Point] {
    let validOffsets: [Point] =
      switch getValueAtPoint(point: point) {
      case "S":
        [Point(0, 1), Point(1, 0), Point(0, -1), Point(-1, 0)]
      case "L":
        [Point(0, -1), Point(1, 0)]
      case "|":
        [Point(0, 1), Point(0, -1)]
      case "F":
        [Point(0, 1), Point(1, 0)]
      case "7":
        [Point(-1, 0), Point(0, 1)]
      case "-":
        [Point(-1, 0), Point(1, 0)]
      case "J":
        [Point(-1, 0), Point(0, -1)]
      default:
        []
      }
    if getValueAtPoint(point: point) == "S" {
      let validPoints = validOffsets.map { $0 + point }.filter {
        isValidPoint(point: $0) && validConnections(point: $0).contains(point)
      }
      assert(validPoints.count == 2)
      return validPoints
    }
    return validOffsets.map { $0 + point }.filter(isValidPoint)
  }
}
