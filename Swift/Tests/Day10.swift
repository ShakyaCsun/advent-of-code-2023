import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day10Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """
  let testData2 = """
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """

  @Test func testPart1() async throws {
    let challenge = Day10(data: testData)
    #expect(challenge.part1() == 8)
  }

  @Test func testPart2() async throws {
    let challenge = Day10(data: testData2)
    #expect(challenge.part2() == 10)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day10()
    #expect(challenge.part1() == 6823)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day10()
    #expect(challenge.part2() == 415)
  }
}
