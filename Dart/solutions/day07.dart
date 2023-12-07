import '../utils/index.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<CamelCard> parseInput() {
    return input.getPerLine().map((e) {
      final [hand, bid, ...] = e.split(' ');
      return CamelCard(hand: hand, bid: int.parse(bid));
    }).toList();
  }

  @override
  int solvePart1() {
    final sortedCards = parseInput()..sort();
    return sortedCards.foldIndexed<int>(
      0,
      (index, previous, element) => previous += (index + 1) * element.bid,
    );
  }

  @override
  int solvePart2() {
    final sortedCards = parseInput()..sort(CamelCard.compareToWithJoker);
    return sortedCards.foldIndexed<int>(
      0,
      (index, previous, element) => previous += (index + 1) * element.bid,
    );
  }
}

class CamelCard implements Comparable<CamelCard> {
  const CamelCard({
    required this.hand,
    required this.bid,
  }) : assert(
          hand.length == 5,
          'A hand in Camel Card game always has 5 cards',
        );

  final String hand;
  final int bid;

  @override
  String toString() {
    return 'CamelCard(hand: $hand, bid: $bid)';
  }

  HandOfCards get handOfCards {
    final [first, second, third, fourth, fifth, ...] = hand.split('');
    return (
      first: CardLabel.fromString(first),
      second: CardLabel.fromString(second),
      third: CardLabel.fromString(third),
      fourth: CardLabel.fromString(fourth),
      fifth: CardLabel.fromString(fifth),
    );
  }

  HandOfCards get handOfJokerCards => handOfCards.withJoker;

  List<CardLabel> get cardsList => handOfCards.toList();

  HandType get handType {
    switch (handOfCards.toSet().length) {
      case 1:
        return HandType.fiveOfKind;
      case 4:
        return HandType.onePair;
      case 5:
        return HandType.highCard;
      case 2:
        final newCards = [...cardsList]
          ..removeWhere((element) => element == handOfCards.first);
        if (newCards.length == 2 || newCards.length == 3) {
          return HandType.fullHouse;
        }
        return HandType.fourOfKind;
      case 3:
        for (var i = 0; i < 5; i++) {
          final newCards = [...cardsList]
            ..retainWhere((element) => element == cardsList[i]);
          if (newCards.length > 1) {
            if (newCards.length == 2) {
              return HandType.twoPair;
            }
            return HandType.threeOfKind;
          }
        }
        throw StateError('Impossible State');

      default:
        throw StateError('Invalid Hand');
    }
  }

  HandType get handTypeWithJoker {
    if (handOfCards == handOfJokerCards) {
      return handType;
    }
    final cardsWithoutJoker = [...handOfJokerCards.toList()]
      ..removeWhere((element) => element == CardLabel.joker);
    switch (handOfJokerCards.toSet().length) {
      case 1:
        return HandType.fiveOfKind;
      case 4:
        return HandType.threeOfKind;
      case 5:
        return HandType.onePair;
      case 2:
        return HandType.fiveOfKind;
      case 3:
        if (cardsWithoutJoker.length == 2 || cardsWithoutJoker.length == 3) {
          return HandType.fourOfKind;
        }
        final cardsWithoutI = [...cardsWithoutJoker]
          ..removeWhere((element) => element == cardsWithoutJoker[0]);
        if (cardsWithoutI.length == 2) {
          return HandType.fullHouse;
        }
        return HandType.fourOfKind;

      default:
        throw StateError('Invalid Hand');
    }
  }

  @override
  int compareTo(CamelCard other) {
    final handTypeComparison = handType.compareTo(other.handType);
    if (handTypeComparison == 0) {
      final otherCards = other.cardsList;
      for (final (index, card) in cardsList.indexed) {
        if (card.compareTo(otherCards[index]) != 0) {
          return card.compareTo(otherCards[index]);
        }
      }
    }
    return handTypeComparison;
  }

  static int compareToWithJoker(CamelCard self, CamelCard other) {
    final handTypeComparison = self.handTypeWithJoker.compareTo(
      other.handTypeWithJoker,
    );
    if (handTypeComparison == 0) {
      final otherCards = other.handOfJokerCards.toList();
      for (final (index, card) in self.handOfJokerCards.toList().indexed) {
        if (card.compareTo(otherCards[index]) != 0) {
          return card.compareTo(otherCards[index]);
        }
      }
    }
    return handTypeComparison;
  }
}

enum HandType implements Comparable<HandType> {
  fiveOfKind(6),
  fourOfKind(5),
  fullHouse(4),
  threeOfKind(3),
  twoPair(2),
  onePair(1),
  highCard(0);

  const HandType(this.value);
  final int value;

  @override
  int compareTo(HandType other) {
    return value.compareTo(other.value);
  }
}

typedef HandOfCards = ({
  CardLabel first,
  CardLabel second,
  CardLabel third,
  CardLabel fourth,
  CardLabel fifth
});

extension on HandOfCards {
  Set<CardLabel> toSet() {
    return <CardLabel>{first, second, third, fourth, fifth};
  }

  List<CardLabel> toList() {
    return <CardLabel>[first, second, third, fourth, fifth];
  }

  HandOfCards get withJoker {
    return (
      first: first == CardLabel.jack ? CardLabel.joker : first,
      second: second == CardLabel.jack ? CardLabel.joker : second,
      third: third == CardLabel.jack ? CardLabel.joker : third,
      fourth: fourth == CardLabel.jack ? CardLabel.joker : fourth,
      fifth: fifth == CardLabel.jack ? CardLabel.joker : fifth,
    );
  }
}

enum CardLabel implements Comparable<CardLabel> {
  ace(13),
  king(12),
  queen(11),
  jack(10),
  ten(9),
  nine(8),
  eight(7),
  seven(6),
  six(5),
  five(4),
  four(3),
  three(2),
  two(1),
  joker(0);

  const CardLabel(this.value);
  final int value;

  @override
  int compareTo(CardLabel other) {
    return value.compareTo(other.value);
  }

  static CardLabel fromString(String label, {bool useJoker = false}) {
    return switch (label) {
      'A' => CardLabel.ace,
      'K' => CardLabel.king,
      'Q' => CardLabel.queen,
      'J' => useJoker ? CardLabel.joker : CardLabel.jack,
      'T' => CardLabel.ten,
      '9' => CardLabel.nine,
      '8' => CardLabel.eight,
      '7' => CardLabel.seven,
      '6' => CardLabel.six,
      '5' => CardLabel.five,
      '4' => CardLabel.four,
      '3' => CardLabel.three,
      '2' => CardLabel.two,
      _ => throw StateError('Invalid Label'),
    };
  }
}
