import Algorithms

struct Day17: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let grid: Grid2d<Int>

  init(data: String) {
    self.data = data
    self.grid = Grid2d(fromString: data)
  }

  func part1() -> Int {
    solve(minStep: 0, maxStep: 3)
  }

  func part2() -> Int {
    solve(minStep: 4, maxStep: 10)
  }

  func solve(minStep: Int, maxStep: Int) -> Int {
    let goalIndex = grid.lastPoint
    var heap = Heap([
      VisitedCityBlock(heatLoss: 0, index: Point.origin, direction: Point.toRight, steps: 0),
      VisitedCityBlock(heatLoss: 0, index: Point.origin, direction: Point.toDown, steps: 0),
    ])
    var set: Set<CityBlock> = Set(
      [Point.toLeft, Point.toUp].flatMap { direction in
        (1...3).map { step in CityBlock(index: Point.origin, direction: direction, steps: step) }
      }
    )

    func dijkstra(heap: inout Heap<VisitedCityBlock>, seen: inout Set<CityBlock>) -> Int {
      if let min = heap.popMin() {
        if min.index == goalIndex && min.steps >= minStep {
          return min.heatLoss
        }
        neighbours(of: min, minStep: minStep, maxStep: maxStep).apply {
          if seen.insert($0.asCityBlock).inserted {
            heap.insert($0)
          }
        }
        return dijkstra(heap: &heap, seen: &seen)
      }
      return -1
    }
    return dijkstra(heap: &heap, seen: &set)
  }

  func neighbours(of cityBlock: VisitedCityBlock, minStep: Int, maxStep: Int) -> [VisitedCityBlock]
  {
    return Point.directions.filter {
      $0 != Point(-cityBlock.direction.x, -cityBlock.direction.y)
    }.compactMap {
      direction in
      let continueDirection = direction == cityBlock.direction
      if continueDirection && cityBlock.steps == maxStep {
        return nil
      }
      if !continueDirection && cityBlock.steps < minStep {
        return nil
      }
      let nextIndex = cityBlock.index + direction
      if grid.isValidPoint(point: nextIndex) {
        return VisitedCityBlock(
          heatLoss: cityBlock.heatLoss + grid.getValueAtPoint(point: nextIndex),
          index: nextIndex,
          direction: direction, steps: continueDirection ? cityBlock.steps + 1 : 1
        )
      }
      return nil
    }
  }
}

struct VisitedCityBlock: Comparable {
  let heatLoss: Int
  let index: Point
  let direction: Point
  let steps: Int

  static func < (lhs: VisitedCityBlock, rhs: VisitedCityBlock) -> Bool {
    lhs.heatLoss < rhs.heatLoss
  }

  var asCityBlock: CityBlock {
    CityBlock(index: index, direction: direction, steps: steps)
  }
}

struct CityBlock: Hashable {

  let index: Point
  let direction: Point
  let steps: Int
}
