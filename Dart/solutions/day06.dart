import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  List<RaceData> parseInput() {
    final times = <int>[];
    final distances = <int>[];
    for (final line in input.getPerLine()) {
      final [title, ...numbers] = line.split(RegExp(r'\s+'));
      switch (title) {
        case 'Time:':
          times.addAll(numbers.map(int.parse));
        case 'Distance:':
          distances.addAll(numbers.map(int.parse));
      }
    }
    return times
        .mapIndexed(
          (index, element) => (time: element, distance: distances[index]),
        )
        .toList();
  }

  @override
  int solvePart1() {
    final ways = <int>[];
    for (final (:time, :distance) in parseInput()) {
      for (var i = 1; i < time; i++) {
        if ((i * (time - i)) > distance) {
          ways.add(time - i - i + 1);
          break;
        }
      }
    }
    return ways.reduce((value, element) => value * element);
  }

  @override
  int solvePart2() {
    final (:time, :distance) = parseInput().reduce(
      (value, element) => (
        time: int.parse('${value.time}${element.time}'),
        distance: int.parse('${value.distance}${element.distance}')
      ),
    );
    for (var i = 1; i < time; i++) {
      if ((i * (time - i)) > distance) {
        return time - i - i + 1;
      }
    }

    return 0;
  }
}

typedef RaceData = ({int time, int distance});
