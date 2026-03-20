import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/app_provider.dart';
import '../providers/voice_flow_provider.dart';
import '../Widgets/global_voice_button.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final List<String> crops = ["Wheat", "Rice", "Potato", "Tomato", "Cotton"];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<AppProvider>(context, listen: false).loadCropPrices("Wheat");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final voiceFlow = Provider.of<VoiceFlowProvider>(context);

    // Automation: Sync with Voice Assistant
    if (voiceFlow.activeFlow == VoiceFlow.mandiPrice &&
        voiceFlow.data.containsKey('crop')) {
      final voiceCrop = voiceFlow.data['crop']!;
      if (provider.selectedCrop != voiceCrop && !provider.isLoadingPrices) {
        Future.microtask(() => provider.loadCropPrices(voiceCrop));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mandi Prices"),
        backgroundColor: Colors.orange,
        actions: [
          if (voiceFlow.activeFlow == VoiceFlow.mandiPrice)
            IconButton(
                onPressed: () => voiceFlow.stopFlow(),
                icon: const Icon(Icons.stop_circle, color: Colors.white)),
          IconButton(
            icon: Icon(
              provider.isDescendingOrder ? Icons.sort_by_alpha : Icons.filter_list_alt,
              color: Colors.white,
            ),
            onPressed: () => provider.toggleSortOrder(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCropDropdown(provider),
          if (provider.userCity.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Text("Prices in ${provider.userCity}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          if (provider.isLoadingPrices)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: provider.cropPrices.length,
                itemBuilder: (context, index) {
                  final item = provider.cropPrices[index];
                  double? distanceKm;
                  if (provider.lat != null && provider.lon != null && item.latitude != null && item.longitude != null) {
                    distanceKm = Geolocator.distanceBetween(provider.lat!, provider.lon!, item.latitude!, item.longitude!) / 1000;
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.agriculture, color: Colors.white)),
                      title: Text(item.market),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("₹${item.minPrice} - ₹${item.maxPrice}"),
                          if (distanceKm != null)
                            Text("${distanceKm.toStringAsFixed(1)} km away", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: Text("₹${item.modalPrice}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: const GlobalVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCropDropdown(AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        initialValue: provider.selectedCrop,
        decoration: const InputDecoration(labelText: "Select Crop", border: OutlineInputBorder()),
        items: crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (val) {
          if (val != null) provider.loadCropPrices(val);
        },
      ),
    );
  }
}
