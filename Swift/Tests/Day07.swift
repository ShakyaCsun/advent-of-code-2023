import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day07Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

  @Test func testPart1() async throws {
    let challenge = Day07(data: testData)
    #expect(challenge.part1() == 6440)
  }

  @Test func testPart2() async throws {
    let challenge = Day07(data: testData)
    #expect(challenge.part2() == 5905)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day07()
    #expect(challenge.part1() == 256_448_566)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day07()
    #expect(challenge.part2() == 254_412_181)
  }
}
