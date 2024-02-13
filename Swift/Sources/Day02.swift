import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let entities: [[SetOfCube]]

  init(data: String) {
    self.data = data
    self.entities = data.split(separator: "\n").map {
      $0.split(separator: ": ").last!.split(separator: "; ").map {
        $0.split(separator: ", ").reduce(SetOfCube(red: 0, green: 0, blue: 0)) {
          cubeSet, cubeString in
          let splits = cubeString.split(separator: " ")
          let count = Int(splits[0])!
          let cubeSetType = splits[1]
          switch cubeSetType {
          case "red":
            return cubeSet.copy(red: count)
          case "blue":
            return cubeSet.copy(blue: count)
          case "green":
            return cubeSet.copy(green: count)
          default:
            return cubeSet
          }
        }
      }
    }
  }

  func part1() -> Int {
    entities.indexed().reduce(
      0
    ) { result, game in
      game.element.allSatisfy { $0.red < 13 && $0.green < 14 && $0.blue < 15 }
        ? result + game.index + 1 : result
    }
  }

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

  func copy(red: Int? = nil, green: Int? = nil, blue: Int? = nil) -> SetOfCube {
    SetOfCube(red: red ?? self.red, green: green ?? self.green, blue: blue ?? self.blue)
  }
}
