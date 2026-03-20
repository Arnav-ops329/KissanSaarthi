import 'package:flutter/material.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  String crop = "Wheat";
  String soil = "Alluvial";
  String weather = "Normal";

  TextEditingController areaController = TextEditingController();

  String result = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is String && args.isNotEmpty) {
      if (["Wheat", "Rice", "Potato", "Tomato"].contains(args)) {
        setState(() => crop = args);
      }
    }
  }

  void calculateFertilizer() {
    double area = double.tryParse(areaController.text) ?? 1;

    int n = 0, p = 0, k = 0;

    // 🌾 Base recommendation
    if (crop == "Wheat") {
      n = 120;
      p = 60;
      k = 40;
    } else if (crop == "Rice") {
      n = 100;
      p = 50;
      k = 50;
    } else if (crop == "Potato") {
      n = 150;
      p = 80;
      k = 60;
    } else if (crop == "Tomato") {
      n = 120;
      p = 60;
      k = 60;
    }

    // 🌱 Soil adjustment
    if (soil == "Sandy") {
      n += 20; // more nitrogen needed
    } else if (soil == "Black") {
      k += 10; // potassium rich soil
    }

    // 🌦 Weather adjustment
    String note = "";
    if (weather == "Rainy") {
      note = "Apply fertilizer in split doses to avoid washout.";
    } else if (weather == "Dry") {
      note = "Ensure irrigation after fertilizer application.";
    }

    // 📦 Convert to actual fertilizers
    double urea = (n / 0.46) * area;
    double dap = (p / 0.46) * area;
    double mop = (k / 0.60) * area;

    // 💰 Cost estimation (approx)
    double cost = (urea * 6) + (dap * 25) + (mop * 15); // ₹ per kg approx

    result = """
🌾 Crop: $crop
📍 Area: ${area.toStringAsFixed(1)} acre

🧪 NPK Requirement:
N: $n kg | P: $p kg | K: $k kg (per acre)

📦 Fertilizer Needed:
Urea: ${urea.toStringAsFixed(1)} kg
DAP: ${dap.toStringAsFixed(1)} kg
MOP: ${mop.toStringAsFixed(1)} kg

💰 Estimated Cost: ₹${cost.toStringAsFixed(0)}

⚠️ Advice:
$note
""";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fertilizer Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌾 Crop
            DropdownButtonFormField<String>(
              initialValue: crop,
              items: ["Wheat", "Rice", "Potato", "Tomato"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => crop = val!),
              decoration: const InputDecoration(labelText: "Select Crop"),
            ),

            const SizedBox(height: 15),

            // 🌱 Soil
            DropdownButtonFormField<String>(
              initialValue: soil,
              items: ["Alluvial", "Black", "Sandy"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => soil = val!),
              decoration: const InputDecoration(labelText: "Soil Type"),
            ),

            const SizedBox(height: 15),

            // 🌦 Weather
            DropdownButtonFormField<String>(
              initialValue: weather,
              items: ["Normal", "Dry", "Rainy"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => weather = val!),
              decoration: const InputDecoration(labelText: "Weather Condition"),
            ),

            const SizedBox(height: 15),

            // 📏 Area input
            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Land Area (in acres)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 Button
            ElevatedButton(
              onPressed: calculateFertilizer,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Calculate"),
            ),

            const SizedBox(height: 20),

            // 📊 Result
            if (result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  result,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
