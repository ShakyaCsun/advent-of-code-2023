import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day08Tests {
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

  @Test func testPart1() async throws {
    let challenge = Day08(data: testData)
    #expect(challenge.part1() == 6)
  }

  @Test func testPart2() async throws {
    let challenge = Day08(data: testData)
    #expect(challenge.part2() == 6)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day08()
    #expect(challenge.part1() == 12737)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day08()
    let answer = challenge.part2()
    print(answer)
    #expect(challenge.part2() == 9_064_949_303_801)
  }
}
