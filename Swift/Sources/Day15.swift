import Algorithms

struct Day15: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let entities: [String]

  init(data: String) {
    self.data = data
    self.entities = data.trimmingCharacters(in: .newlines).split(separator: ",").map { String($0) }
  }

  func part1() -> Int {
    entities.map {
      hash(input: $0)
    }.reduce(0, +)
  }

  func part2() -> Int {
    let boxes = entities.reduce([Int: [Lens]]()) {
      if $1.last == "-" {
        let label = String($1[..<$1.index(before: $1.endIndex)])
        let boxNumber = hash(input: label)
        return $0.merging(
          [boxNumber: $0[boxNumber, default: []].dashOperation(label: label)],
          uniquingKeysWith: { _, new in new }
        )
      }
      let label = String($1[..<$1.index($1.startIndex, offsetBy: $1.count - 2)])
      let focalLength = $1.last!.wholeNumberValue!
      let boxNumber = hash(input: label)
      return $0.merging(
        [
          boxNumber: $0[boxNumber, default: []].equalOperation(
            label: label, focalLength: focalLength
          )
        ], uniquingKeysWith: { _, new in new }
      )
    }
    return boxes.reduce(0) {
      $0 + $1.value.focusingPower(boxNumber: $1.key)
    }
  }

  func hash(input: String) -> Int {
    input.reduce(0) {
      if let value = $1.asciiValue {
        let sum = $0 + Int(value)
        return (sum * 17) % 256
      }
      return $0
    }
  }
}

struct Lens {
  let label: String
  let focalLength: Int
}

extension [Lens] {
  func dashOperation(label: String) -> [Lens] {
    self.reduce([Lens]()) {
      if $1.label == label {
        return $0
      }
      return $0 + CollectionOfOne($1)
    }
  }

  func equalOperation(label: String, focalLength: Int) -> [Lens] {
    let lens = CollectionOfOne(Lens(label: label, focalLength: focalLength))
    let (newArray, labelChanged) = self.reduce((array: [Lens](), changed: false)) {
      if $1.label == label {
        return ($0.array + lens, true)
      }
      return ($0.array + CollectionOfOne($1), $0.changed)
    }
    if labelChanged {
      return newArray
    }
    return newArray + lens
  }

  func focusingPower(boxNumber: Int) -> Int {
    return enumerated().reduce(0) {
      let boxPower = boxNumber + 1
      let slotNumber = $1.offset + 1
      let focalLength = $1.element.focalLength
      return $0 + (boxPower * slotNumber * focalLength)
    }
  }
}
