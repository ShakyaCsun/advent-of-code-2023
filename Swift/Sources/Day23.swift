import Algorithms

struct Day23: AdventDay {
  init(data: String) {
    self.data = data
    self.grid = CharGrid.init(fromString: data)
  }

  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let grid: CharGrid

  func part1() -> Int {
    0
  }

  func part2() -> Int {
    0
  }
}
