import 'package:flutter/material.dart';

class FertilizerScreen extends StatefulWidget {
  @override
  _FertilizerScreenState createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  String crop = "Wheat";
  String soil = "Alluvial";
  String weather = "Normal";

  TextEditingController areaController = TextEditingController();

  String result = "";

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
      appBar: AppBar(title: Text("Fertilizer Calculator")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌾 Crop
            DropdownButtonFormField(
              value: crop,
              items: ["Wheat", "Rice", "Potato", "Tomato"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => crop = val!),
              decoration: InputDecoration(labelText: "Select Crop"),
            ),

            SizedBox(height: 15),

            // 🌱 Soil
            DropdownButtonFormField(
              value: soil,
              items: ["Alluvial", "Black", "Sandy"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => soil = val!),
              decoration: InputDecoration(labelText: "Soil Type"),
            ),

            SizedBox(height: 15),

            // 🌦 Weather
            DropdownButtonFormField(
              value: weather,
              items: ["Normal", "Dry", "Rainy"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => weather = val!),
              decoration: InputDecoration(labelText: "Weather Condition"),
            ),

            SizedBox(height: 15),

            // 📏 Area input
            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Land Area (in acres)",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // 🔘 Button
            ElevatedButton(
              onPressed: calculateFertilizer,
              child: Text("Calculate"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),

            SizedBox(height: 20),

            // 📊 Result
            if (result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  result,
                  style: TextStyle(fontSize: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
