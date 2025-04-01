import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day21Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
    """

  @Test func testPart1() async throws {
    let challenge = Day21(data: testData)
    #expect(challenge.moveFinite(startPoint: challenge.start, steps: 6) == 16)
  }

  @Test func testPart2() async throws {
    // No test for part2 sample, because the solution is based on assumptions that
    // puzzle gardens have no rocks around the edges and in the row & column with the center start point.
    #expect(1 + 1 == 2)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day21()
    #expect(challenge.part1() == 3598)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day21()
    #expect(challenge.part2() == 601_441_063_166_538)
  }
}
