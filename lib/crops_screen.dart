import 'package:flutter/material.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> crops = const [
    {
      "name": "Wheat",
      "image": "https://images.unsplash.com/photo-1600411833293-6f1a02f5ad46",
      "localImage": "assets/images/wheat.jpg",
      "desc": "Wheat is a staple crop grown in many regions for flour and bread.",
      "season": "Rabi (Winter)",
      "soil": "Well-drained loamy or clay soil",
      "irrigation": "Requires 3-4 irrigations",
      "uses": "Used to make flour, bread, pasta, and bakery products",
      "useNetworkImage": false,
      "category": "Cereal",
      "growthPeriod": "120-150 days",
      "temperature": "15-25°C",
      "rainfall": "300-1000mm",
      "difficulty": "Medium",
      "yield": "25-30 quintals/hectare"
    },
    {
      "name": "Rice",
      "image": "https://upload.wikimedia.org/wikipedia/commons/6/6f/Rice_plants_%28IRRI%29.jpg",
      "localImage": "assets/images/rice.jpg",
      "desc": "Rice is the primary food source for over half the world's population.",
      "season": "Kharif (Monsoon)",
      "soil": "Clayey soil with good water retention",
      "irrigation": "Requires standing water (flood irrigation)",
      "uses": "Staple food, used for rice, flour, starch, and brewing",
      "useNetworkImage": false,
      "category": "Cereal",
      "growthPeriod": "95-120 days",
      "temperature": "20-37°C",
      "rainfall": "1000-2000mm",
      "difficulty": "Easy",
      "yield": "20-25 quintals/hectare"
    },
    {
      "name": "Maize",
      "image": "https://upload.wikimedia.org/wikipedia/commons/5/59/Maize_plants.jpg",
      "localImage": "assets/images/maize.jpg",
      "desc": "Maize (corn) is used for food, fodder, and industrial products.",
      "season": "Kharif & Rabi",
      "soil": "Well-drained alluvial soil",
      "irrigation": "Requires irrigation at critical stages (flowering & grain filling)",
      "uses": "Consumed as food, animal feed, and biofuel production",
      "useNetworkImage": false,
      "category": "Cereal",
      "growthPeriod": "80-120 days",
      "temperature": "21-27°C",
      "rainfall": "500-750mm",
      "difficulty": "Easy",
      "yield": "30-40 quintals/hectare"
    },
    {
      "name": "Sugarcane",
      "image": "https://upload.wikimedia.org/wikipedia/commons/3/36/Sugarcane_field.jpg",
      "localImage": "assets/images/sugarcane.jpg",
      "desc": "Sugarcane is mainly used to produce sugar and ethanol.",
      "season": "Annual crop",
      "soil": "Fertile alluvial soil with good drainage",
      "irrigation": "Requires frequent irrigation (every 10-15 days)",
      "uses": "Used for sugar, jaggery, ethanol, and paper industry",
      "useNetworkImage": false,
      "category": "Cash Crop",
      "growthPeriod": "10-18 months",
      "temperature": "26-32°C",
      "rainfall": "1000-1500mm",
      "difficulty": "Hard",
      "yield": "600-800 quintals/hectare"
    },
    {
      "name": "Cotton",
      "image": "https://upload.wikimedia.org/wikipedia/commons/f/fd/CottonPlant.JPG",
      "localImage": "assets/images/cotton.jpg",
      "desc": "Cotton is an important fiber crop used in the textile industry.",
      "season": "Kharif (Summer sowing, harvested in Winter)",
      "soil": "Black cotton soil (regur soil)",
      "irrigation": "Moderate irrigation required, sensitive to excess water",
      "uses": "Used in textile industry, oil extraction from seeds",
      "useNetworkImage": false,
      "category": "Fiber Crop",
      "growthPeriod": "160-200 days",
      "temperature": "21-30°C",
      "rainfall": "500-1000mm",
      "difficulty": "Hard",
      "yield": "15-20 quintals/hectare"
    },
    {
      "name": "Tomato",
      "image": "https://images.unsplash.com/photo-1546470427-e9c834b3b3c2",
      "localImage": "assets/images/tomato.jpg",
      "desc": "Tomato is a versatile vegetable crop rich in vitamins and antioxidants.",
      "season": "Kharif & Rabi",
      "soil": "Well-drained sandy loam soil",
      "irrigation": "Regular watering, avoid waterlogging",
      "uses": "Fresh consumption, processing, sauces, and cooking",
      "useNetworkImage": false,
      "category": "Vegetable",
      "growthPeriod": "70-90 days",
      "temperature": "18-27°C",
      "rainfall": "500-750mm",
      "difficulty": "Medium",
      "yield": "200-400 quintals/hectare"
    },
    {
      "name": "Potato",
      "image": "https://images.unsplash.com/photo-1518977676601-b53f82aba655",
      "localImage": "assets/images/potato.jpg",
      "desc": "Potato is a starchy tuber crop and major food source worldwide.",
      "season": "Rabi (Winter)",
      "soil": "Well-drained sandy loam with good organic matter",
      "irrigation": "Moderate irrigation, avoid excess moisture",
      "uses": "Food, starch production, processing industry",
      "useNetworkImage": false,
      "category": "Vegetable",
      "growthPeriod": "90-120 days",
      "temperature": "15-25°C",
      "rainfall": "500-700mm",
      "difficulty": "Easy",
      "yield": "150-300 quintals/hectare"
    },
    {
      "name": "Onion",
      "image": "https://images.unsplash.com/photo-1508313880080-c4fff66dd4ca",
      "localImage": "assets/images/onion.jpg",
      "desc": "Onion is an essential vegetable crop used in cooking worldwide.",
      "season": "Rabi (Winter)",
      "soil": "Well-drained fertile soil with pH 6.0-7.0",
      "irrigation": "Regular light irrigation",
      "uses": "Cooking, food processing, medicinal purposes",
      "useNetworkImage": false,
      "category": "Vegetable",
      "growthPeriod": "120-150 days",
      "temperature": "13-24°C",
      "rainfall": "650-750mm",
      "difficulty": "Medium",
      "yield": "200-500 quintals/hectare"
    },
    {
      "name": "Soybean",
      "image": "https://images.unsplash.com/photo-1583736564085-7d8d38e07faf",
      "localImage": "assets/images/soybean.jpg",
      "desc": "Soybean is a protein-rich legume crop used for oil and food products.",
      "season": "Kharif (Monsoon)",
      "soil": "Well-drained clay loam soil",
      "irrigation": "Rain-fed, supplementary irrigation if needed",
      "uses": "Oil extraction, protein meal, food products",
      "useNetworkImage": false,
      "category": "Legume",
      "growthPeriod": "90-150 days",
      "temperature": "26-30°C",
      "rainfall": "500-800mm",
      "difficulty": "Easy",
      "yield": "10-15 quintals/hectare"
    },
    {
      "name": "Groundnut",
      "image": "https://images.unsplash.com/photo-1610222908046-8c86fd22da79",
      "localImage": "assets/images/groundnut.jpg",
      "desc": "Groundnut is an important oilseed crop also known as peanut.",
      "season": "Kharif & Rabi",
      "soil": "Well-drained sandy loam soil",
      "irrigation": "Light irrigation at pod formation stage",
      "uses": "Oil extraction, direct consumption, confectionery",
      "useNetworkImage": false,
      "category": "Oilseed",
      "growthPeriod": "100-130 days",
      "temperature": "20-30°C",
      "rainfall": "500-1250mm",
      "difficulty": "Medium",
      "yield": "15-25 quintals/hectare"
    },
  ];

  List<Map<String, dynamic>> get filteredCrops {
    return crops.where((crop) {
      final matchesSearch = crop['name'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          crop['desc'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || crop['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get categories {
    final cats = crops.map((crop) => crop['category'].toString()).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crops Information", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          _buildStatsCard(),
          Expanded(
            child: filteredCrops.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredCrops.length,
                    itemBuilder: (context, index) {
                      final crop = filteredCrops[index];
                      return _buildCropCard(context, crop, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCropDialog(),
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.green.shade100,
              checkmarkColor: Colors.green.shade700,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Total Crops", "${crops.length}", Icons.eco),
          _buildStatItem("Categories", "${categories.length - 1}", Icons.category),
          _buildStatItem("Filtered", "${filteredCrops.length}", Icons.filter_list),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildCropCard(BuildContext context, Map<String, dynamic> crop, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Hero(
            tag: 'crop_${crop["name"]}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(
                crop["useNetworkImage"] ? crop["image"] : crop["localImage"],
                crop["useNetworkImage"],
                width: 70,
                height: 70,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  crop["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildDifficultyChip(crop["difficulty"]),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                crop["desc"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildInfoChip(crop["category"], Icons.category, Colors.blue),
                  _buildInfoChip(crop["season"], Icons.wb_sunny, Colors.orange),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                    CropDetailScreen(crop: crop),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = Colors.green;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'hard':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No crops found",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search or filter",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Search Crops"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Enter crop name or description...",
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                searchQuery = '';
              });
              Navigator.pop(context);
            },
            child: const Text("Clear"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  void _showAddCropDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Crop"),
        content: const Text("Feature coming soon! You'll be able to add custom crops to your list."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath, bool isNetworkImage, {double? width, double? height}) {
    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Network image error: $error');
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_not_supported, color: Colors.grey, size: 30),
                if (width != null && width > 100) 
                  const Text('Image failed', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Asset image error: $error');
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder_open, color: Colors.grey, size: 30),
                if (width != null && width > 100)
                  const Text('Asset not found', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        },
      );
    }
  }
}

/// Enhanced Crop Detail Screen
class CropDetailScreen extends StatelessWidget {
  final Map<String, dynamic> crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.green.shade700,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                crop["name"],
                style: const TextStyle(fontWeight: FontWeight.bold, shadows: [
                  Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black45)
                ]),
              ),
              background: Hero(
                tag: 'crop_${crop["name"]}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(
                      crop["useNetworkImage"] ? crop["image"] : crop["localImage"],
                      crop["useNetworkImage"] ?? true,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDescriptionCard(),
                const SizedBox(height: 16),
                _buildQuickInfoGrid(),
                const SizedBox(height: 16),
                _buildDetailedInfoCard(),
                const SizedBox(height: 16),
                _buildGrowingTipsCard(),
                const SizedBox(height: 100), // Space for FAB
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMoreActions(context),
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.more_horiz),
        label: const Text("More Actions"),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              crop["desc"],
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildQuickInfoCard("Category", crop["category"], Icons.category, Colors.blue),
        _buildQuickInfoCard("Difficulty", crop["difficulty"], Icons.trending_up, _getDifficultyColor(crop["difficulty"])),
        _buildQuickInfoCard("Growth Period", crop["growthPeriod"], Icons.schedule, Colors.purple),
        _buildQuickInfoCard("Expected Yield", crop["yield"], Icons.assessment, Colors.green),
      ],
    );
  }

  // FIXED VERSION - This resolves the overflow issue
  Widget _buildQuickInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced padding from 16 to 12
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Added this line
          children: [
            Icon(icon, color: color, size: 24), // Reduced size from 28 to 24
            const SizedBox(height: 6), // Reduced from 8 to 6
            Flexible( // Wrapped in Flexible
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11, // Reduced from 12 to 11
                  color: Colors.grey.shade600, 
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Added max lines
                overflow: TextOverflow.ellipsis, // Added overflow handling
              ),
            ),
            const SizedBox(height: 2), // Reduced from 4 to 2
            Flexible( // Wrapped in Flexible
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12, // Reduced from 14 to 12
                  fontWeight: FontWeight.bold, 
                  color: color
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Added max lines
                overflow: TextOverflow.ellipsis, // Added overflow handling
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.agriculture, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text("Growing Conditions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow("🌱 Season", crop["season"]),
            _buildDetailRow("🌍 Soil Type", crop["soil"]),
            _buildDetailRow("💧 Irrigation", crop["irrigation"]),
            _buildDetailRow("🌡️ Temperature", crop["temperature"]),
            _buildDetailRow("🌧️ Rainfall", crop["rainfall"]),
            _buildDetailRow("📌 Uses", crop["uses"]),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowingTipsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                const Text("Growing Tips", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem("🌱", "Plant during optimal season for best results"),
            _buildTipItem("💧", "Monitor soil moisture regularly"),
            _buildTipItem("🌿", "Use organic fertilizers for better yield"),
            _buildTipItem("🐛", "Regular pest monitoring is essential"),
            _buildTipItem("📊", "Track growth stages for timely interventions"),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text("Add to Favorites"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${crop['name']} added to favorites!")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share Crop Info"),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Set Planting Reminder"),
              onTap: () {
                Navigator.pop(context);
                // Implement reminder functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath, bool isNetworkImage, {double? width, double? height}) {
    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: width ?? double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? double.infinity,
            height: height ?? 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                SizedBox(height: 8),
                Text("Network image failed to load", 
                     style: TextStyle(color: Colors.grey),
                     textAlign: TextAlign.center),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width ?? double.infinity,
            height: height ?? 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        width: width ?? double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? double.infinity,
            height: height ?? 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, color: Colors.grey, size: 50),
                SizedBox(height: 8),
                Text("Asset image not found", 
                     style: TextStyle(color: Colors.grey),
                     textAlign: TextAlign.center),
              ],
            ),
          );
        },
      );
    }
  }
}