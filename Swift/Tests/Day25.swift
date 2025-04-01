import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day25Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    jqt: rhn xhk nvd
    rsh: frs pzl lsr
    xhk: hfx
    cmg: qnr nvd lhk bvb
    rhn: xhk bvb hfx
    bvb: xhk hfx
    pzl: lsr hfx nvd
    qnr: nvd
    ntq: jqt hfx bvb xhk
    nvd: lhk
    lsr: lhk
    rzs: qnr cmg lsr rsh
    frs: qnr lhk lsr
    """

  @Test func testPart1() async throws {
    let challenge = Day25(data: testData)
    #expect(challenge.part1() == 54)
  }

  @Test func testPart2() async throws {
    let challenge = Day25(data: testData)
    #expect(challenge.part2() == 0)
  }
}
