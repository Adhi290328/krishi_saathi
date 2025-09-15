import 'package:flutter/material.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> crops = ["Wheat", "Rice", "Maize", "Sugarcane", "Cotton"];

    return Scaffold(
      appBar: AppBar(title: const Text("Crops")),
      body: ListView.builder(
        itemCount: crops.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.agriculture, color: Colors.green),
            title: Text(crops[index]),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              // Navigate to crop details page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CropDetailScreen(cropName: crops[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CropDetailScreen extends StatelessWidget {
  final String cropName;

  const CropDetailScreen({super.key, required this.cropName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cropName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Here is some information about $cropName.\n\n"
          "🌱 Ideal season: TBD\n"
          "💧 Water requirement: TBD\n"
          "🌡️ Temperature range: TBD\n",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
