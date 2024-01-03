import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day03Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

  func testPart1() throws {
    let challenge = Day03(data: testData)
    XCTAssertEqual(challenge.part1(), 4361)
  }

  func testPart2() throws {
    let challenge = Day03(data: testData)
    XCTAssertEqual(challenge.part2(), 467835)
  }

  func testPart1Answer() throws {
    let challenge = Day03()
    XCTAssertEqual(challenge.part1(), 556367)
  }

  func testPart2Answer() {
    let challenge = Day03()
    XCTAssertEqual(challenge.part2(), 89_471_771)
  }
}
