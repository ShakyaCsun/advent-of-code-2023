import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day22Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9
    """

  func testPart1() throws {
    let challenge = Day22(data: testData)
    XCTAssertEqual(challenge.part1(), 5)
  }

  func testPart2() throws {
    let challenge = Day22(data: testData)
    XCTAssertEqual(challenge.part2(), 7)
  }
}
