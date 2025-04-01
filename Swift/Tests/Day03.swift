import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day03Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

  @Test func testPart1() async throws {
    let challenge = Day03(data: testData)
    #expect(challenge.part1() == 4361)
  }

  @Test func testPart2() async throws {
    let challenge = Day03(data: testData)
    #expect(challenge.part2() == 467835)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day03()
    #expect(challenge.part1() == 556367)
  }

  @Test func testPart2Answer() {
    let challenge = Day03()
    #expect(challenge.part2() == 89_471_771)
  }
}
