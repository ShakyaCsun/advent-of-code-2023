import Algorithms

struct Day18: AdventDay {
  init(data: String) {
    self.data = data
    self.digPlan = data.split(separator: "\n").map {
      DigStep(from: String($0))
    }
  }

  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let digPlan: [DigStep]

  func solve(digSteps: [DigStep]) -> Int {
    let vertices: [Point] = digSteps.reduce([Point.origin]) {
      vertices, digStep in
      vertices + [vertices.last! + (digStep.direction * digStep.meters)]
    }
    let boundaryPoints = digSteps.reduce(0) {
      $0 + $1.meters
    }
    let area = areaShoeLace(vertices: vertices)

    return boundaryPoints + interiorPoints(area: area, boundaryCount: boundaryPoints)
  }

  func part1() -> Int {
    solve(digSteps: digPlan)
  }

  func part2() -> Int {
    solve(digSteps: digPlan.map { $0.hexDigStep })
  }
}

struct DigStep {

  let direction: Point
  let meters: Int
  let color: String

  var hexDirection: Point {
    if let last = color.last {
      switch last {
      case "0":
        return Point.toRight
      case "1":
        return Point.toDown
      case "2":
        return Point.toLeft
      case "3":
        return Point.toUp

      default:
        return Point.origin
      }
    }
    return Point.origin
  }

  var hexMeters: Int {
    let meters = color[color.startIndex..<color.index(before: color.endIndex)]
    return Int(meters, radix: 16)!
  }

  var hexDigStep: DigStep {
    return DigStep(direction: hexDirection, meters: hexMeters, color: color)
  }
}

extension DigStep {

  init(from line: String) {
    let splits = line.split(separator: " ")
    let directionString = String(splits[0])
    let direction =
      if directionString == "R" {
        Point.toRight
      } else if directionString == "U" {
        Point.toUp
      } else if directionString == "L" {
        Point.toLeft
      } else {
        Point.toDown
      }
    let meters = Int(splits[1])!
    let color = String(Array(splits[2])[2...7])

    self.direction = direction
    self.meters = meters
    self.color = color
  }
}
