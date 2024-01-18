import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  // Splits input data into its component parts and convert from string.
  var entities: ([Int], [Int]) {
    let list = data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
    return (list[0], list[1])
  }

  func part1() -> Int {
    let (times, distances) = entities
    return times.enumerated().map {
      index, time in numberOfWaysToWin(time: time, recordDistance: distances[index])
    }.reduce(1, *)
  }

  func part2() -> Int {
    let (times, distances) = entities
    let time = times.combinedValue
    let distance = distances.combinedValue
    return numberOfWaysToWin(time: time, recordDistance: distance)
  }

  func numberOfWaysToWin(time: Int, recordDistance: Int) -> Int {
    // let minHoldTime = (1...time).first(where: { holdTime in
    //   holdTime * (time - holdTime) > recordDistance
    // })!
    // return time - minHoldTime * 2 + 1

    // Minimum hold time to match the `recordDistance` using the Quadratic formula
    // (-b - sqrt(b^2 - 4ac)) / 2a
    let minHoldTimeQuad = (Double(time) - Double(time * time - 4 * recordDistance).squareRoot()) / 2
    let minHoldTime = Int(minHoldTimeQuad) + 1
    return time - minHoldTime * 2 + 1
  }
}

extension [Int] {
  /// Combines the [Int]s of the Array into a single Int value
  ///
  /// Example: [1, 4, 10, 100, 5].combinedValue = 14101005
  var combinedValue: Int {
    Int(reduce("") { $0 + "\($1)" })!
  }
}
