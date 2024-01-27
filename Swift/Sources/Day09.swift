import Algorithms

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let entities: [[Int]]

  init(data: String) {
    self.data = data
    self.entities = data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func differences(of numbers: [Int]) -> [Int] {
    numbers.adjacentPairs().map {
      (a, b) in b - a
    }
  }

  func getNextNumber(_ numbers: [Int]) -> Int {
    if numbers.allSatisfy({ $0 == 0 }) {
      return 0
    }
    return (numbers.last ?? 0) + getNextNumber(differences(of: numbers))
  }

  func getPreviousNumber(_ numbers: [Int]) -> Int {
    if numbers.allSatisfy({ $0 == 0 }) {
      return 0
    }
    return (numbers.first ?? 0) - getPreviousNumber(differences(of: numbers))
  }

  func part1() -> Int {
    entities.map {
      getNextNumber($0)
    }.reduce(0, +)
  }

  func part2() -> Int {
    entities.map(getPreviousNumber).reduce(0, +)
  }
}
