extension StringProtocol {
  var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

extension Collection where Element: Equatable {

  func none(_ element: Element) -> Bool {
    !contains(element)
  }
}
