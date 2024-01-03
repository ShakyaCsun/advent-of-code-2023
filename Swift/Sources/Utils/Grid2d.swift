struct Grid2d<Element>: CustomStringConvertible {
  let rows: [[Element]]
  let width: Int
  let height: Int
  init(rows: [[Element]]) {
    assert(!rows.isEmpty)
    assert(!rows.first!.isEmpty)
    let width = rows.first!.count
    assert(rows.allSatisfy({ $0.count == width }))
    self.height = rows.count
    self.width = width
    self.rows = rows.map { $0.map { $0 } }
  }

  var description: String {
    var string = ""
    for row in rows {
      for element in row {
        string += "\(element)"
      }
      string += "\n"
    }
    return string.trimmingCharacters(in: .newlines)
  }

  var columns: [[Element]] {
    (0..<width).map({ getColumn(column: $0) })
  }

  func getRow(row: Int) -> [Element] {
    rows[row]
  }

  func getColumn(column: Int) -> [Element] {
    rows.map {
      $0[column]
    }
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
    for y in 0..<height {
      for x in 0..<width {
        body(Point(x, y))
      }
    }
  }

  func forEachElement(body: (Element) -> Void) {
    for row in rows {
      for element in row {
        body(element)
      }
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

extension Grid2d<Character> {

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
