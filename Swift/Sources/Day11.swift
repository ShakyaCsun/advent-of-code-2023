import Algorithms

struct Day11: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let image: Grid2d<Character>
  private let galaxyPositions: [Point]

  init(data: String) {
    self.data = data
    let image = Grid2d<Character>(fromString: data)
    self.image = image
    self.galaxyPositions = image.allPoints.filter {
      point in image.getValueAtPoint(point: point) == "#"
    }
  }

  func solve(expandBy: Int = 2) -> Int {
    let emptyRows: [Int] = image.rows.enumerated().filter {
      index, row in row.allSatisfy({ $0 == "." })
    }.map { $0.offset }
    let emptyColumns: [Int] = image.columns.enumerated().filter {
      index, column in !column.contains("#")
    }.map(\.offset)

    func calculateDistance(_ a: Point, _ b: Point) -> Int {
      let distance = a.distance(other: b)
      let (rowRange, colRange) = a.rangeTo(other: b)
      let expandedRows = emptyRows.filter { rowRange.contains($0) }.count
      let expandedCols = emptyColumns.filter { colRange.contains($0) }.count
      return distance + (expandedRows + expandedCols) * (expandBy - 1)
    }

    return galaxyPositions.enumerated().flatMap {
      i, pointA in
      // This does not cause index out of bounds error. Interesting
      galaxyPositions[(i + 1)...].map {
        pointB in calculateDistance(pointA, pointB)
      }
    }.reduce(0, +)
  }

  func part1() -> Int {
    solve()
  }

  func part2() -> Int {
    solve(expandBy: 1_000_000)
  }
}
