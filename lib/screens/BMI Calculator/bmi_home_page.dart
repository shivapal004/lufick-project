import 'package:authentication_app/screens/BMI%20Calculator/bmi_score_page.dart';
import 'package:flutter/material.dart';
import 'package:ruler_scale_picker/ruler_scale_picker.dart';

class BmiHomePage extends StatefulWidget {
  const BmiHomePage({super.key});

  @override
  State<BmiHomePage> createState() => _BmiHomePageState();
}

class _BmiHomePageState extends State<BmiHomePage> {
  double bmiScore = 0;
  String bmiCategory = "";
  final TextEditingController heightTextController =
      TextEditingController(text: "160");
  final TextEditingController weightTextController =
      TextEditingController(text: "60");
  String selectedHeightUnit = "cm";
  String selectedWeightUnit = "kg";

  late NumericRulerScalePickerController heightRulerController;
  late NumericRulerScalePickerController weightRulerController;

  @override
  void initState() {
    super.initState();
    heightRulerController = NumericRulerScalePickerController(
      firstValue: 0,
      lastValue: 200,
      initialValue: 160,
    );

    weightRulerController = NumericRulerScalePickerController(
        firstValue: 0, lastValue: 150, initialValue: 60);

    heightRulerController.addListener(() {
      if (selectedHeightUnit == "cm") {
        heightTextController.text = heightRulerController.value.toString();
      } else {
        heightTextController.text =
            (heightRulerController.value / 30.48).toStringAsFixed(4);
      }
    });
    weightRulerController.addListener(() {
      if (selectedWeightUnit == "kg") {
        weightTextController.text = weightRulerController.value.toString();
      } else {
        weightTextController.text =
            (weightRulerController.value * 2.205).toStringAsFixed(4);
      }
    });
  }

  @override
  void dispose() {
    heightTextController.dispose();
    weightTextController.dispose();
    heightRulerController.dispose();
    weightRulerController.dispose();
    super.dispose();
  }

  void calculateBMI() {
    double? height = double.tryParse(heightTextController.text);
    double? weight = double.tryParse(weightTextController.text);

    if (height! <= 0 || weight! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter valid height and weight")));
      return;
    }

    if (selectedHeightUnit == "ft") {
      height = height / 3.281;
    } else {
      height = height / 100;
    }

    if (selectedWeightUnit == "lb") {
      weight = weight / 2.205;
    }
    setState(() {
      bmiScore = (weight! / (height! * height));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                height: 2,
                thickness: 2,
                indent: 80,
                endIndent: 80,
                color: Colors.black,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      controller: heightTextController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.height),
                          labelText: "Enter your height",
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
                  ),
                  const SizedBox(
                    width: 39,
                  ),
                  DropdownButton(
                      value: selectedHeightUnit,
                      items: ["cm", "ft"].map((String unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHeightUnit = value!;
                          if (selectedHeightUnit == "cm") {
                            heightTextController.text =
                                heightRulerController.value.toString();
                          } else {
                            heightTextController.text =
                                (double.parse(heightTextController.text) / 30.48)
                                    .toStringAsFixed(4);
                          }
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(16)),
                      child: NumericRulerScalePicker(
                        controller: heightRulerController,
                      )),
                  Positioned(
                    left: 1,
                    top: 1,
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16))),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            "in cm",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      controller: weightTextController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.fitness_center),
                          labelText: "Enter your weight",
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
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  DropdownButton(
                      value: selectedWeightUnit,
                      items: ["kg", "lb"].map((String unit) {
                        return DropdownMenuItem(value: unit, child: Text(unit));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWeightUnit = value!;
                          if (selectedWeightUnit == "kg") {
                            weightTextController.text =
                                weightRulerController.value.toString();
                          } else {
                            weightTextController.text =
                                (double.parse(weightTextController.text) * 2.205)
                                    .toStringAsFixed(4);
                          }
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(16)),
                    child: NumericRulerScalePicker(
                        controller: weightRulerController),
                  ),
                  Positioned(
                    left: 1,
                    top: 1,
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16))),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text(
                            "in kg",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    calculateBMI();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BmiScorePage(
                            bmiScore: bmiScore, bmiCategory: bmiCategory)));
                  },
                  child: const Text("Calculate BMI")),
            ],
          ),
        ),
      ),
    );
  }
}
