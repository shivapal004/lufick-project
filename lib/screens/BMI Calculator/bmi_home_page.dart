import 'package:flutter/material.dart';
import 'package:ruler_scale_picker/ruler_scale_picker.dart';

class BmiHomePage extends StatefulWidget {
  const BmiHomePage({super.key});

  @override
  State<BmiHomePage> createState() => _BmiHomePageState();
}

class _BmiHomePageState extends State<BmiHomePage> {
  double bmi = 0;
  String bmiCategory = "";
  final TextEditingController heightTextController = TextEditingController(text: "160");
  final TextEditingController weightTextController = TextEditingController();
  String selectedHeightUnit = "cm";
  String selectedWeightUnit = "kg";

  late NumericRulerScalePickerController rulerController;

  @override
  void initState() {
    super.initState();
    rulerController = NumericRulerScalePickerController(
      firstValue: 0,
      lastValue: 200,
      initialValue: 160,
    );

    rulerController.addListener(() {
      heightTextController.text = rulerController.value.toString();
    });
  }

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

    if (selectedHeightUnit == "ft/inch") {
      height = height * 0.3048;
    } else {
      height = height / 100;
    }

    if (selectedWeightUnit == "lb") {
      weight = weight * 0.453592;
    }
    setState(() {
      bmi = (weight! / (height! * height));
      bmiCategory = getBMICategory(bmi);
    });
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "Normal weight";
    } else if (bmi >= 25 && bmi < 29.9) {
      return "Overweight";
    } else {
      return "Obese";
    }
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
              const SizedBox(height: 30,),
              const Text(
                "Enter your details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),
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
                    width: 10,
                  ),
                  DropdownButton(
                      value: selectedHeightUnit,
                      items: ["cm", "ft/inch"].map((String unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHeightUnit = value!;
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: NumericRulerScalePicker(
                  controller: rulerController
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      controller: weightTextController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.height),
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
                        });
                      })
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
                  },
                  child: const Text("Calculate BMI")),
              const SizedBox(
                height: 20,
              ),
              bmi > 0
                  ? Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              "Your BMI is: ${bmi.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Category: $bmiCategory",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
        
            ],
          ),
        ),
      ),
    );
  }
}
