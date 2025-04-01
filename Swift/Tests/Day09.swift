import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day09Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

  @Test func testPart1() async throws {
    let challenge = Day09(data: testData)
    #expect(challenge.part1() == 114)
  }

  @Test func testPart2() async throws {
    let challenge = Day09(data: testData)
    #expect(challenge.part2() == 2)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day09()
    #expect(challenge.part1() == 1_974_913_025)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day09()
    #expect(challenge.part2() == 884)
  }
}
