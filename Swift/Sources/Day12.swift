import Algorithms

struct Day12: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String
  let entities: [(String, [Int])]

  init(data: String) {
    self.data = data
    self.entities = data.split(separator: "\n").map {
      line in
      let readings = line.split(separator: " ")
      let brokenReading = String(readings[0])
      let numbers = readings[1].split(separator: ",").compactMap { Int($0) }
      return (brokenReading, numbers)
    }
  }

  func possibleArrangements(reading: String, damagedSprings: [Int]) -> Int {
    let springs = Array(
      reading.trimming(while: { $0 == "." })
    )
    let springLength = springs.count
    let damagedSpringsLength = damagedSprings.count
    var memo = [String: Int]()

    func solve(springIndex: Int, damagedSpringIndex: Int) -> Int {
      let key = "\(springIndex),\(damagedSpringIndex)"
      if let result = memo[key] {
        return result
      }
      if springIndex >= springLength {
        if damagedSpringIndex == damagedSpringsLength {
          return 1
        }
        return 0
      }
      if damagedSpringIndex == damagedSpringsLength {
        if springs[springIndex...].contains("#") {
          return 0
        }
        return 1
      }
      if springLength - springIndex < damagedSprings[damagedSpringIndex...].minimumValidReading {
        return 0
      }
      let currentChar = springs[springIndex]
      let requiredDamagedSpringsUntil = springIndex + damagedSprings[damagedSpringIndex]
      let firstIsDamaged =
        if currentChar != "." && requiredDamagedSpringsUntil <= springLength
          && springs[springIndex..<requiredDamagedSpringsUntil].none(".")
          && (requiredDamagedSpringsUntil == springLength
            || springs[requiredDamagedSpringsUntil] != "#")
        {
          solve(
            springIndex: requiredDamagedSpringsUntil + 1,
            damagedSpringIndex: damagedSpringIndex + 1
          )
        } else {
          0
        }

      let firstIsOperational =
        if currentChar != "#" {
          solve(springIndex: springIndex + 1, damagedSpringIndex: damagedSpringIndex)
        } else { 0 }
      let result = firstIsDamaged + firstIsOperational
      memo[key] = result

      return result
    }

    return solve(springIndex: 0, damagedSpringIndex: 0)
  }

  func part1() -> Int {
    entities.map {
      (reading, springs) in
      possibleArrangements(reading: reading, damagedSprings: springs)
    }.reduce(0, +)
  }

  func part2() -> Int {
    let newEntities: [(String, [Int])] = entities.map {
      tuple in
      (1...4).reduce(tuple) {
        result, _ in
        (result.0 + "?" + tuple.0, result.1 + tuple.1)
      }
    }
    return newEntities.map {
      (reading, springs) in possibleArrangements(reading: reading, damagedSprings: springs)
    }.reduce(0, +)
  }
}

extension Collection<Int> {
  fileprivate var minimumValidReading: Int {
    reduce(0, +) + count - 1
  }
}
