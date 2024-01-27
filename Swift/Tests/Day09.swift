import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day09Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

  func testPart1() throws {
    let challenge = Day09(data: testData)
    XCTAssertEqual(challenge.part1(), 114)
  }

  func testPart2() throws {
    let challenge = Day09(data: testData)
    XCTAssertEqual(challenge.part2(), 2)
  }

  func testPart1Answer() throws {
    let challenge = Day09()
    XCTAssertEqual(challenge.part1(), 1_974_913_025)
  }

  func testPart2Answer() throws {
    let challenge = Day09()
    XCTAssertEqual(challenge.part2(), 884)
  }
}
