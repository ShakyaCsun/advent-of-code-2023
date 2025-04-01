import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day17Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
    """

  @Test func testPart1() async throws {
    let challenge = Day17(data: testData)
    #expect(challenge.part1() == 102)
  }

  @Test func testPart2() async throws {
    let challenge = Day17(data: testData)
    #expect(challenge.part2() == 94)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day17()
    #expect(challenge.part1() == 1260)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day17()
    #expect(challenge.part2() == 1416)
  }
}
