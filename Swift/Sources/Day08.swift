import Algorithms

private typealias NodeMap = [String: (left: String, right: String)]

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  private let directions: [Character]
  private let initialDirectionsCount: Int
  private let maps: NodeMap

  private init(data: String, directions: [Character], maps: NodeMap) {
    self.data = data
    self.directions = directions
    self.initialDirectionsCount = directions.count
    self.maps = maps
  }

  init(data: String) {
    let lines = data.split(separator: "\n")
    let directions = Array(lines[0])

    // Swift automatically removes empty strings after split, so we can start from 1
    let maps = lines[1...].reduce(NodeMap()) {
      result, value in
      let chars = Array(value)
      let key = String(chars[0...2])
      let left = String(chars[7...9])
      let right = String(chars[12...14])
      return result.merging([key: (left: left, right: right)], uniquingKeysWith: { _, new in new })
    }
    self.init(data: data, directions: directions, maps: maps)
  }

  func move(from start: String, until endCondition: (String) -> Bool, currentStep: Int = 0) -> Int {
    if endCondition(start) {
      return currentStep
    }
    let mapTuple = maps[start]!
    let next =
      if directions[currentStep % initialDirectionsCount] == "L" {
        mapTuple.left
      } else {
        mapTuple.right
      }
    return move(from: next, until: endCondition, currentStep: currentStep + 1)
  }

  func part1() -> Int {
    move(from: "AAA", until: { value in value == "ZZZ" })
  }

  func part2() -> Int {
    let startNodes: [String] = maps.keys.filter {
      $0.hasSuffix("A")
    }
    // Iterative solution runs slower but doesn't cause segmentation fault in debug/tests
    // return iterativePart2(start: startNodes)
    return startNodes.map {
      move(from: $0, until: { $0.hasSuffix("Z") })
    }.reduce(1) {
      lcm($0, $1)
    }
  }

  private func iterativePart2(start: [String]) -> Int {
    var cyclesAt: [Int] = []
    var step = 0
    var current = start
    while cyclesAt.count != start.count {
      let direction = directions[step % initialDirectionsCount]
      current = current.map {
        if $0.hasSuffix("Z") {
          cyclesAt.append(step)
        }
        let node = maps[$0]!
        return direction == "L" ? node.left : node.right
      }
      step += 1
    }
    return cyclesAt.reduce(1) {
      lcm($0, $1)
    }
  }

}
