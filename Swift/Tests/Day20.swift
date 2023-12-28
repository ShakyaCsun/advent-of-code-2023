import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day20Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
    """

  let testData2 = """
    broadcaster -> a
    %a -> inv, con
    &inv -> b
    %b -> con
    &con -> output
    """

  func testPart1Sample1() throws {
    let challenge = Day20(data: testData)
    XCTAssertEqual(challenge.part1(), 32_000_000)
  }

  func testPart1Sample2() throws {
    let challenge = Day20(data: testData2)
    XCTAssertEqual(challenge.part1(), 11_687_500)
  }
}
