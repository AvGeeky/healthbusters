// import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'dart:ffi' as ffi;
// import 'dart:io';

// late Interpreter interpreter;

// Future<void> loadModel() async {
  
//   interpreter = await Interpreter.fromAsset('assets/model/model.tflite');

// }

// Future<void> runInference() async {
//   // Step 1: Load the model
//   await loadModel();

//   // // Step 2: Initialize TensorFlow Lite Interpreter with the downloaded model
//   // final interpreter = Interpreter.fromFile(File(modelPath));

//   // // Step 3: Prepare input data
//   // // Example input corresponding to the provided features
//   // var input = [65.0, 17.0, 7.5, 6500.0, 350000.0, 65.0, 1.0];  // Ensure all inputs are in the expected format (double in this case)
//   // var output = List.filled(1, 0).reshape([1, 1]);  // Adjust the shape as per your model's output requirements

//   // // Step 4: Run the inference
//   // interpreter.run(input.reshape([1, input.length]), output);

//   // // Step 5: Print the output
//   // print('Prediction: ${output[0][0]}');
// }
