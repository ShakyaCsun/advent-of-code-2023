import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[SetOfCube]] {
    data.split(separator: "\n").map {
      $0.split(separator: ": ").last!.split(separator: "; ").map {
        var greenCubes = 0
        var redCubes = 0
        var blueCubes = 0
        for cubeSet in $0.split(separator: ", ") {
          let splits = cubeSet.split(separator: " ")
          let count = Int(splits[0])!
          let cubeSetType = splits[1]
          switch cubeSetType {
          case "red":
            redCubes = count
          case "blue":
            blueCubes = count
          case "green":
            greenCubes = count
          default:
            break

          }
        }
        return SetOfCube(red: redCubes, green: greenCubes, blue: blueCubes)
      }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    entities.indexed().reduce(
      0
    ) { result, game in
      game.element.allSatisfy { $0.red < 13 && $0.green < 14 && $0.blue < 15 }
        ? result + game.index + 1 : result
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    entities.reduce(
      0
    ) {
      result, game in
      game.reduce(
        SetOfCube(red: 0, green: 0, blue: 0),
        { result, cubeSet in
          SetOfCube(
            red: result.red > cubeSet.red ? result.red : cubeSet.red,
            green: result.green > cubeSet.green ? result.green : cubeSet.green,
            blue: result.blue > cubeSet.blue ? result.blue : cubeSet.blue
          )
        }
      ).power + result
    }
  }
}

struct SetOfCube {
  let red: Int
  let green: Int
  let blue: Int

  var power: Int {
    red * green * blue
  }
}