import 'package:flutter/material.dart';

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
        title: const Text("Detection Result"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildInfoCard("Crop", crop, Icons.eco),
                  buildInfoCard("Disease", disease, Icons.bug_report),
                  buildInfoCard("Confidence", "$confidence%", Icons.analytics),
                  buildInfoCard("Solution", solution, Icons.healing),
                ],
              ),
            ),
    );
  }
}
