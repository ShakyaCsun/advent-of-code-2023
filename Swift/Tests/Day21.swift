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
    XCTAssertEqual(challenge.moveFinite(startPoint: challenge.start, steps: 6), 16)
  }

  func testPart2() throws {
    // No test for part2 sample, because the solution is based on assumptions that
    // puzzle gardens have no rocks around the edges and in the row & column with the center start point.
    XCTAssertEqual(1 + 1, 2)
  }

  func testPart1Answer() throws {
    let challenge = Day21()
    XCTAssertEqual(challenge.part1(), 3598)
  }

  func testPart2Answer() throws {
    let challenge = Day21()
    XCTAssertEqual(challenge.part2(), 601_441_063_166_538)
  }
}
