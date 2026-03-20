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
      margin: EdgeInsets.symmetric(vertical: 8),
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
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 🌾 Crop
                  buildInfoCard("Crop", crop, Icons.eco),

                  /// 🦠 Disease
                  buildInfoCard("Disease", disease, Icons.bug_report),

                  /// 📊 Confidence
                  buildInfoCard("Confidence", "$confidence%", Icons.analytics),

                  /// 💊 Solution
                  buildInfoCard("Solution", solution, Icons.healing),

                  SizedBox(height: 20),

                  /// 🌱 Fertilizer Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/fertilizer',
                        arguments: crop,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                    ),
                    child: Text("Get Fertilizer Advice"),
                  ),

                  SizedBox(height: 10),

                  /// 💰 Mandi Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/market');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.orange,
                    ),
                    child: Text("Check Market Prices"),
                  ),
                ],
              ),
            ),
    );
  }
}
