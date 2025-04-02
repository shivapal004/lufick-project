import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BmiScorePage extends StatelessWidget {
  const BmiScorePage(
      {super.key, required this.bmiScore, required this.bmiCategory});

  final double bmiScore;
  final String bmiCategory;

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "Normal";
    } else if (bmi >= 25 && bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  Color getBMIColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getBMIMessage(double bmi) {
    if (bmi < 18.5) {
      return "You need to gain weight!";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "Enjoy, You are fit!";
    } else if (bmi >= 25 && bmi < 30) {
      return "Consider maintaining a healthier weight.";
    } else {
      return "It's time to take care of your health.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Result"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Your score",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 250,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 10,
                  maximum: 40,
                  showLabels: true,
                  showTicks: true,
                  axisLineStyle:
                      const AxisLineStyle(thickness: 15, color: Colors.grey),
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 10,
                      endValue: 18.5,
                      color: Colors.blue,
                      startWidth: 15,
                      endWidth: 15,
                    ),
                    GaugeRange(
                      startValue: 18.5,
                      endValue: 24.9,
                      color: Colors.green,
                      startWidth: 15,
                      endWidth: 15,
                    ),
                    GaugeRange(
                      startValue: 25,
                      endValue: 29.9,
                      color: Colors.orange,
                      startWidth: 15,
                      endWidth: 15,
                    ),
                    GaugeRange(
                      startValue: 30,
                      endValue: 40,
                      color: Colors.red,
                      startWidth: 15,
                      endWidth: 15,
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: bmiScore,
                      enableAnimation: true,
                      needleColor: Colors.blue,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        bmiScore.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      positionFactor: 0.5,
                      angle: 90,
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            getBMICategory(bmiScore),
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: getBMIColor(bmiScore)),
          ),
          const SizedBox(height: 5),
          Text(getBMIMessage(bmiScore), style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Re-calculate"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Share.share(
                      "My BMI Score is ${bmiScore.toStringAsFixed(2)}");
                },
                child: const Text("Share"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
