import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let entities: InputEntity

  private init(data: String, entities: InputEntity) {
    self.data = data
    self.entities = entities
  }

  init(data: String) {
    self.init(data: data, entities: InputEntity.init(from: data))
  }

  func part1() -> Int {
    entities.solvePart1()
  }

  func part2() -> Int {
    entities.solvePart2()
  }
}

struct InputEntity {

  let seeds: [Int]
  let mappings: [[SourceMap]]

  init(from input: String) {
    let blocks = input.split(separator: "\n\n")
    self.seeds = blocks[0].split(separator: " ").compactMap({ Int($0) })
    self.mappings = blocks[1...].map {
      $0.split(separator: "\n")[1...].map {
        let numbers = $0.split(separator: " ").compactMap { Int($0) }
        return SourceMap(numbers[0], numbers[1], numbers[2])
      }
    }
  }

  func solvePart1() -> Int {
    seeds.map {
      mappings.reduce($0) {
        getDestination(from: $0, using: $1)
      }
    }.min() ?? 0
  }

  func solvePart2() -> Int {
    let seedRanges = seeds.chunks(ofCount: 2).map { Array($0) }.map {
      $0[0]..<($0[0] + $0[1])
    }
    return mappings.reduce(seedRanges) {
      getDestinationRanges(from: $0, using: $1)
    }.map(\.lowerBound).min() ?? 0
  }
}

private func getDestinationRanges(
  from sourceRanges: [Range<Int>],
  using maps: [SourceMap]
) -> [Range<Int>] {
  let emptyRangeArray = [Range<Int>]()
  let (unmappedRanges, mappedDestinationRanges) = maps.reduce((sourceRanges, emptyRangeArray)) {
    partialResult, sourceMap in
    let (sources, destinations) = partialResult
    if sources.isEmpty {
      return partialResult
    }
    let mappedDestinations = sources.map {
      range in
      let mappableRange = range.clamped(to: sourceMap.sourceRange)
      if mappableRange.isEmpty {
        return ([range], emptyRangeArray)
      }
      let mappedRanges = [mappableRange.offset(by: sourceMap.offset)]
      if mappableRange == range {
        return (emptyRangeArray, mappedRanges)
      }
      let (start, end) = range.bounds
      let (boundStart, boundEnd) = mappableRange.bounds
      if boundStart > start && boundEnd < end {
        return ([start..<boundStart, boundEnd..<end], mappedRanges)
      }
      if boundStart > start {
        return ([start..<boundStart], mappedRanges)
      }
      return ([boundEnd..<end], mappedRanges)
    }

    return mappedDestinations.reduce((emptyRangeArray, destinations)) {
      partialResult, element in (partialResult.0 + element.0, partialResult.1 + element.1)
    }
  }
  return unmappedRanges + mappedDestinationRanges
}

private func getDestination(from source: Int, using maps: [SourceMap]) -> Int {
  if let correctMap = maps.first(where: { $0.containsSource(source) }) {
    return correctMap.getDestination(from: source)
  }
  return source
}

struct SourceMap {
  let offset: Int
  let sourceRange: Range<Int>
  let destinationRange: Range<Int>

  init(_ destination: Int, _ source: Int, _ length: Int) {
    self.offset = destination - source
    self.sourceRange = source..<(source + length)
    self.destinationRange = destination..<(destination + length)
  }

  func containsSource(_ source: Int) -> Bool {
    sourceRange.contains(source)
  }

  func containsDestination(_ destination: Int) -> Bool {
    destinationRange.contains(destination)
  }

  func getDestination(from source: Int) -> Int {
    assert(containsSource(source))
    return source + offset
  }

  func getSource(from destination: Int) -> Int {
    assert(containsDestination(destination))
    return destination - offset
  }
}

extension Range<Int> {
  var bounds: (Int, Int) {
    (lowerBound, upperBound)
  }

  func offset(by offset: Int) -> Range<Int> {
    (lowerBound + offset)..<(upperBound + offset)
  }
}
