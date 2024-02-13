import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  // Splits input data into its component parts and convert from string.
  var entities: Grid2d<Character> {
    Grid2d(fromString: data)
  }

  let grid: Grid2d<Character>

  init(data: String) {
    self.data = data
    self.grid = Grid2d(fromString: data)
  }

  func part1() -> Int {
    func isSymbol(_ element: Character) -> Bool {
      if let _ = element.wholeNumberValue {
        return false
      }
      if element == "." {
        return false
      }
      return true
    }
    var sumOfParts = 0
    // This next line changes execution time from ~8500ms to ~10ms
    let entities = self.entities
    for (y, row) in entities.rows.enumerated() {
      var currentNumber = 0
      var isPartNumber = false
      for (x, element) in row.enumerated() {
        if let number = element.wholeNumberValue {
          currentNumber = currentNumber * 10 + number
          if !isPartNumber {
            isPartNumber = entities.neighbor(to: Point(x, y)).contains(where: { isSymbol($0) })
          }
        } else if currentNumber > 0 {
          if isPartNumber {
            sumOfParts += currentNumber
          }
          currentNumber = 0
          isPartNumber = false
        }
      }
      if isPartNumber {
        sumOfParts += currentNumber
      }
      currentNumber = 0
      isPartNumber = false
    }
    return sumOfParts
  }

  func part2() -> Int {
    func isGear(_ char: Character) -> Bool {
      char == "*"
    }
    var gearNumbers: [Point: [Int]] = [:]
    for (y, row) in grid.rows.enumerated() {
      var adjacentGears: Set<Point> = Set()
      var currentNumber = 0
      for (x, char) in row.enumerated() {
        if let number = char.wholeNumberValue {
          currentNumber = currentNumber * 10 + number
          adjacentGears.formUnion(
            grid.neighborPoints(to: Point(x, y)).filter {
              point in isGear(grid.getValueAtPoint(point: point))
            }
          )
        } else if !adjacentGears.isEmpty || currentNumber > 0 {
          for point in adjacentGears {
            gearNumbers[point, default: []].append(currentNumber)
          }
          adjacentGears = []
          currentNumber = 0
        }
      }
      if !adjacentGears.isEmpty {
        for point in adjacentGears {
          gearNumbers[point, default: []].append(currentNumber)
        }
      }
      adjacentGears = []
      currentNumber = 0
    }
    return gearNumbers.values.filter {
      $0.count == 2
    }.map {
      $0.reduce(1, *)
    }.reduce(0, +)
  }
}
