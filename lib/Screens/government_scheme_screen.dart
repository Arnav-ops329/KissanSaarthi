import 'package:flutter/material.dart';
import '../widgets/translated_text.dart';

class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() =>
      _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen> {
  String selectedState = "All";

  final List<String> states = [
    "All",
    "Uttar Pradesh",
    "Punjab",
    "Maharashtra",
    "Bihar",
    "Haryana",
  ];

  final List<Map<String, String>> schemes = [
    {
      "name": "PM-KISAN",
      "desc":
          "Farmers receive ₹6000 per year in 3 installments directly in bank account.",
      "state": "All",
    },
    {
      "name": "Soil Health Card",
      "desc":
          "Provides soil nutrient status and recommendations for fertilizers.",
      "state": "All",
    },
    {
      "name": "UP Krishi Yojana",
      "desc":
          "Subsidy for seeds and irrigation support for farmers in Uttar Pradesh.",
      "state": "Uttar Pradesh",
    },
    {
      "name": "Punjab Crop Insurance",
      "desc": "Insurance scheme to protect farmers against crop loss.",
      "state": "Punjab",
    },
  ];

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;

    final filteredSchemes = schemes.where((scheme) {
      return selectedState == "All" || scheme["state"] == selectedState;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Government Schemes"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          /// 🌍 STATE FILTER
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField(
              initialValue: selectedState,
              items: states
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedState = val!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Select State",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          /// 📜 LIST
          Expanded(
            child: ListView.builder(
              itemCount: filteredSchemes.length,
              itemBuilder: (context, index) {
                final scheme = filteredSchemes[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🌾 NAME
                        TranslatedText(
                          text: scheme["name"]!,
                          langCode: lang,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// 📄 DESCRIPTION
                        TranslatedText(
                          text: scheme["desc"]!,
                          langCode: lang,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
