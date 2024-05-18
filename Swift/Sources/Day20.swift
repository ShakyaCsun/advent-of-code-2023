import Algorithms

struct Day20: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  let data: String

  let broadcastTargets: [String]
  let modules: [String: Module]

  init(data: String) {
    self.data = data
    let (targets, modules) = data.split(separator: "\n").reduce(
      (targets: [String](), modules: [Module]())
    ) {
      result, line in
      let splits = line.split(separator: " -> ")
      let destinations = splits[1].split(separator: ", ").map { String($0) }
      let name = String(splits[0])
      if name == "broadcaster" {
        return (destinations, result.1)
      }
      let modules = result.1
      let trimmedName = String(name.trimmingPrefix("%").trimmingPrefix("&"))

      if name.hasPrefix("%") {
        return (
          result.0,
          modules
            + CollectionOfOne(
              Module.flipFlop(
                name: trimmedName, state: false, destinations: destinations)
            )
        )
      }
      return (
        result.0,
        modules
          + CollectionOfOne(
            Module.conjunction(
              name: trimmedName, recentInputs: [:], destinations: destinations
            ))
      )
    }
    self.broadcastTargets = targets
    let conjunctions: [String] =
      modules.filter {
        if case .conjunction(_, _, _) = $0 { return true }
        return false
      }.map({ $0.name })
    let dict = Dictionary(
      uniqueKeysWithValues: conjunctions.map {
        conjunction in
        let inputPulses = Dictionary(
          uniqueKeysWithValues: modules.filter({ $0.destinations.contains(conjunction) }).map {
            ($0.name, Pulse.low)
          })
        return (conjunction, inputPulses)
      })
    self.modules = Dictionary(
      uniqueKeysWithValues: modules.map {
        module in
        switch module {
        case .flipFlop(_, _, _):
          return (module.name, module)
        case .conjunction(let name, _, let destinations):
          return (
            module.name,
            Module.conjunction(name: name, recentInputs: dict[name]!, destinations: destinations)
          )
        }
      })
  }

  func sendPulse(
    in state: inout [String: Module],
    usingCache deque: inout Deque<(from: String, pulse: Pulse, to: String)>,
    pulseAnalyzer: (_ from: String, _ pulse: Pulse, _ to: String) -> Void
  ) {
    if let (from, pulse, to) = deque.popFirst() {
      pulseAnalyzer(from, pulse, to)
      if let module = state[to] {
        let (newModule, pulse) = module.handle(pulse: pulse, from: from)
        state[to] = newModule
        if let pulse = pulse {
          deque.append(
            contentsOf: module.destinations.map { (from: module.name, pulse: pulse, to: $0) }
          )
        }
      }
      sendPulse(in: &state, usingCache: &deque, pulseAnalyzer: pulseAnalyzer)
    }
  }

  func sendPulse(
    in state: inout [String: Module],
    usingCache deque: inout Deque<(from: String, pulse: Pulse, to: String)>
  ) -> (
    high: Int, low: Int
  ) {
    if let (from, pulse, to) = deque.popFirst() {
      if let module = state[to] {
        let (newModule, pulse) = module.handle(pulse: pulse, from: from)
        state[to] = newModule
        if let pulse = pulse {
          deque.append(
            contentsOf: module.destinations.map { (from: module.name, pulse: pulse, to: $0) }
          )
        }
      }

      let (high, low) = sendPulse(in: &state, usingCache: &deque)
      if pulse == .high {
        return (high: high + 1, low: low)
      }
      return (high: high, low: low + 1)
    }
    // Initial low pulse count is set to 1, in order to account for low pulse sent by the button
    return (high: 0, low: 1)
  }

  func part1() -> Int {
    var state = modules
    // let alternative = (1...1000).reduce((high: 0, low: 0)) {
    //   count, _ in
    //   var highCount = 0
    //   var lowCount = 1
    //   var deque: Deque = Deque(
    //     broadcastTargets.map {
    //       (from: "broadcaster", pulse: Pulse.low, to: $0)
    //     })
    //   sendPulse(
    //     in: &state, usingCache: &deque,
    //     pulseAnalyzer: { _, pulse, _ in if pulse == .high { highCount += 1 } else { lowCount += 1 }
    //     }
    //   )
    //   return (high: highCount + count.high, low: lowCount + count.low)
    // }
    // return alternative.high * alternative.low

    let (high, low) = (1...1000).reduce((high: 0, low: 0)) {
      count, _ in
      var deque: Deque = Deque(
        broadcastTargets.map {
          (from: "broadcaster", pulse: Pulse.low, to: $0)
        })
      let (high, low) = sendPulse(in: &state, usingCache: &deque)
      return (high: high + count.high, low: low + count.low)
    }
    return high * low
  }

  func findCycles(inputs: [String]) -> [String: Int] {
    var state = modules
    func buttonPress(
      count: Int = 1,
      foundCycles: inout [String: Int]
    ) {
      if foundCycles.count == inputs.count {
        return
      }
      var deque: Deque = Deque(
        broadcastTargets.map {
          (from: "broadcaster", pulse: Pulse.low, to: $0)
        })
      sendPulse(
        in: &state, usingCache: &deque,
        pulseAnalyzer: {
          from, pulse, to in
          if inputs.contains(from) && pulse == .high {
            foundCycles.merge(
              [from: count],
              uniquingKeysWith: { old, _ in old })
          }
        })
      return buttonPress(count: count + 1, foundCycles: &foundCycles)
    }
    var cycles = [String: Int]()
    buttonPress(foundCycles: &cycles)
    return cycles
  }

  func part2() -> Int {
    let inputToRx: Module = modules.first(where: { key, value in value.destinations.contains("rx") }
    )!.value
    if case Module.conjunction(_, let recentInputs, _) = inputToRx {
      let inputs = recentInputs.map { $0.key }
      let cycles = findCycles(inputs: inputs)
      return cycles.values.reduce(1) {
        result, value in
        lcm(result, value)
      }
    }
    // Should never happen for any real puzzle Input
    return -1
  }
}

enum Pulse { case high, low }

enum Module {

  case flipFlop(name: String, state: Bool, destinations: [String])
  case conjunction(name: String, recentInputs: [String: Pulse], destinations: [String])
}

extension Module {
  var name: String {
    switch self {
    case .flipFlop(let name, _, _):
      return name
    case .conjunction(let name, _, _):
      return name
    }
  }

  var destinations: [String] {
    switch self {
    case .flipFlop(_, _, let destinations):
      return destinations
    case .conjunction(_, _, let destinations):
      return destinations
    }
  }

  func handle(pulse: Pulse, from input: String) -> (Module, Pulse?) {
    switch self {
    case .flipFlop(let name, let state, let destinations):
      if pulse == .high {
        return (self, nil)
      }
      let nextPulse = if state { Pulse.low } else { Pulse.high }
      return (Module.flipFlop(name: name, state: !state, destinations: destinations), nextPulse)

    case .conjunction(let name, let recentInputs, let destinations):
      var inputs = recentInputs
      inputs.updateValue(pulse, forKey: input)
      let newModule = Module.conjunction(
        name: name, recentInputs: inputs, destinations: destinations
      )
      let nextPulse: Pulse =
        if inputs.allSatisfy({ $0.value == .high }) {
          .low
        } else { .high }
      return (newModule, nextPulse)
    }
  }
}
