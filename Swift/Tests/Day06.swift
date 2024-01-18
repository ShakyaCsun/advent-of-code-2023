import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day06Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """

  func testPart1() throws {
    let challenge = Day06(data: testData)
    XCTAssertEqual(challenge.part1(), 288)
  }

  func testPart2() throws {
    let challenge = Day06(data: testData)
    XCTAssertEqual(challenge.part2(), 71503)
  }

  func testPart1Answer() throws {
    let challenge = Day06()
    XCTAssertEqual(challenge.part1(), 781200)
  }

  func testPart2Answer() throws {
    let challenge = Day06()
    XCTAssertEqual(challenge.part2(), 49_240_091)
  }
}
