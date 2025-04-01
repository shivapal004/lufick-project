import 'package:flutter/material.dart';

class BmiHomePage extends StatefulWidget {
  const BmiHomePage({super.key});

  @override
  State<BmiHomePage> createState() => _BmiHomePageState();
}

class _BmiHomePageState extends State<BmiHomePage> {
  double bmi = 0;
  final TextEditingController heightTextController = TextEditingController();
  final TextEditingController weightTextController = TextEditingController();

  @override
  void dispose() {
    heightTextController.dispose();
    weightTextController.dispose();
    super.dispose();
  }

  void calculateBMI() {
    double? height = double.parse(heightTextController.text);
    double? weight = double.parse(weightTextController.text);

    if (height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter valid height and weight")));
      return;
    }
    height = height / 100;    //convert cm -> m
    setState(() {
      bmi = weight / (height! * height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Enter your details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: heightTextController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.height),
                  labelText: "Height(in cm)",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: weightTextController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.height),
                  labelText: "Weight(in kg)",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2))),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  calculateBMI();
                },
                child: const Text("Calculate BMI")),
            const SizedBox(
              height: 20,
            ),
            bmi > 0
                ? Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Your BMI is: ${bmi.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
