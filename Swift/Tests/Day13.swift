import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day13Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

  @Test func testPart1() async throws {
    let challenge = Day13(data: testData)
    #expect(challenge.part1() == 405)
  }

  @Test func testPart2() async throws {
    let challenge = Day13(data: testData)
    #expect(challenge.part2() == 400)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day13()
    #expect(challenge.part1() == 29846)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day13()
    #expect(challenge.part2() == 25401)
  }
}
