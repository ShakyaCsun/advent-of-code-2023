import Algorithms

struct Day16: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let layout: CharGrid

  init(data: String) {
    self.data = data
    self.layout = CharGrid(fromString: data)
  }

  func part1() -> Int {
    solve(startPoint: DirectedPoint(.origin, direction: .toRight))
  }

  func part2() -> Int {
    let lastRow = layout.height - 1
    let lastCol = layout.width - 1
    let verticalBeams = (0...lastCol).flatMap {
      [
        DirectedPoint(Point($0, 0), direction: .toDown),
        DirectedPoint(Point($0, lastRow), direction: .toUp),
      ]
    }

    let horizontalBeams = (0...lastRow).flatMap {
      [
        DirectedPoint(Point(0, $0), direction: .toRight),
        DirectedPoint(Point(lastCol, $0), direction: .toLeft),
      ]
    }
    return (verticalBeams + horizontalBeams).map {
      solve(startPoint: $0)
    }.max() ?? -1
  }

  func solve(startPoint: DirectedPoint) -> Int {
    func bfs(neighbors: inout Deque<DirectedPoint>, seen: inout Set<DirectedPoint>) {
      if let (point, direction) = neighbors.popFirst()?.tuple {
        let value = layout.getValueAtPoint(point: point)
        let newDirections: [Point] =
          if value == "." || (value == "|" && direction.verticalDirection)
            || (value == "-" && direction.horizontalDirection)
          {
            [direction]
          } else if value == #"\"# {
            [Point(direction.y, direction.x)]
          } else if value == "/" {
            [Point(-direction.y, -direction.x)]
          } else {
            [Point(direction.y, direction.x), Point(-direction.y, -direction.x)]
          }
        newDirections.apply {
          newDirection in
          let nextPoint = DirectedPoint(point + newDirection, direction: newDirection)
          if seen.contains(nextPoint) || !layout.isValidPoint(point: nextPoint.point) {
            return
          }
          neighbors.append(nextPoint)
          seen.insert(nextPoint)
          bfs(neighbors: &neighbors, seen: &seen)
        }
      }
    }
    var deque: Deque = [startPoint]
    var seen: Set<DirectedPoint> = [startPoint]
    bfs(neighbors: &deque, seen: &seen)
    return Set(seen.map { $0.point }).count
  }
}

struct DirectedPoint: Hashable {
  static func == (lhs: DirectedPoint, rhs: DirectedPoint) -> Bool {
    lhs.point == rhs.point && lhs.direction == rhs.direction
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(point)
    hasher.combine(direction)
  }

  let point: Point
  let direction: Point
  /// Tuple for easy destructing
  let tuple: (Point, Point)

  init(_ point: Point, direction: Point) {
    self.point = point
    self.direction = direction
    self.tuple = (point, direction)
  }
}

extension Point {

  var verticalDirection: Bool {
    self == .toDown || self == .toUp
  }

  var horizontalDirection: Bool {
    self == .toLeft || self == .toRight
  }
}
