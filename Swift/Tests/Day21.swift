import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day21Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
    """

  func testPart1() throws {
    let challenge = Day21(data: testData)
    XCTAssertEqual(challenge.part1(), 16)
  }

  func testPart2() throws {
    let challenge = Day21(data: testData)
    XCTAssertEqual(challenge.part2(), 3598)
  }
}
