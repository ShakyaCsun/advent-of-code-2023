import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day23Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    #.#####################
    #.......#########...###
    #######.#########.#.###
    ###.....#.>.>.###.#.###
    ###v#####.#v#.###.#.###
    ###.>...#.#.#.....#...#
    ###v###.#.#.#########.#
    ###...#.#.#.......#...#
    #####.#.#.#######.#.###
    #.....#.#.#.......#...#
    #.#####.#.#.#########v#
    #.#...#...#...###...>.#
    #.#.#v#######v###.###v#
    #...#.>.#...>.>.#.###.#
    #####v#.#.###v#.#.###.#
    #.....#...#...#.#.#...#
    #.#########.###.#.#.###
    #...###...#...#...#.###
    ###.###.#.###v#####v###
    #...#...#.#.>.>.#.>.###
    #.###.###.#.###.#.#v###
    #.....###...###...#...#
    #####################.#
    """

  @Test func testPart1() async throws {
    let challenge = Day23(data: testData)
    #expect(challenge.part1() == 94)
  }

  @Test func testPart2() async throws {
    let challenge = Day23(data: testData)
    #expect(challenge.part2() == 154)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day23()
    #expect(challenge.part1() == 2166)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day23()
    #expect(challenge.part2() == 6378)
  }
}
