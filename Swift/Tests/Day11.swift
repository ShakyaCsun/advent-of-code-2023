import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day11Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

  func testPart1() throws {
    let challenge = Day11(data: testData)
    XCTAssertEqual(challenge.part1(), 374)
  }

  func testExpansion() throws {
    let challenge = Day11(data: testData)
    XCTAssertEqual(challenge.solve(expandBy: 100), 8410)
  }

  func testPart1Answer() throws {
    let challenge = Day11()
    XCTAssertEqual(challenge.part1(), 9_233_514)
  }

  func testPart2Answer() throws {
    let challenge = Day11()
    XCTAssertEqual(challenge.part2(), 363_293_506_944)
  }
}
