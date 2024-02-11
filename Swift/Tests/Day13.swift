import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day13Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

  func testPart1() throws {
    let challenge = Day13(data: testData)
    XCTAssertEqual(challenge.part1(), 405)
  }

  func testPart2() throws {
    let challenge = Day13(data: testData)
    XCTAssertEqual(challenge.part2(), 400)
  }

  func testPart1Answer() throws {
    let challenge = Day13()
    XCTAssertEqual(challenge.part1(), 29846)
  }

  func testPart2Answer() throws {
    let challenge = Day13()
    XCTAssertEqual(challenge.part2(), 25401)
  }
}
