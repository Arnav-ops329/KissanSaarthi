import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/voice_flow_provider.dart';
import '../Widgets/global_voice_button.dart';
import '../localization/app_localizations.dart';

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
  String verifiedAdvice = "";

  @override
  void initState() {
    super.initState();
    areaController.addListener(() {
      setState(() {});
    });

    // Initialize crop from AppProvider
    final appProv = Provider.of<AppProvider>(context, listen: false);
    if (appProv.selectedCrop.isNotEmpty &&
        ["Wheat", "Rice", "Potato", "Tomato"].contains(appProv.selectedCrop)) {
      crop = appProv.selectedCrop;
    }
  }

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

  void calculateFertilizer({String? overrideCrop, String? overrideArea}) {
    final String activeCrop = overrideCrop ?? crop;
    final double area =
        double.tryParse(overrideArea ?? areaController.text) ?? 1;

    int n = 0, p = 0, k = 0;

    // 🌾 Base recommendation (ICAR Verified Standards)
    if (activeCrop == "Wheat") {
      n = 120;
      p = 60;
      k = 40;
      verifiedAdvice =
          "Apply 1/2 Nitrogen and full P & K as basal dose. Apply remaining N in two splits at CRI and Flowering stages.";
    } else if (activeCrop == "Rice") {
      n = 100;
      p = 50;
      k = 50;
      verifiedAdvice =
          "Apply N in three equal splits: Basal, Tillering, and Panicle Initiation. Apply P & K as basal.";
    } else if (activeCrop == "Potato") {
      n = 150;
      p = 80;
      k = 120;
      verifiedAdvice =
          "Apply 1/2 Nitrogen and full P & K at planting. Remaining N should be top-dressed at earthing up.";
    } else if (activeCrop == "Tomato") {
      n = 120;
      p = 60;
      k = 60;
      verifiedAdvice =
          "Apply Basal Dose of N,P,K. Top dress N in 3 splits at 30, 60, and 90 days after transplanting.";
    }

    // 🌱 Soil adjustment
    if (soil == "Sandy") {
      n += 20;
    } else if (soil == "Black") {
      k += 10;
    }

    // 🌦 Weather adjustment
    String note = "";
    if (weather == "Rainy") {
      note = "Top-dress nitrogen only when soil is moist but not waterlogged.";
    } else if (weather == "Dry") {
      note =
          "Irrigate immediately after applying urea to prevent ammonia volatilization.";
    }

    if (note.isNotEmpty) {
      verifiedAdvice = "$verifiedAdvice\n\n🌦 Weather Note: $note";
    }

    // 📦 Convert to actual fertilizers
    double urea = (n / 0.46) * area;
    double dap = (p / 0.46) * area;
    double mop = (k / 0.60) * area;

    double cost = (urea * 6) + (dap * 25) + (mop * 15);

    result = """
🌾 Crop: $activeCrop
📍 Area: ${area.toStringAsFixed(1)} acre

🧪 NPK Requirement (per acre):
N: $n kg | P: $p kg | K: $k kg

📦 Recommended Fertilizer:
Urea: ${urea.toStringAsFixed(1)} kg
DAP: ${dap.toStringAsFixed(1)} kg
MOP: ${mop.toStringAsFixed(1)} kg

💰 Estimated Cost: ₹${cost.toStringAsFixed(0)}
""";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final voiceFlow = Provider.of<VoiceFlowProvider>(context);

    // 🛡️ REFACTORED: Compute display values instead of modifying state in build
    final String displayCrop = (voiceFlow.activeFlow == VoiceFlow.fertilizer &&
            voiceFlow.data.containsKey('crop'))
        ? voiceFlow.data['crop']!
        : crop;

    final String displayArea = (voiceFlow.activeFlow == VoiceFlow.fertilizer &&
            voiceFlow.data.containsKey('area'))
        ? voiceFlow.data['area']!
        : areaController.text;

    // Trigger calculation if derived data differs and is ready
    if (result.isEmpty ||
        !result.contains(displayArea) ||
        !result.contains(displayCrop)) {
      Future.microtask(() {
        if (mounted) {
          calculateFertilizer(
              overrideCrop: displayCrop, overrideArea: displayArea);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc('fertilizer_calculator')),
        actions: [
          if (voiceFlow.activeFlow == VoiceFlow.fertilizer)
            IconButton(
                onPressed: () => voiceFlow.stopFlow(),
                icon: const Icon(Icons.stop_circle, color: Colors.red))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (voiceFlow.activeFlow == VoiceFlow.fertilizer)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200)),
                child: Row(
                  children: [
                    const Icon(Icons.mic, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(voiceFlow.lastGuidance,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green))),
                  ],
                ),
              ),

            // 🌾 Crop
            DropdownButtonFormField<String>(
              initialValue: displayCrop,
              items: ["Wheat", "Rice", "Potato", "Tomato"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(context.loc(e.toLowerCase()))))
                  .toList(),
              onChanged: (val) {
                setState(() => crop = val!);
                calculateFertilizer();
              },
              decoration: InputDecoration(
                  labelText: context.loc('select_crop'), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: soil,
                    items: ["Alluvial", "Black", "Sandy"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(context.loc(e.toLowerCase()))))
                        .toList(),
                    onChanged: (val) {
                      setState(() => soil = val!);
                      calculateFertilizer();
                    },
                    decoration: InputDecoration(
                        labelText: context.loc('soil_type'), border: const OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: weather,
                    items: ["Normal", "Dry", "Rainy"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(context.loc(e.toLowerCase()))))
                        .toList(),
                    onChanged: (val) {
                      setState(() => weather = val!);
                      calculateFertilizer();
                    },
                    decoration: InputDecoration(
                        labelText: context.loc('weather'), border: const OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: context.loc('land_area'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.landscape)),
              onSubmitted: (_) => calculateFertilizer(),
            ),
            const SizedBox(height: 30),

            if (result.isNotEmpty) ...[
              Text(context.loc('calculation_result'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade100)),
                child: Text(result,
                    style: const TextStyle(fontSize: 16, height: 1.5)),
              ),
              const SizedBox(height: 20),
              Text("📝 ${context.loc('verified_agri_advice')}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100)),
                child: Text(verifiedAdvice,
                    style: const TextStyle(fontSize: 14, color: Colors.blue)),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: const GlobalVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
