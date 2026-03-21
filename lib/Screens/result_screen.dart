import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String disease = "";
  String crop = "";
  String confidence = "";
  String solution = "";

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    
    if (args is Map<String, dynamic>) {
      setState(() {
        disease = args["disease"] ?? "Unknown";
        crop = args["crop"] ?? "General";
        confidence = args["confidence"] ?? "0";
        solution = args["solution"] ?? "No solution provided";
        isLoading = false;
      });
    } else {
      setState(() {
        disease = "Invalid Arguments";
        isLoading = false;
      });
    }
  }

  Widget buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc('diagnosis_result')),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildInfoCard(context.loc('selected_crop'), crop, Icons.eco),
                  buildInfoCard(context.loc('detected_disease'), disease, Icons.bug_report),
                  buildInfoCard(context.loc('ai_confidence'), "$confidence%", Icons.analytics),
                  buildInfoCard(context.loc('ai_agronomist_advice'), solution, Icons.healing),
                ],
              ),
            ),
    );
  }
}
