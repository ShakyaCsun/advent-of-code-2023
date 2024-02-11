import Algorithms

typealias ReflectionChecker = (_ grid: Grid2d<Character>, _ index: Int) -> Bool

struct Day13: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let entities: [Grid2d<Character>]

  init(data: String) {
    self.data = data
    self.entities = data.split(separator: "\n\n").map {
      Grid2d(fromString: String($0))
    }
  }

  func part1() -> Int {
    entities.map {
      $0.reflectionAt(checkReflection: verifyReflection)
    }.reduce(0, +)
  }

  func part2() -> Int {
    entities.map {
      $0.reflectionAt(checkReflection: verifyReflectionWithSmudge)
    }.reduce(0, +)
  }
}

private func verifyReflection(grid: Grid2d<Character>, index: Int) -> Bool {
  func reflectionAt(up: Int, down: Int) -> Bool {
    if up < 0 || down >= grid.height {
      return true
    }
    if grid.rows[up] == grid.rows[down] {
      return reflectionAt(up: up - 1, down: down + 1)
    }
    return false
  }
  return reflectionAt(up: index - 1, down: index)
}

private func verifyReflectionWithSmudge(grid: Grid2d<Character>, index: Int) -> Bool {
  func recurse(up: Int, down: Int, smudges: Int) -> Bool {
    if smudges > 1 {
      return false
    }
    if up < 0 || down >= grid.height {
      return true && smudges == 1
    }
    let upRow = grid.rows[up]
    let downRow = grid.rows[down]
    let different = upRow.enumerated().map {
      i, char in
      if char == downRow[i] {
        return 0
      }
      return 1
    }.reduce(0, +)
    if different > 1 {
      return false
    }
    return recurse(up: up - 1, down: down + 1, smudges: smudges + different)
  }
  return recurse(up: index - 1, down: index, smudges: 0)
}

extension Grid2d<Character> {

  func reflectionAt(checkReflection: ReflectionChecker) -> Int {
    let max = max(width, height)
    let transposed = transpose

    func reflectionValue(index: Int) -> Int {
      if index < height {
        if checkReflection(self, index) {
          return index * 100
        }
      }
      if index < width {
        if checkReflection(transposed, index) {
          return index
        }
      }
      if index >= max {
        // Won't happen but just to be safe
        return 0
      }
      return reflectionValue(index: index + 1)
    }
    return reflectionValue(index: 1)
  }
}
