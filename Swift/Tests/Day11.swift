import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day11Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

  @Test func testPart1() async throws {
    let challenge = Day11(data: testData)
    #expect(challenge.part1() == 374)
  }

  @Test func testExpansion() async throws {
    let challenge = Day11(data: testData)
    #expect(challenge.solve(expandBy: 100) == 8410)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day11()
    #expect(challenge.part1() == 9_233_514)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day11()
    #expect(challenge.part2() == 363_293_506_944)
  }
}
