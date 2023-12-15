import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  List<String> parseInput() {
    return input.asString.trim().split(',');
  }

  @override
  int solvePart1() {
    var result = 0;
    for (final step in parseInput()) {
      var hashedStep = 0;
      for (final code in step.codeUnits) {
        hashedStep += code;
        hashedStep *= 17;
        hashedStep %= 256;
      }
      result += hashedStep;
    }
    return result;
  }

  @override
  int solvePart2() {
    final boxes = <int, List<LensDescription>>{};
    for (final step in parseInput()) {
      var boxNumber = 0;
      for (final (index, code) in step.codeUnits.indexed) {
        if (code == 45) {
          if (boxes.containsKey(boxNumber)) {
            boxes[boxNumber] =
                boxes[boxNumber]!.removeLabel(step.substring(0, index));
          }
          break;
        }
        if (code == 61) {
          final focalLength = String.fromCharCodes(
            step.codeUnits.skip(index + 1),
          );
          boxes[boxNumber] = (boxes[boxNumber] ?? []).addLens(
            (label: step.substring(0, index), focalLength: focalLength),
          );
          break;
        }
        boxNumber += code;
        boxNumber *= 17;
        boxNumber %= 256;
      }
    }
    return boxes.entries.fold<int>(0, (previousValue, element) {
      final boxWeight = element.key + 1;
      return previousValue +
          element.value.foldIndexed(
            0,
            (i, previousValue, lens) =>
                previousValue +
                boxWeight * (i + 1) * int.parse(lens.focalLength),
          );
    });
  }
}

typedef LensDescription = ({String label, String focalLength});

extension on List<LensDescription> {
  List<LensDescription> removeLabel(String label) {
    return [...this]..removeWhere((element) => element.label == label);
  }

  List<LensDescription> addLens(LensDescription lens) {
    final labelIndex = indexWhere((element) => element.label == lens.label);
    final newList = [...this];
    if (labelIndex == -1) {
      return newList..add(lens);
    }
    newList[labelIndex] = lens;
    return newList;
  }
}
