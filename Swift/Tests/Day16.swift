import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day16Tests {
  // Smoke test data provided in the challenge question
  let testData = #"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """#

  @Test func testPart1() async throws {
    let challenge = Day16(data: testData)
    #expect(challenge.part1() == 46)
  }

  @Test func testPart2() async throws {
    let challenge = Day16(data: testData)
    #expect(challenge.part2() == 51)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day16()
    #expect(challenge.part1() == 8021)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day16()
    #expect(challenge.part2() == 8216)
  }
}
