struct Point: Equatable, Hashable {
  let x, y: Int

  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }

  static let origin: Point = Point(0, 0)

  static let toRight: Point = Point(0, 1)
  static let toLeft: Point = Point(0, -1)
  static let toUp: Point = Point(-1, 0)
  static let toDown: Point = Point(1, 0)

  var adjacent: [Point] {
    [.toUp, .toRight, .toDown, .toLeft].map {
      $0 + self
    }
  }

  var neighbours: [Point] {
    [
      .toUp, .toRight, .toDown, .toLeft,
      Point(-1, -1), Point(1, -1), Point(-1, 1), Point(1, 1),
    ].map {
      $0 + self
    }
  }

  var tuple: (x: Int, y: Int) {
    (x: x, y: y)
  }

  func distance(other: Point) -> Int {
    let (x:x0, y:y0) = tuple
    let (x:x1, y:y1) = other.tuple
    return abs(x1 - x0) + abs(y1 - y0)
  }

  static func == (lhs: Point, rhs: Point) -> Bool {
    lhs.tuple == rhs.tuple
  }

  static func + (lhs: Point, rhs: Point) -> Point {
    Point(lhs.x + rhs.x, lhs.y + rhs.y)
  }
}
