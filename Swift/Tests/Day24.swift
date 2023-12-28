import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day24Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    19, 13, 30 @ -2,  1, -2
    18, 19, 22 @ -1, -1, -2
    20, 25, 34 @ -2, -2, -4
    12, 31, 28 @ -1, -2, -1
    20, 19, 15 @  1, -5, -3
    """

  func testPart1() throws {
    let challenge = Day24(data: testData)
    XCTAssertEqual(challenge.part1(), 2)
  }

  func testPart2() throws {
    let challenge = Day24(data: testData)
    XCTAssertEqual(challenge.part2(), 47)
  }
}
