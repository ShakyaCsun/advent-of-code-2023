import 'package:equatable/equatable.dart';

import '../utils/index.dart';
import 'index.dart';

class Day20 extends GenericDay {
  Day20() : super(20);

  @override
  Map<String, Module> parseInput() {
    final modules = <String, Module>{};
    final conjunctions = <String>{};
    for (final line in input.getPerLine()) {
      final [module, destinations, ...] = line.split(' -> ');
      final destinationNames = destinations.split(', ');
      if (module.startsWith('%')) {
        final name = module.substring(1);
        modules[name] = FlipFlop(destinations: destinationNames, name: name);
      } else if (module.startsWith('&')) {
        final name = module.substring(1);
        conjunctions.add(name);
        modules[name] = Conjunction(destinations: destinationNames, name: name);
      } else {
        assert(
          module == 'broadcaster',
          'Module must be either Flip-flops, Conjunctions or broadcaster',
        );
        modules[module] = Broadcaster(destinations: destinationNames);
      }
    }
    for (final conjunction in conjunctions) {
      final inputs = <String>{};
      modules.forEach((key, value) {
        if (value.destinations.contains(conjunction)) {
          inputs.add(key);
        }
      });
      modules[conjunction] = (modules[conjunction]! as Conjunction).copyWith(
        recentPulses: {for (final input in inputs) input: Pulse.low},
      );
    }
    return modules;
  }

  @override
  int solvePart1() {
    final modules = parseInput();
    var currentModules = {...modules};
    for (var i = 1; i <= 1000; i++) {
      currentModules = currentModules.pressButton();
    }
    return Module.highPulseCount * Module.lowPulseCount;
  }

  @override
  int solvePart2() {
    final modules = parseInput();
    final MapEntry(key: inputToRx, value: module) = modules.entries.firstWhere(
      (element) => element.value.destinations.contains('rx'),
    );
    assert(
      module is Conjunction,
      'Conjunction sends low pulse very rarely, '
      'which makes it the perfect input to rx. '
      'And it is a conjunction in my input.',
    );
    final inputToInput = modules.keys
        .where(
          (element) =>
              modules[element]?.destinations.contains(inputToRx) ?? false,
        )
        .toSet();
    final cyclesEvery = <String, int>{};
    var buttonPresses = 0;
    const confirmAfterCycles = 5;
    while (true) {
      buttonPresses++;
      final queue = QueueList<(String, Pulse, String)>()
        ..add(('broadcaster', Pulse.low, 'button'));
      while (queue.isNotEmpty) {
        final (module, pulse, from) = queue.removeFirst();
        if (inputToInput.contains(from) && pulse == Pulse.high) {
          if (cyclesEvery.keys.contains(from)) {
            assert(
              buttonPresses % cyclesEvery[from]! == 0,
              'The input to $from is not cycling as assumed',
            );
          } else {
            cyclesEvery[from] = buttonPresses;
          }
          if (cyclesEvery.length == inputToInput.length) {
            if (buttonPresses >= cyclesEvery.values.max * confirmAfterCycles) {
              return lcmUsingGcd(cyclesEvery.values.toList());
            }
          }
        }
        if (!modules.containsKey(module)) {
          continue;
        }
        final (updatedModule, updatedPulse) =
            modules[module]!.receivePulse(pulse, from);
        modules[module] = updatedModule;
        if (updatedPulse != null) {
          for (final destination in updatedModule.destinations) {
            queue.add((destination, updatedPulse, updatedModule.name));
          }
        }
      }
    }
  }
}

extension on Map<String, Module> {
  Map<String, Module> pressButton() {
    final copy = {...this};
    final queue = QueueList<(String, Pulse, String)>()
      ..add(('broadcaster', Pulse.low, 'button'));
    while (queue.isNotEmpty) {
      final (module, pulse, from) = queue.removeFirst();
      if (!copy.containsKey(module)) {
        Module.incrementCounters(pulse);
        continue;
      }
      final (updatedModule, updatedPulse) =
          copy[module]!.receivePulse(pulse, from);
      copy[module] = updatedModule;
      if (updatedPulse != null) {
        for (final destination in updatedModule.destinations) {
          queue.add((destination, updatedPulse, updatedModule.name));
        }
      }
    }
    return copy;
  }
}

enum Pulse {
  high,
  low,
}

sealed class Module extends Equatable {
  const Module({
    required this.destinations,
    required this.name,
  });

  final List<String> destinations;
  final String name;

  static int lowPulseCount = 0;
  static int highPulseCount = 0;

  (Module, Pulse?) receivePulse(Pulse incoming, String from);

  static void incrementCounters(Pulse incoming) {
    switch (incoming) {
      case Pulse.high:
        highPulseCount++;
      case Pulse.low:
        lowPulseCount++;
    }
  }

  static void resetCounter() {
    lowPulseCount = 0;
    highPulseCount = 0;
  }
}

class Broadcaster extends Module {
  const Broadcaster({required super.destinations}) : super(name: 'broadcaster');

  @override
  (Broadcaster, Pulse) receivePulse(Pulse incoming, String _) {
    Module.incrementCounters(incoming);
    return (copy(), incoming);
  }

  Broadcaster copy() {
    return Broadcaster(destinations: destinations);
  }

  @override
  List<Object?> get props => [destinations];
}

class FlipFlop extends Module {
  const FlipFlop({
    required super.destinations,
    required super.name,
    this.state = false,
  });

  /// true: represents on state
  /// false: represents off state
  final bool state;

  @override
  (FlipFlop, Pulse?) receivePulse(Pulse incoming, String _) {
    Module.incrementCounters(incoming);
    if (incoming == Pulse.high) {
      return (changeState(), null);
    }
    if (state) {
      return (changeState(state: false), Pulse.low);
    }
    return (changeState(state: true), Pulse.high);
  }

  FlipFlop changeState({bool? state}) {
    return FlipFlop(
      destinations: destinations,
      name: name,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [state, name, destinations];
}

class Conjunction extends Module {
  const Conjunction({
    required super.destinations,
    required super.name,
    this.recentPulses = const {},
  });

  final Map<String, Pulse> recentPulses;

  Pulse getRecentPulse(String input) {
    if (recentPulses.containsKey(input)) {
      return recentPulses[input]!;
    }
    return Pulse.low;
  }

  bool get sameAsInitial {
    return recentPulses.values.every((element) => element == Pulse.low);
  }

  bool get sendLowPulse {
    return recentPulses.values.every((element) => element == Pulse.high);
  }

  @override
  (Conjunction, Pulse?) receivePulse(Pulse incoming, String from) {
    Module.incrementCounters(incoming);
    final updatedModule =
        copyWith(recentPulses: {...recentPulses, from: incoming});
    if (updatedModule.sendLowPulse) {
      return (updatedModule, Pulse.low);
    }
    return (updatedModule, Pulse.high);
  }

  Conjunction copyWith({required Map<String, Pulse> recentPulses}) {
    return Conjunction(
      destinations: destinations,
      name: name,
      recentPulses: recentPulses,
    );
  }

  @override
  List<Object?> get props => [name, destinations, recentPulses];
}
