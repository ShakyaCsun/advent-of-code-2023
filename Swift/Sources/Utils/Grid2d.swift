struct Grid2d<Element: Hashable>: Hashable, CustomStringConvertible {
  let rows: [[Element]]
  let columns: [[Element]]
  let width: Int
  let height: Int

  init(rows: [[Element]]) {
    assert(!rows.isEmpty)
    assert(!rows.first!.isEmpty)
    let width = rows.first!.count
    assert(rows.allSatisfy({ $0.count == width }))
    self.height = rows.count
    self.width = width
    self.rows = rows
    self.columns = (0..<width).map({ column in rows.map { $0[column] } })
  }

  init(columns: [[Element]]) {
    self.init(rows: Grid2d(rows: columns).columns)
  }

  static func == (lhs: Grid2d, rhs: Grid2d) -> Bool {
    return lhs.rows == rhs.rows
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(rows)
  }

  var allPoints: [Point] {
    (0..<width).flatMap { x in (0..<height).map { y in Point(x, y) } }
  }

  /// The last index of Grid
  var lastPoint: Point {
    Point(width - 1, height - 1)
  }

  var description: String {
    return rows.map {
      row in
      row.reduce("") {
        $0 + "\($1)"
      }
    }.joined(separator: "\n")
  }

  var transpose: Grid2d<Element> {
    Grid2d(rows: columns)
  }

  var flipX: Grid2d<Element> {
    Grid2d(rows: rows.reversed())
  }

  var flipY: Grid2d<Element> {
    Grid2d(
      rows: rows.map {
        row in row.reversed()
      }
    )
  }

  func printValuesAt(points: [Point]) {
    let gridDescription: String = rows.enumerated().map {
      y, row in
      row.enumerated().reduce("") {
        result, tuple in
        let (x, element) = tuple
        if points.contains(Point(x, y)) {
          return result + "\(element)"
        } else {
          return result + " "
        }
      }
    }.joined()
    print(gridDescription)
  }

  func getRow(row: Int) -> [Element] {
    rows[row]
  }

  func getColumn(column: Int) -> [Element] {
    columns[column]
  }

  func firstWhere(value: Element) -> Point? {
    if let combinedIndex = rows.flatMap({ $0 }).firstIndex(of: value) {
      let y = combinedIndex / width
      let x = combinedIndex % width
      return Point(x, y)
    }
    return nil
  }

  func getValueAt(x: Int, y: Int) -> Element {
    rows[y][x]
  }

  func getValueAtPoint(point: Point) -> Element {
    rows[point.y][point.x]
  }

  func isValidPoint(point: Point) -> Bool {
    let (x, y) = point.tuple
    return x >= 0 && y >= 0 && x < width && y < height
  }

  func forEachPoint(body: (Point) -> Void) {
    allPoints.forEach(body)
  }

  func forEachElement(body: (Element) -> Void) {
    rows.apply {
      row in row.apply(body)
    }
  }

  func adjacentPoints(to point: Point) -> [Point] {
    point.adjacent.filter({ self.isValidPoint(point: $0) })
  }

  func neighborPoints(to point: Point) -> [Point] {
    point.neighbours.filter({ self.isValidPoint(point: $0) })
  }

  func adjacent(to point: Point) -> [Element] {
    self.adjacentPoints(to: point).map {
      self.getValueAtPoint(point: $0)
    }
  }

  func neighbor(to point: Point) -> [Element] {
    self.neighborPoints(to: point).map {
      self.getValueAtPoint(point: $0)
    }
  }
}

typealias CharGrid = Grid2d<Character>

extension CharGrid {

  init(fromString input: String) {
    let rows = input.lines.map {
      Array($0)
    }
    self.init(rows: rows)
  }
}

extension Grid2d<Int> {

  init(fromString input: String) {
    let rows = input.lines.map {
      Array($0).compactMap {
        $0.wholeNumberValue
      }
    }
    self.init(rows: rows)
  }
}
