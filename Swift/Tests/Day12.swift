import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day12Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

  func testPart1() throws {
    let challenge = Day12(data: testData)
    XCTAssertEqual(challenge.part1(), 21)
  }

  func testPart2() throws {
    let challenge = Day12(data: testData)
    XCTAssertEqual(challenge.part2(), 525152)
  }

  func testPart1Answer() throws {
    let challenge = Day12()
    XCTAssertEqual(challenge.part1(), 6871)
  }

  func testPart2Answer() throws {
    let challenge = Day12()
    XCTAssertEqual(challenge.part2(), 2_043_098_029_844)
  }
}
