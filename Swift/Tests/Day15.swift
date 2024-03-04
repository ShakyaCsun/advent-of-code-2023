import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day15Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """

  func testPart1() throws {
    let challenge = Day15(data: testData)
    XCTAssertEqual(challenge.part1(), 1320)
  }

  func testPart2() throws {
    let challenge = Day15(data: testData)
    XCTAssertEqual(challenge.part2(), 145)
  }

  func testPart1Answer() throws {
    let challenge = Day15()
    XCTAssertEqual(challenge.part1(), 507769)
  }

  func testPart2Answer() throws {
    let challenge = Day15()
    XCTAssertEqual(challenge.part2(), 269747)
  }

}
