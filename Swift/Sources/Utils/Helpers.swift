extension StringProtocol {
  var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

extension Collection where Element: Equatable {

  func none(_ element: Element) -> Bool {
    !contains(element)
  }

  func containsAll(_ other: [Element]) -> Bool {
    other.allSatisfy(contains)
  }

  func countOccurrences(_ element: Element) -> Int {
    reduce(0) {
      $0 + (element == $1 ? 1 : 0)
    }
  }

  /// forEach but not forEach.
  /// to make ReplaceForEachWithForLoop lint rule happy
  func apply(_ applyFunc: (Element) -> Void) {
    if isEmpty {
      return
    }
    func iterate(index: Int) {
      let currentIndex = self.index(startIndex, offsetBy: index)
      if currentIndex == endIndex {
        return
      }
      let element = self[currentIndex]
      applyFunc(element)
      return iterate(index: index + 1)
    }
    iterate(index: 0)
  }
}
