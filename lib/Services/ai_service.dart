import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';

class AIService {
  Interpreter? interpreter;

  Future loadModel() async {
    interpreter = await Interpreter.fromAsset('plant_model.tflite');
  }

  Future<String> detectDisease(File image) async {
    // preprocessing placeholder

    var output = List.filled(1, 0).reshape([1, 1]);

    interpreter?.run(image, output);

    return "Leaf Blight";
  }
}
