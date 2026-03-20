import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final List<String> crops = ["Wheat", "Rice", "Potato", "Tomato"];

  @override
  void initState() {
    super.initState();

    Future.microtask(() => Provider.of<AppProvider>(context, listen: false)
        .loadCropPrices("Wheat"));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Mandi Prices")),
      body: Column(
        children: [
          // 🔥 DROPDOWN
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: provider.selectedCrop,
              decoration: InputDecoration(
                labelText: "Select Crop",
                border: OutlineInputBorder(),
              ),
              items: crops.map((crop) {
                return DropdownMenuItem(
                  value: crop,
                  child: Text(crop),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.loadCropPrices(value);
                }
              },
            ),
          ),

          // 🔄 LOADING
          if (provider.isLoadingPrices)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: provider.cropPrices.length,
                itemBuilder: (context, index) {
                  final item = provider.cropPrices[index];

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(Icons.agriculture, color: Colors.green),
                      title: Text(item.market),
                      subtitle: Text("₹${item.minPrice} - ₹${item.maxPrice}"),
                      trailing: Text(
                        "₹${item.modalPrice}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
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
