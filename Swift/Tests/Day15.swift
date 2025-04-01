import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day15Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """

  @Test func testPart1() async throws {
    let challenge = Day15(data: testData)
    #expect(challenge.part1() == 1320)
  }

  @Test func testPart2() async throws {
    let challenge = Day15(data: testData)
    #expect(challenge.part2() == 145)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day15()
    #expect(challenge.part1() == 507769)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day15()
    #expect(challenge.part2() == 269747)
  }

}
