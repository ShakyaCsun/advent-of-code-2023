extension StringProtocol {
  var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

extension Collection where Element: Equatable {

  func none(_ element: Element) -> Bool {
    !contains(element)
  }

  func countOccurrences(_ element: Element) -> Int {
    reduce(0) {
      $0 + (element == $1 ? 1 : 0)
    }
  }
}
