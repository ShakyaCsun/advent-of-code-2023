import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day20Tests {
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

  @Test func testPart1Sample1() async throws {
    let challenge = Day20(data: testData)
    #expect(challenge.part1() == 32_000_000)
  }

  @Test func testPart1Sample2() async throws {
    let challenge = Day20(data: testData2)
    #expect(challenge.part1() == 11_687_500)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day20()
    #expect(challenge.part1() == 899_848_294)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day20()
    #expect(challenge.part2() == 247_454_898_168_563)
  }
}
