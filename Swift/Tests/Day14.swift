import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day14Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

  @Test func testPart1() async throws {
    let challenge = Day14(data: testData)
    #expect(challenge.part1() == 136)
  }

  @Test func testPart2() async throws {
    let challenge = Day14(data: testData)
    #expect(challenge.part2() == 64)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day14()
    #expect(challenge.part1() == 105784)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day14()
    #expect(challenge.part2() == 91286)
  }
}
