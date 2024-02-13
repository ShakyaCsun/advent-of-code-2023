import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let entities: [String]

  init(data: String) {
    self.data = data
    self.entities = data.split(separator: "\n").map {
      String($0)
    }
  }

  func part1() -> Int {
    // Fancy Swift
    return entities.map {
      let digits = $0.compactMap { $0.wholeNumberValue }
      return digits.first! * 10 + digits.last!
    }.reduce(0, +)
    // var sumCalibration = 0
    // for word in entities {
    //   var digits: [Int] = []
    //   for char in word {
    //     if let number = char.wholeNumberValue {
    //       digits.append(number)
    //     }
    //   }
    //   sumCalibration += digits.first! * 10 + digits.last!
    // }
    // return sumCalibration
  }

  func part2() -> Int {
    let replacements = [
      "one": "o1e",
      "two": "t2o",
      "three": "t3e",
      "four": "f4r",
      "five": "f5e",
      "six": "s6x",
      "seven": "s7n",
      "eight": "e8t",
      "nine": "n9e",
    ]

    // Fancy Swift
    return entities.map {
      let digits = replacements.reduce(
        $0,
        {
          result, element in result.replacingOccurrences(of: element.key, with: element.value)
        }
      ).compactMap { $0.wholeNumberValue }
      return digits.first! * 10 + digits.last!
    }.reduce(0, +)
    // var sumCalibration = 0
    // for word in entities {
    //   var correctedWord = String(word)
    //   for (real, corrected) in replacements {
    //     correctedWord = correctedWord.replacingOccurrences(of: real, with: corrected)
    //   }
    //   var digits: [Int] = []
    //   for char in correctedWord {
    //     if let number = char.wholeNumberValue {
    //       digits.append(number)
    //     }
    //   }
    //   sumCalibration += digits.first! * 10 + digits.last!
    // }
    // return sumCalibration
  }
}
