import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day22Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9
    """

  @Test func testPart1() async throws {
    let challenge = Day22(data: testData)
    #expect(challenge.part1() == 5)
  }

  @Test func testPart2() async throws {
    let challenge = Day22(data: testData)
    #expect(challenge.part2() == 7)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day22()
    #expect(challenge.part1() == 485)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day22()
    #expect(challenge.part2() == 74594)
  }
}
