import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day10Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """
  let testData2 = """
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """

  func testPart1() throws {
    let challenge = Day10(data: testData)
    XCTAssertEqual(challenge.part1(), 8)
  }

  func testPart2() throws {
    let challenge = Day10(data: testData2)
    XCTAssertEqual(challenge.part2(), 10)
  }

  func testPart1Answer() throws {
    let challenge = Day10()
    XCTAssertEqual(challenge.part1(), 6823)
  }

  func testPart2Answer() throws {
    let challenge = Day10()
    XCTAssertEqual(challenge.part2(), 415)
  }
}
