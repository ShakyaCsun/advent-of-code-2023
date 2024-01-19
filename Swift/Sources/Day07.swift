import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  private let entities: [(hand: Hand, bid: Int)]

  private init(data: String, entities: [(hand: Hand, bid: Int)]) {
    self.data = data
    self.entities = entities
  }

  init(data: String) {
    self.init(
      data: data,
      entities:
        data.split(separator: "\n").map {
          let handBid = $0.split(separator: " ")
          return (Hand(using: String(handBid[0])), Int(handBid[1])!)
        }
    )
  }

  private func calculateWinnings(usingRule rule: CamelCardRule) -> Int {
    let sorted = entities.sorted(by: {
      lhs, rhs in
      let left = lhs.hand
      let right = rhs.hand
      return left.weakerThan(other: right, usingRule: rule)
    })
    return sorted.map(\.bid).enumerated().reduce(0) {
      value, enumeratedBid in
      let rank = enumeratedBid.offset + 1
      return enumeratedBid.element * rank + value
    }
  }

  func part1() -> Int {
    calculateWinnings(usingRule: .normal)
  }

  func part2() -> Int {
    calculateWinnings(usingRule: .jokers)
  }
}

private enum Card: Character {
  case ace = "A"
  case king = "K"
  case queen = "Q"
  case jack = "J"
  case ten = "T"
  case nine = "9"
  case eight = "8"
  case seven = "7"
  case six = "6"
  case five = "5"
  case four = "4"
  case three = "3"
  case two = "2"

  var points: Int {
    return switch self {
    case .ace:
      14
    case .king:
      13
    case .queen:
      12
    case .jack:
      11
    case .ten:
      10
    case .nine:
      9
    case .eight:
      8
    case .seven:
      7
    case .six:
      6
    case .five:
      5
    case .four:
      4
    case .three:
      3
    case .two:
      2
    }
  }
}

private enum HandType: Int, Comparable {

  case highCard = 1
  case onePair, twoPair, threeOfKind, fullHouse, fourOfKind, fiveOfKind

  static func < (lhs: HandType, rhs: HandType) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

private enum CamelCardRule {
  case normal
  case jokers
}

private struct Hand {
  let cards: [Card]
  let cardCounts: [Card: Int]

  init(using hand: String) {
    self.cards = Array(hand).compactMap { Card(rawValue: $0) }
    self.cardCounts = cards.reduce([Card: Int]()) {
      value, card in
      var newValue = value
      newValue[card, default: 0] += 1
      return newValue
    }
  }

  func weakerThan(other: Hand, usingRule rule: CamelCardRule) -> Bool {
    if handType(usingRule: rule) == other.handType(usingRule: rule) {
      if let (index, card) = cards.enumerated().first(where: { index, card in
        card != other.cards[index]
      }) {
        switch rule {
        case .normal:
          return card.points < other.cards[index].points
        case .jokers:
          let myPoints =
            if card == .jack {
              0
            } else { card.points }
          let otherPoints =
            if other.cards[index] == .jack {
              0
            } else { other.cards[index].points }
          return myPoints < otherPoints
        }
      }
    }
    return handType(usingRule: rule) < other.handType(usingRule: rule)
  }

  func handType(usingRule rule: CamelCardRule = .normal) -> HandType {
    assert(cards.count == 5, "A Hand in Camel Cards has exactly 5 cards")
    if rule == .jokers && !cardCounts.keys.contains(Card.jack) {
      return handType()
    }

    let distinctCards = cardCounts.count
    switch rule {
    case .normal:
      return switch distinctCards {
      case 1:
        .fiveOfKind
      case 2:
        if cardCounts.values.contains(4) {
          .fourOfKind
        } else {
          .fullHouse
        }
      case 3:
        if cardCounts.values.contains(3) {
          .threeOfKind
        } else {
          .twoPair
        }
      case 4:
        .onePair
      default:
        .highCard
      }

    case .jokers:
      // If this case is encountered then we always have at least one Card.jack i.e jockerCount > 0
      let jokerCount = cardCounts[.jack, default: 0]
      switch distinctCards {
      case 1:
        return .fiveOfKind
      case 2:
        return .fiveOfKind
      case 3:
        if jokerCount == 1 {
          if cardCounts.values.contains(2) {
            return .fullHouse
          }
        }
        return .fourOfKind
      case 4:
        return .threeOfKind
      default:
        return .onePair
      }
    }
  }
}
