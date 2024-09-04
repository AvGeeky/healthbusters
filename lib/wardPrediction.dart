import 'dart:io';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:path/path.dart' as path;

class MinMaxScaler {
  final double min;
  final double max;
  Map<String, double> minValues = {};
  Map<String, double> maxValues = {};

  MinMaxScaler({this.min = 0.0, this.max = 1.0});

  void fit(List<Map<String, double>> data, List<String> features) {
    for (var feature in features) {
      final values = data.map((row) => row[feature]!).toList();
      minValues[feature] = values.reduce((a, b) => a < b ? a : b);
      maxValues[feature] = values.reduce((a, b) => a > b ? a : b);
    }
  }

  Map<String, double> transform(
      Map<String, double> row, List<String> features) {
    return {
      for (var feature in features)
        feature: (row[feature]! - minValues[feature]!) /
                (maxValues[feature]! - minValues[feature]!) *
                (max - min) +
            min
    };
  }
}

class ScaleData {
  List<List<double>> scaleData(Map<String, double>? inputData) {
    final List<Map<String, double>> data = [
      {
        'HAEMATOCRIT': 45,
        'HAEMOGLOBINS': 13,
        'ERYTHROCYTE': 5.5,
        'LEUCOCYTE': 4500,
        'THROMBOCYTE': 150000,
        'AGE': 25,
        'SEX': 1
      },
      {
        'HAEMATOCRIT': 50,
        'HAEMOGLOBINS': 14,
        'ERYTHROCYTE': 6.0,
        'LEUCOCYTE': 5000,
        'THROMBOCYTE': 200000,
        'AGE': 35,
        'SEX': 0
      },
      {
        'HAEMATOCRIT': 55,
        'HAEMOGLOBINS': 15,
        'ERYTHROCYTE': 6.5,
        'LEUCOCYTE': 5500,
        'THROMBOCYTE': 250000,
        'AGE': 45,
        'SEX': 1
      },
      {
        'HAEMATOCRIT': 60,
        'HAEMOGLOBINS': 16,
        'ERYTHROCYTE': 7.0,
        'LEUCOCYTE': 6000,
        'THROMBOCYTE': 300000,
        'AGE': 55,
        'SEX': 0
      },
      {
        'HAEMATOCRIT': 65,
        'HAEMOGLOBINS': 17,
        'ERYTHROCYTE': 7.5,
        'LEUCOCYTE': 6500,
        'THROMBOCYTE': 350000,
        'AGE': 65,
        'SEX': 1
      },
    ];

    final List<String> features = [
      'HAEMATOCRIT',
      'HAEMOGLOBINS',
      'ERYTHROCYTE',
      'LEUCOCYTE',
      'THROMBOCYTE',
      'AGE'
    ];

    final MinMaxScaler scaler = MinMaxScaler(min: 0.0, max: 1.0);

    // Fit the scaler on the data
    scaler.fit(data, features);

    // Transform the data
    final scaledData = data.map((row) {
      final transformedRow = scaler.transform(row, features);
      return [
        transformedRow['HAEMATOCRIT']!,
        transformedRow['HAEMOGLOBINS']!,
        transformedRow['ERYTHROCYTE']!,
        transformedRow['LEUCOCYTE']!,
        transformedRow['THROMBOCYTE']!,
        transformedRow['AGE']!,
        row['SEX']!
      ];
    }).toList();

    return scaledData;
  }

  // Load TFLite model
  // final modelPath = path.join(Directory.current.path, 'assets', 'model.tflite');
  // final interpreter = await Interpreter.fromFile(File(modelPath));

  // // Prepare output tensor
  // final outputTensor = List.filled(1, 0.0);

  // // Make predictions
  // final predictions = <double>[];
  // for (var inputArray in scaledData) {
  //   interpreter.run(inputArray, outputTensor);
  //   predictions.add(outputTensor[0]);
  // }

  // // Display the predictions
  // for (var prediction in predictions) {
  //   print('Prediction: $prediction');
  // }
}
