import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day12Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """

  @Test func testPart1() async throws {
    let challenge = Day12(data: testData)
    #expect(challenge.part1() == 21)
  }

  @Test func testPart2() async throws {
    let challenge = Day12(data: testData)
    #expect(challenge.part2() == 525152)
  }

  @Test func testPart1Answer() async throws {
    let challenge = Day12()
    #expect(challenge.part1() == 6871)
  }

  @Test func testPart2Answer() async throws {
    let challenge = Day12()
    #expect(challenge.part2() == 2_043_098_029_844)
  }
}
