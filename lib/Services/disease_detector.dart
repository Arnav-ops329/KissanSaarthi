import 'package:tflite_flutter/tflite_flutter.dart';

class DiseaseDetector {
  late Interpreter interpreter;

  Future loadModel() async {
    interpreter = await Interpreter.fromAsset('model.tflite');
  }

  List<double> runModel(List<double> input) {
    var output = List.filled(1 * 10, 0).reshape([1, 10]);

    interpreter.run(input, output);

    return output[0];
  }
}
