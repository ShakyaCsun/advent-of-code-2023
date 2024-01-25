import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day08Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

  let testData1 = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

  func testPart1() throws {
    let challenge = Day08(data: testData)
    XCTAssertEqual(challenge.part1(), 6)
  }

  func testPart2() throws {
    let challenge = Day08(data: testData)
    XCTAssertEqual(challenge.part2(), 6)
  }

  func testPart1Answer() throws {
    let challenge = Day08()
    XCTAssertEqual(challenge.part1(), 12737)
  }

  func testPart2Answer() throws {
    let challenge = Day08()
    let answer = challenge.part2()
    print(answer)
    XCTAssertEqual(challenge.part2(), 9_064_949_303_801)
  }
}
