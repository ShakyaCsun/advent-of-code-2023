import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day01Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

  let testData2 = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """
  @Test func testPart1() async throws {
    let challenge = Day01(data: testData)
    #expect(challenge.part1() == 142)
  }

  @Test func testPart2() async throws {
    let challenge = Day01(data: testData2)
    #expect(challenge.part2() == 281)
  }
}
