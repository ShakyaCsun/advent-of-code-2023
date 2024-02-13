import Algorithms

struct Day14: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let grid: CharGrid

  init(data: String) {
    self.data = data
    self.grid = CharGrid(fromString: data)
  }

  func part1() -> Int {
    grid.tiltNorth().loadOnNorthSide
  }

  func part2() -> Int {
    cycle(times: 1_000_000_000).loadOnNorthSide
  }

  func cycle(times: Int) -> CharGrid {
    var seen: OrderedSet<CharGrid> = []
    func cycleNext(_ currentCycle: Int, current: CharGrid) -> CharGrid {
      if currentCycle == times {
        return current
      }
      if let seenAt = seen.firstIndex(of: current) {
        let remainingCycles = times - currentCycle
        let cycleRepeats = currentCycle - seenAt
        let index = remainingCycles % cycleRepeats + seenAt
        return seen[index]
      }
      seen.append(current)
      return cycleNext(currentCycle + 1, current: current.cycle())
    }

    return cycleNext(0, current: grid)
  }

  static func roll(stones: [Character], to direction: RollDirection) -> [Character] {
    switch direction {
    case .left:
      return Array(
        stones.split(separator: "#", omittingEmptySubsequences: false).map {
          $0.sorted(by: >)
        }.joined(separator: "#"))
    case .right:
      return stones.split(separator: "#", omittingEmptySubsequences: false).map {
        $0.sorted()
      }.joined(separator: "#").map { $0 }
    }
  }
}

enum RollDirection {
  case left
  case right
}

extension CharGrid {

  fileprivate var loadOnNorthSide: Int {
    rows.enumerated().map {
      (index, row) in row.countOccurrences("O") * (height - index)
    }.reduce(0, +)
  }

  fileprivate func tiltNorth() -> CharGrid {
    return CharGrid(
      columns: columns.map {
        col in
        Day14.roll(stones: col, to: .left)
      }
    )
  }

  fileprivate func cycle() -> CharGrid {
    let north = tiltNorth()
    let west = CharGrid(rows: north.rows.map { Day14.roll(stones: $0, to: .left) })
    let south = CharGrid(columns: west.columns.map { Day14.roll(stones: $0, to: .right) })
    let east = CharGrid(rows: south.rows.map { Day14.roll(stones: $0, to: .right) })
    return east
    /// Roll the round stones up then rotate the grid clockwise 4 times to complete the cycle
    // return (1...4).reduce(self) {
    //   grid, _ in
    //   CharGrid(
    //     rows: grid.columns.map {
    //       Day14.roll(stones: $0, to: .left).reversed()
    //     }
    //   )
    // }
  }
}
