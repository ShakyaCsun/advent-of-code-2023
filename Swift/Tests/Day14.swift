import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day14Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

  func testPart1() throws {
    let challenge = Day14(data: testData)
    XCTAssertEqual(challenge.part1(), 136)
  }

  func testPart2() throws {
    let challenge = Day14(data: testData)
    XCTAssertEqual(challenge.part2(), 64)
  }

  func testPart1Answer() throws {
    let challenge = Day14()
    XCTAssertEqual(challenge.part1(), 105784)
  }

  func testPart2Answer() throws {
    let challenge = Day14()
    XCTAssertEqual(challenge.part2(), 91286)
  }
}
