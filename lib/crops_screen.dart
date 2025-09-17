import 'package:flutter/material.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  final List<Map<String, dynamic>> crops = const [
    {
      "name": "Wheat",
      "image": "https://upload.wikimedia.org/wikipedia/commons/6/68/Wheat_close-up.JPG",
      "desc": "Wheat is a staple crop grown in many regions for flour and bread.",
      "season": "Rabi (Winter)",
      "soil": "Well-drained loamy or clay soil",
      "irrigation": "Requires 3-4 irrigations",
      "uses": "Used to make flour, bread, pasta, and bakery products"
    },
    {
      "name": "Rice",
      "image": "https://upload.wikimedia.org/wikipedia/commons/6/6f/Rice_plants_%28IRRI%29.jpg",
      "desc": "Rice is the primary food source for over half the world’s population.",
      "season": "Kharif (Monsoon)",
      "soil": "Clayey soil with good water retention",
      "irrigation": "Requires standing water (flood irrigation)",
      "uses": "Staple food, used for rice, flour, starch, and brewing"
    },
    {
      "name": "Maize",
      "image": "https://upload.wikimedia.org/wikipedia/commons/5/59/Maize_plants.jpg",
      "desc": "Maize (corn) is used for food, fodder, and industrial products.",
      "season": "Kharif & Rabi",
      "soil": "Well-drained alluvial soil",
      "irrigation": "Requires irrigation at critical stages (flowering & grain filling)",
      "uses": "Consumed as food, animal feed, and biofuel production"
    },
    {
      "name": "Sugarcane",
      "image": "https://upload.wikimedia.org/wikipedia/commons/3/36/Sugarcane_field.jpg",
      "desc": "Sugarcane is mainly used to produce sugar and ethanol.",
      "season": "Annual crop",
      "soil": "Fertile alluvial soil with good drainage",
      "irrigation": "Requires frequent irrigation (every 10-15 days)",
      "uses": "Used for sugar, jaggery, ethanol, and paper industry"
    },
    {
      "name": "Cotton",
      "image": "https://upload.wikimedia.org/wikipedia/commons/f/fd/CottonPlant.JPG",
      "desc": "Cotton is an important fiber crop used in the textile industry.",
      "season": "Kharif (Summer sowing, harvested in Winter)",
      "soil": "Black cotton soil (regur soil)",
      "irrigation": "Moderate irrigation required, sensitive to excess water",
      "uses": "Used in textile industry, oil extraction from seeds"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crops Information"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: crops.length,
        itemBuilder: (context, index) {
          final crop = crops[index];
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: ListTile(
              leading: Image.network(
                crop["image"],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                crop["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(crop["desc"]),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropDetailScreen(crop: crop), // 👈 Pass crop here
                    ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Crop Detail Screen with Extended Info
class CropDetailScreen extends StatelessWidget {
  final Map<String, dynamic> crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop["name"]),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  crop["image"],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                crop["name"],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(crop["desc"], style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 20),
              _buildDetail("🌱 Season", crop["season"]),
              _buildDetail("🌍 Soil Type", crop["soil"]),
              _buildDetail("💧 Irrigation", crop["irrigation"]),
              _buildDetail("📌 Uses", crop["uses"]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
