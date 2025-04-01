import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day04Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

  @Test func testPart1() async throws {
    let challenge = Day04(data: testData)
    #expect(challenge.part1() == 13)
  }

  @Test func testPart2() async throws {
    let challenge = Day04(data: testData)
    #expect(challenge.part2() == 30)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day04()
    #expect(challenge.part1() == 19855)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day04()
    #expect(challenge.part2() == 10_378_710)
  }
}
