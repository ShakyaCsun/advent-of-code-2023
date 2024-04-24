import Algorithms
import Foundation

struct Day19: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let workflowMap: [String: Workflow]
  let parts: [Part]

  init(data: String) {
    self.data = data
    let split = data.split(separator: "\n\n")
    self.workflowMap = split[0].split(separator: "\n").reduce(
      into: [String: Workflow](),
      {
        dict, line in
        let name = String(line.split(separator: "{")[0])
        let workflow = Workflow(from: String(line))
        dict[name] = workflow
      })
    self.parts = split[1].split(separator: "\n").map {
      Part(from: String($0))
    }
  }

  func part1() -> Int {
    parts.filter { part in part.check(workflows: workflowMap) }.reduce(0) {
      result, part in result + part.sum
    }
  }

  func part2() -> Int {
    func countAcceptableParts(
      workflowName: String = "in",
      partRange: PartRange = PartRange.initial
    ) -> Int {
      if workflowName == "R" {
        return 0
      }
      if workflowName == "A" {
        return partRange.combinations
      }
      let workflow = workflowMap[workflowName]!
      let (nextRange, count) = workflow.rules.reduce(
        (partRange as PartRange?, 0)
      ) {
        tuple, rule in
        let (range, count) = tuple
        if range == nil {
          return tuple
        }
        let rangeSplit = rule.check(range: range!)
        if let accepted = rangeSplit.accept {
          return (
            rangeSplit.next,
            count + countAcceptableParts(workflowName: rule.onTrue, partRange: accepted)
          )
        }
        return tuple
      }
      if let range = nextRange {
        return count + countAcceptableParts(workflowName: workflow.fallback, partRange: range)
      }
      return count
    }
    return countAcceptableParts()
  }
}

struct Workflow {
  let rules: [Rule]
  let fallback: String

  func checkPart(_ part: Part) -> String {
    if let rule = rules.first(where: { $0.apply(to: part) }) {
      return rule.onTrue
    }
    return fallback
  }
}

extension Workflow {

  init(from line: String) {
    let workflow = line[..<line.index(before: line.endIndex)].split(separator: "{")[1]
    let rules = workflow.split(separator: ",")
    self.rules = rules[..<(rules.endIndex - 1)].map { Rule(from: String($0)) }
    self.fallback = String(rules.last!)
  }
}

struct Rule {
  let category: String
  let comparator: Comparision
  let target: Int
  let onTrue: String

  func apply(to part: Part) -> Bool {
    let rating = part.rating(of: category)
    return switch comparator {
    case .lessThan:
      rating < target
    case .greaterThan:
      rating > target
    }
  }

  func check(range: PartRange) -> (accept: PartRange?, next: PartRange?) {
    let ratings = range.ratingRange(of: category)
    let tuple: (first: Int, last: Int) = (first: ratings.first!, last: ratings.last!)
    switch comparator {
    case .lessThan:
      if ratings.contains(target) {
        return (
          accept: range.copy(range: tuple.first...(target - 1), category: category),
          next: range.copy(range: target...tuple.last, category: category)
        )
      }
      if tuple.last < target {
        return (accept: range, next: nil)
      }
      return (accept: nil, next: range)

    case .greaterThan:

      if ratings.contains(target) {
        return (
          accept: range.copy(range: (target + 1)...tuple.last, category: category),
          next: range.copy(range: tuple.first...target, category: category)
        )
      }
      if tuple.first > target {
        return (accept: range, next: nil)
      }
      return (accept: nil, next: range)
    }
  }
}

extension Rule {

  init(from data: String) {
    let category = String(Array(data)[0])
    let comparator: Comparision =
      if Array(data)[1] == "<" {
        .lessThan
      } else {
        .greaterThan
      }
    let onTrue = String(data.split(separator: ":")[1])
    let target = Int(String(data.filter({ $0.wholeNumberValue != nil })))!
    self.init(category: category, comparator: comparator, target: target, onTrue: onTrue)
  }
}

enum Comparision {

  case lessThan, greaterThan
}

struct Part {

  let x: Int
  let m: Int
  let a: Int
  let s: Int

  var sum: Int {
    x + m + a + s
  }

  func rating(of category: String) -> Int {
    switch category {
    case "x":
      return x
    case "m":
      return m
    case "a":
      return a
    case "s":
      return s
    default:
      fatalError("Can only access ratings of x, m, a, or s. Got \(category) instead.")
    }
  }

  func check(workflows: [String: Workflow]) -> Bool {
    func workflowTest(name: String) -> Bool {
      if name == "R" {
        return false
      }
      if name == "A" {
        return true
      }
      return workflowTest(name: workflows[name]!.checkPart(self))
    }
    return workflowTest(name: "in")
  }
}

extension Part {

  init(from line: String) {
    let numbers = String(
      line.unicodeScalars.filter(
        CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ",")).contains)
    ).split(separator: ",").compactMap { Int($0) }

    if numbers.count < 4 {
      fatalError("Need 4 parts in order")
    }

    self.init(x: numbers[0], m: numbers[1], a: numbers[2], s: numbers[3])
  }
}

typealias IntRange = ClosedRange<Int>

struct PartRange {

  let x: IntRange
  let m: IntRange
  let a: IntRange
  let s: IntRange

  static let initial: PartRange = PartRange(x: 1...4000, m: 1...4000, a: 1...4000, s: 1...4000)

  var combinations: Int {
    x.count * m.count * a.count * s.count
  }

  func copy(x: IntRange? = nil, m: IntRange? = nil, a: IntRange? = nil, s: IntRange? = nil)
    -> PartRange
  {
    PartRange(x: x ?? self.x, m: m ?? self.m, a: a ?? self.a, s: s ?? self.s)
  }

  func copy(range: IntRange, category: String) -> PartRange {
    switch category {
    case "x":
      return copy(x: range)
    case "m":
      return copy(m: range)
    case "a":
      return copy(a: range)
    case "s":
      return copy(s: range)
    default:
      fatalError("Can only access ratings of x, m, a, or s. Got \(category) instead.")
    }
  }

  func ratingRange(of category: String) -> IntRange {
    switch category {
    case "x":
      return x
    case "m":
      return m
    case "a":
      return a
    case "s":
      return s
    default:
      fatalError("Can only access ratings of x, m, a, or s. Got \(category) instead.")
    }
  }
}
