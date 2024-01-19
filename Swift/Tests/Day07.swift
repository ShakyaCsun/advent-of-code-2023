import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day07Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

  func testPart1() throws {
    let challenge = Day07(data: testData)
    XCTAssertEqual(challenge.part1(), 6440)
  }

  func testPart2() throws {
    let challenge = Day07(data: testData)
    XCTAssertEqual(challenge.part2(), 5905)
  }

  func testPart1Answer() throws {
    let challenge = Day07()
    XCTAssertEqual(challenge.part1(), 256_448_566)
  }

  func testPart2Answer() throws {
    let challenge = Day07()
    XCTAssertEqual(challenge.part2(), 254_412_181)
  }
}
