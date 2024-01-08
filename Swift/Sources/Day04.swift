import Algorithms

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.lines.map {
      line in
      let numbers = line.split(separator: ":").last!.split(
        separator: "|"
      ).map {
        $0.split(separator: " ").compactMap {
          Int($0)
        }
      }
      assert(
        numbers.count == 2,
        "Lines should be able to be split into winning numbers and numbers we have"
      )
      let winningNumbers = numbers[0]
      let numbersWeHave = numbers[1]
      return numbersWeHave.filter { winningNumbers.contains($0) }
    }
  }

  func part1() -> Int {
    let calculatePoints = {
      (numbers: [Int]) -> Int in
      numbers.reduce(
        0,
        { (result, element) in
          if result == 0 {
            return 1
          }
          return result + result
        })
    }
    return entities.reduce(0, { $0 + calculatePoints($1) })
  }

  func part2() -> Int {
    let entities = self.entities
    let totalCards = entities.count
    let pointsWon = entities.map(\.count)
    var cardsAmount = entities.map { _ in 1 }
    for (card, points) in pointsWon.enumerated() {
      if points == 0 {
        continue
      }
      for i in 1...points {
        let wonCard = card + i
        assert(wonCard < totalCards)
        cardsAmount[wonCard] += cardsAmount[card]
      }
    }
    return cardsAmount.reduce(0, +)
  }
}
