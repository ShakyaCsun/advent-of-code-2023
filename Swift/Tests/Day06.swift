import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day06Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """

  @Test func testPart1() async throws {
    let challenge = Day06(data: testData)
    #expect(challenge.part1() == 288)
  }

  @Test func testPart2() async throws {
    let challenge = Day06(data: testData)
    #expect(challenge.part2() == 71503)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day06()
    #expect(challenge.part1() == 781200)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day06()
    #expect(challenge.part2() == 49_240_091)
  }
}
