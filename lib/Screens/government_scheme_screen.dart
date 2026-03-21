import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
      "link": "https://pmkisan.gov.in/"
    },
    {
      "name": "Soil Health Card",
      "desc":
          "Provides soil nutrient status and recommendations for fertilizers.",
      "state": "All",
      "link": "https://soilhealth.dac.gov.in/"
    },
    {
      "name": "UP Krishi Yojana",
      "desc":
          "Subsidy for seeds and irrigation support for farmers in Uttar Pradesh.",
      "state": "Uttar Pradesh",
      "link": "http://upagriculture.com/"
    },
    {
      "name": "Punjab Crop Insurance",
      "desc": "Insurance scheme to protect farmers against crop loss.",
      "state": "Punjab",
      "link": "https://pmfby.gov.in/"
    },
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open link.")));
      }
    }
  }

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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _launchURL(scheme["link"]!),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TranslatedText(
                                  text: scheme["name"]!,
                                  langCode: lang,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.open_in_new, color: Colors.blueGrey, size: 20),
                            ],
                          ),
                          const SizedBox(height: 6),
                          /// 📄 DESCRIPTION
                          TranslatedText(
                            text: scheme["desc"]!,
                            langCode: lang,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scheme["link"]!,
                            style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 13),
                          ),
                        ],
                      ),
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
