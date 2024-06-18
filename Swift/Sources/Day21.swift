import Algorithms

struct Day21: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let garden: CharGrid
  let start: Point

  init(data: String) {
    self.data = data
    let garden = CharGrid(fromString: data)
    self.garden = garden
    self.start = garden.firstWhere(value: "S")!
  }

  func part1() -> Int {
    moveFinite(startPoint: start)
  }

  func part2() -> Int {
    moveInfinite()
  }

  func moveFinite(startPoint: Point, steps: Int = 64) -> Int {
    func move(step: Int, points: Set<Point>, possibleEndPoints: Set<Point>) -> Int {
      if step == steps {
        return possibleEndPoints.union(points).count
      }

      let nextPoints = Set(
        points.flatMap {
          point in
          garden.adjacentPoints(to: point).filter {
            garden.getValueAtPoint(point: $0) != "#" && !possibleEndPoints.contains($0)
          }
        })
      if (steps - step).isMultiple(of: 2) {
        return move(
          step: step + 1, points: nextPoints,
          possibleEndPoints: possibleEndPoints
        )
      }
      return move(
        step: step + 1, points: nextPoints,
        possibleEndPoints: possibleEndPoints.union(nextPoints)
      )
    }

    return move(step: 0, points: [startPoint], possibleEndPoints: [])
  }

  func moveInfinite(steps: Int = 26_501_365) -> Int {
    assert(garden.width == garden.height, "Garden is a square")
    let size = garden.width
    let gardenOnEitherSide = steps / size - 1

    let gardensSameAsCenter = square(gardenOnEitherSide / 2 * 2 + 1)
    let gardensDifferentToCenter = square((gardenOnEitherSide + 1) / 2 * 2)
    let oddGardenPlotsCount = moveFinite(startPoint: start, steps: size * 2 + 1)
    let evenGardenPlotsCount = moveFinite(startPoint: start, steps: size * 2)
    let plotsOnFullGardens =
      if steps.isMultiple(of: 2) {
        gardensDifferentToCenter * oddGardenPlotsCount + gardensSameAsCenter * evenGardenPlotsCount
      } else {
        gardensDifferentToCenter * evenGardenPlotsCount + gardensSameAsCenter * oddGardenPlotsCount
      }

    let plotsOnEnd = [
      Point(start.x, size - 1), Point(start.x, 0), Point(0, start.y), Point(size - 1, start.y),
    ].map {
      moveFinite(startPoint: $0, steps: size - 1)
    }.reduce(0, +)

    let edgePoints = [
      Point(0, 0), Point(0, size - 1), Point(size - 1, 0), Point(size - 1, size - 1),
    ]

    let plotsOnEdgeSmall = edgePoints.map {
      moveFinite(startPoint: $0, steps: size / 2 - 1) * (gardenOnEitherSide + 1)
    }.reduce(0, +)
    let plotsOnEdgeLarge = edgePoints.map {
      moveFinite(startPoint: $0, steps: 3 * size / 2 - 1) * gardenOnEitherSide
    }.reduce(0, +)

    return plotsOnFullGardens + plotsOnEnd + plotsOnEdgeSmall + plotsOnEdgeLarge
  }
}
