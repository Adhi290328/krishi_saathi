import 'package:flutter/material.dart';
// Irrigation Timer Screen
class IrrigationTimerScreen extends StatefulWidget {
  const IrrigationTimerScreen({super.key});

  @override
  State<IrrigationTimerScreen> createState() => _IrrigationTimerScreenState();
}

class _IrrigationTimerScreenState extends State<IrrigationTimerScreen> {
  List<Map<String, dynamic>> irrigationSchedule = [
    {'time': '06:00 AM', 'duration': '30 min', 'zone': 'Field A', 'active': true},
    {'time': '06:30 AM', 'duration': '45 min', 'zone': 'Field B', 'active': true},
    {'time': '07:15 AM', 'duration': '25 min', 'zone': 'Greenhouse', 'active': false},
    {'time': '05:30 PM', 'duration': '40 min', 'zone': 'Field A', 'active': true},
    {'time': '06:10 PM', 'duration': '35 min', 'zone': 'Field B', 'active': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Irrigation Timer"),
        backgroundColor: Colors.cyan.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _addNewSchedule,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Water Status Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan.shade400, Colors.cyan.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.water_drop, color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    "Today's Irrigation",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWaterStat("Total", "2.5 hrs", Icons.schedule),
                      _buildWaterStat("Active", "3 zones", Icons.agriculture),
                      _buildWaterStat("Water", "1200 L", Icons.water),
                    ],
                  ),
                ],
              ),
            ),

            // Irrigation Schedule
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Irrigation Schedule",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: irrigationSchedule.length,
                    itemBuilder: (context, index) {
                      final schedule = irrigationSchedule[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: schedule['active'] 
                                ? Colors.green.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.water,
                              color: schedule['active'] ? Colors.green : Colors.grey,
                            ),
                          ),
                          title: Text(
                            "${schedule['time']} - ${schedule['zone']}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text("Duration: ${schedule['duration']}"),
                          trailing: Switch(
                            value: schedule['active'] as bool,
                            onChanged: (value) {
                              setState(() {
                                irrigationSchedule[index]['active'] = value;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Smart Recommendations
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.smart_toy, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        "Smart Recommendations",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Temperature rising - increase evening irrigation"),
                  const Text("Rain expected tomorrow - skip morning watering"),
                  const Text("Soil moisture at 40% - maintain current schedule"),
                  const Text("Consider drip irrigation for water efficiency"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  void _addNewSchedule() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Schedule"),
          content: const Text("New irrigation schedule functionality would be implemented here with time picker and zone selection."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Schedule added successfully!")),
                );
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

// Fertilizer Guide Screen
class FertilizerGuideScreen extends StatefulWidget {
  const FertilizerGuideScreen({super.key});

  @override
  State<FertilizerGuideScreen> createState() => _FertilizerGuideScreenState();
}

class _FertilizerGuideScreenState extends State<FertilizerGuideScreen> {
  String selectedCrop = 'Rice';
  final List<String> crops = ['Rice', 'Wheat', 'Maize', 'Cotton', 'Sugarcane'];

  final Map<String, Map<String, dynamic>> fertilizerGuide = {
    'Rice': {
      'nitrogen': '120 kg/ha',
      'phosphorus': '60 kg/ha',
      'potassium': '40 kg/ha',
      'schedule': [
        'Basal: 50% N, 100% P, 100% K at transplanting',
        'Tillering: 25% N at 20-25 days',
        'Panicle: 25% N at 40-45 days',
      ],
      'fertilizers': ['Urea', 'DAP', 'MOP', 'Complex fertilizers'],
    },
    'Wheat': {
      'nitrogen': '100 kg/ha',
      'phosphorus': '50 kg/ha',
      'potassium': '30 kg/ha',
      'schedule': [
        'Basal: 50% N, 100% P, 100% K at sowing',
        'Crown root: 25% N at 20-25 days',
        'Stem elongation: 25% N at 40-50 days',
      ],
      'fertilizers': ['Urea', 'DAP', 'MOP', 'NPK 12:32:16'],
    },
    'Maize': {
      'nitrogen': '80 kg/ha',
      'phosphorus': '40 kg/ha',
      'potassium': '40 kg/ha',
      'schedule': [
        'Basal: 25% N, 100% P, 50% K at sowing',
        'Knee high: 50% N, 50% K at 30-35 days',
        'Tasseling: 25% N at 50-55 days',
      ],
      'fertilizers': ['Urea', 'SSP', 'MOP', 'NPK 10:26:26'],
    },
  };

  @override
  Widget build(BuildContext context) {
    final guide = fertilizerGuide[selectedCrop] ?? fertilizerGuide['Rice']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fertilizer Guide"),
        backgroundColor: Colors.lightGreen.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Selection
            const Text(
              "Select Crop",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCrop,
                  items: crops.map((String crop) {
                    return DropdownMenuItem<String>(
                      value: crop,
                      child: Text(crop),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCrop = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Nutrient Requirements
            const Text(
              "Nutrient Requirements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildNutrientCard('Nitrogen (N)', guide['nitrogen'], Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutrientCard('Phosphorus (P)', guide['phosphorus'], Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutrientCard('Potassium (K)', guide['potassium'], Colors.purple),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Application Schedule
            const Text(
              "Application Schedule",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...guide['schedule'].map<Widget>((schedule) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.green.shade600),
                    const SizedBox(width: 12),
                    Expanded(child: Text(schedule)),
                  ],
                ),
              ),
            )).toList(),

            const SizedBox(height: 24),

            // Recommended Fertilizers
            const Text(
              "Recommended Fertilizers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: guide['fertilizers'].map<Widget>((fertilizer) => Chip(
                label: Text(fertilizer),
                backgroundColor: Colors.lightGreen.shade100,
              )).toList(),
            ),

            const SizedBox(height: 24),

            // Fertilizer Calculator
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fertilizer Calculator",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Farm Area (hectares)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Calculate fertilizer requirements
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Fertilizer Requirements"),
                            content: const Text("For 1 hectare of Rice:\n\n• Urea: 260 kg\n• DAP: 130 kg\n• MOP: 65 kg\n\nTotal cost: ₹15,600"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen.shade600,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Calculate"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tips and Warnings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.amber.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        "Important Tips",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("• Apply fertilizers during cool hours"),
                  const Text("• Ensure adequate soil moisture before application"),
                  const Text("• Don't apply during windy conditions"),
                  const Text("• Store fertilizers in dry, cool place"),
                  const Text("• Follow safety guidelines while handling"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(String nutrient, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.eco, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            nutrient,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Farm Records Screen
class FarmRecordsScreen extends StatefulWidget {
  const FarmRecordsScreen({super.key});

  @override
  State<FarmRecordsScreen> createState() => _FarmRecordsScreenState();
}

class _FarmRecordsScreenState extends State<FarmRecordsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> expenses = [
    {'date': '2024-01-15', 'category': 'Seeds', 'amount': 5000, 'description': 'Rice seeds - 50kg'},
    {'date': '2024-01-20', 'category': 'Fertilizer', 'amount': 8000, 'description': 'Urea and DAP'},
    {'date': '2024-01-25', 'category': 'Labor', 'amount': 3000, 'description': 'Land preparation'},
    {'date': '2024-02-01', 'category': 'Pesticide', 'amount': 2500, 'description': 'Insecticide spray'},
    {'date': '2024-02-10', 'category': 'Equipment', 'amount': 1500, 'description': 'Sprayer maintenance'},
  ];

  final List<Map<String, dynamic>> yields = [
    {'date': '2024-03-15', 'crop': 'Rice', 'quantity': 25, 'unit': 'quintals', 'price': 52500},
    {'date': '2024-01-30', 'crop': 'Wheat', 'quantity': 18, 'unit': 'quintals', 'price': 40500},
    {'date': '2023-12-20', 'crop': 'Maize', 'quantity': 22, 'unit': 'quintals', 'price': 40700},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farm Records"),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Expenses"),
            Tab(text: "Yields"),
            Tab(text: "Summary"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExpensesTab(),
          _buildYieldsTab(),
          _buildSummaryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRecord,
        backgroundColor: Colors.indigo.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildExpensesTab() {
    double totalExpenses = expenses.fold(0, (sum, item) => sum + item['amount']);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Expenses Card
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.money_off, color: Colors.red.shade600, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Expenses",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "₹${totalExpenses.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Recent Expenses",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getCategoryColor(expense['category']).withOpacity(0.2),
                    child: Icon(
                      _getCategoryIcon(expense['category']),
                      color: _getCategoryColor(expense['category']),
                    ),
                  ),
                  title: Text(
                    expense['category'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(expense['description']),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${expense['amount']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        expense['date'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYieldsTab() {
    double totalRevenue = yields.fold(0, (sum, item) => sum + item['price'].toDouble());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Revenue Card
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green.shade600, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Revenue",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "₹${totalRevenue.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Harvest Records",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: yields.length,
            itemBuilder: (context, index) {
              final yield = yields[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.agriculture, color: Colors.white),
                  ),
                  title: Text(
                    yield['crop'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("${yield['quantity']} ${yield['unit']}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${yield['price']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        yield['date'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    double totalExpenses = expenses.fold(0, (sum, item) => sum + item['amount']);
    double totalRevenue = yields.fold(0, (sum, item) => sum + item['price'].toDouble());
    double profit = totalRevenue - totalExpenses;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profit/Loss Card
          Card(
            color: profit >= 0 ? Colors.green.shade50 : Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    profit >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: profit >= 0 ? Colors.green.shade600 : Colors.red.shade600,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profit >= 0 ? "Net Profit" : "Net Loss",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "₹${profit.abs().toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: profit >= 0 ? Colors.green.shade600 : Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Financial Overview
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard("Revenue", "₹${totalRevenue.toStringAsFixed(0)}", Colors.green, Icons.account_balance_wallet),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard("Expenses", "₹${totalExpenses.toStringAsFixed(0)}", Colors.red, Icons.money_off),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Expense Breakdown
          const Text(
            "Expense Breakdown",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildExpenseBreakdown("Seeds", 5000, totalExpenses),
                  _buildExpenseBreakdown("Fertilizer", 8000, totalExpenses),
                  _buildExpenseBreakdown("Labor", 3000, totalExpenses),
                  _buildExpenseBreakdown("Pesticide", 2500, totalExpenses),
                  _buildExpenseBreakdown("Equipment", 1500, totalExpenses),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ROI Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Return on Investment (ROI)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${((profit / totalExpenses) * 100).toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: profit >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildExpenseBreakdown(String category, double amount, double total) {
    double percentage = (amount / total) * 100;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(category),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(category)),
            ),
          ),
          const SizedBox(width: 8),
          Text("${percentage.toStringAsFixed(1)}%"),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Seeds':
        return Colors.green;
      case 'Fertilizer':
        return Colors.orange;
      case 'Labor':
        return Colors.blue;
      case 'Pesticide':
        return Colors.red;
      case 'Equipment':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Seeds':
        return Icons.eco;
      case 'Fertilizer':
        return Icons.science;
      case 'Labor':
        return Icons.people;
      case 'Pesticide':
        return Icons.bug_report;
      case 'Equipment':
        return Icons.build;
      default:
        return Icons.category;
    }
  }

  void _addNewRecord() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Record"),
          content: const Text("New record functionality would be implemented here with forms for adding expenses or yield data."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Record added successfully!")),
                );
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

// Remaining screens - Crop Calendar, Pest Control, Government Schemes, Expert Consultation, Notifications, Profile

class CropCalendarScreen extends StatelessWidget {
  const CropCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {'month': 'January', 'activity': 'Wheat harvesting, Land preparation for summer crops', 'color': Colors.blue},
      {'month': 'February', 'activity': 'Sowing of summer crops (Maize, Cotton)', 'color': Colors.green},
      {'month': 'March', 'activity': 'Fertilizer application, Pest monitoring', 'color': Colors.orange},
      {'month': 'April', 'activity': 'Irrigation management, Weed control', 'color': Colors.cyan},
      {'month': 'May', 'activity': 'Summer crop maintenance, Pre-monsoon preparations', 'color': Colors.red},
      {'month': 'June', 'activity': 'Monsoon crop sowing (Rice, Sugarcane)', 'color': Colors.purple},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Calendar"),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: activity['color'],
                child: Text(
                  activity['month'].toString().substring(0, 3),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                activity['month'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(activity['activity']),
            ),
          );
        },
      ),
    );
  }
}

class PestControlScreen extends StatelessWidget {
  const PestControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pests = [
      {'name': 'Aphids', 'crop': 'Multiple crops', 'treatment': 'Neem oil spray, Insecticidal soap'},
      {'name': 'Stem Borer', 'crop': 'Rice', 'treatment': 'Pheromone traps, Bt application'},
      {'name': 'Bollworm', 'crop': 'Cotton', 'treatment': 'Bt cotton varieties, Targeted insecticides'},
      {'name': 'Leaf Miner', 'crop': 'Vegetables', 'treatment': 'Yellow sticky traps, Biological control'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pest Control"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pests.length,
        itemBuilder: (context, index) {
          final pest = pests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.red),
              title: Text(
                pest['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Affects: ${pest['crop']}"),
                  Text("Treatment: ${pest['treatment']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GovernmentSchemesScreen extends StatelessWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> schemes = [
      {'name': 'PM-KISAN', 'benefit': '₹6,000 per year', 'eligibility': 'All farmer families'},
      {'name': 'Crop Insurance', 'benefit': 'Premium subsidy up to 90%', 'eligibility': 'All farmers'},
      {'name': 'Soil Health Card', 'benefit': 'Free soil testing', 'eligibility': 'All farmers'},
      {'name': 'Kisan Credit Card', 'benefit': 'Easy agricultural loans', 'eligibility': 'Farmers with land records'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Government Schemes"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.blue),
              title: Text(
                scheme['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Benefit: ${scheme['benefit']}"),
                  Text("Eligibility: ${scheme['eligibility']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExpertConsultationScreen extends StatelessWidget {
  const ExpertConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> experts = [
      {'name': 'Dr. Rajesh Kumar', 'specialty': 'Crop Diseases', 'rating': 4.8, 'available': true},
      {'name': 'Dr. Priya Sharma', 'specialty': 'Soil Science', 'rating': 4.9, 'available': false},
      {'name': 'Dr. Amit Singh', 'specialty': 'Pest Management', 'rating': 4.7, 'available': true},
      {'name': 'Dr. Sunita Patel', 'specialty': 'Organic Farming', 'rating': 4.6, 'available': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expert Consultation"),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: experts.length,
        itemBuilder: (context, index) {
          final expert = experts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                expert['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Specialty: ${expert['specialty']}"),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(" ${expert['rating']}"),
                    ],
                  ),
                ],
              ),
              trailing: expert['available']
                ? const Chip(
                    label: Text("Available"),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  )
                : const Chip(
                    label: Text("Busy"),
                    backgroundColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {'title': 'Weather Alert', 'message': 'Heavy rain expected tomorrow', 'time': '2 hours ago', 'icon': Icons.cloud},
      {'title': 'Market Update', 'message': 'Rice prices increased by 5%', 'time': '5 hours ago', 'icon': Icons.trending_up},
      {'title': 'Irrigation Reminder', 'message': 'Schedule irrigation for Field A', 'time': '1 day ago', 'icon': Icons.water_drop},
      {'title': 'New Scheme', 'message': 'PM-KISAN payment released', 'time': '2 days ago', 'icon': Icons.account_balance},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(notification['icon'], color: Colors.green),
              title: Text(
                notification['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notification['message']),
              trailing: Text(
                notification['time'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Ramesh Kumar",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text("Farmer ID: KS001234"),
                    const SizedBox(height: 8),
                    const Text("📍 Village: Rampur, District: Meerut"),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileStat("Farm Size", "5 acres"),
                        _buildProfileStat("Experience", "15 years"),
                        _buildProfileStat("Crops", "3 types"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Menu
            _buildMenuTile("Personal Information", Icons.person, () {}),
            _buildMenuTile("Farm Details", Icons.agriculture, () {}),
            _buildMenuTile("Language Settings", Icons.language, () {}),
            _buildMenuTile("Notifications", Icons.notifications, () {}),
            _buildMenuTile("Help & Support", Icons.help, () {}),
            _buildMenuTile("About App", Icons.info, () {}),
            
            const SizedBox(height: 20),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Implement logout logic
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}// main.dart


void main() {
  runApp(const KrishiSaathiApp());
}

class KrishiSaathiApp extends StatelessWidget {
  const KrishiSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishi Saathi',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Plant Disease Detection Screen
class PlantDiseaseScreen extends StatefulWidget {
  const PlantDiseaseScreen({super.key});

  @override
  State<PlantDiseaseScreen> createState() => _PlantDiseaseScreenState();
}

class _PlantDiseaseScreenState extends State<PlantDiseaseScreen> {
  final List<Map<String, dynamic>> diseases = [
    {
      'name': 'Leaf Blight',
      'crop': 'Rice',
      'symptoms': 'Brown spots with yellow halos on leaves',
      'treatment': 'Apply copper-based fungicide, Remove affected leaves',
      'prevention': 'Avoid overhead watering, Improve air circulation',
    },
    {
      'name': 'Powdery Mildew',
      'crop': 'Wheat',
      'symptoms': 'White powdery coating on leaves and stems',
      'treatment': 'Spray sulfur-based fungicide, Remove infected parts',
      'prevention': 'Plant resistant varieties, Avoid overcrowding',
    },
    {
      'name': 'Bollworm',
      'crop': 'Cotton',
      'symptoms': 'Holes in bolls, Caterpillars inside bolls',
      'treatment': 'Use Bt cotton varieties, Apply appropriate insecticide',
      'prevention': 'Monitor regularly, Use pheromone traps',
    },
    {
      'name': 'Late Blight',
      'crop': 'Potato',
      'symptoms': 'Dark brown spots on leaves, White mold underneath',
      'treatment': 'Apply copper fungicide, Remove affected plants',
      'prevention': 'Ensure good drainage, Rotate crops',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Disease Detection"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _takePhoto,
            icon: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Upload Section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.camera_alt, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    "Take a photo of affected plant",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "AI will analyze and identify the disease",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Take Photo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Common Diseases List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Common Plant Diseases",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: diseases.length,
                    itemBuilder: (context, index) {
                      final disease = diseases[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ExpansionTile(
                          leading: const Icon(Icons.local_hospital, color: Colors.red),
                          title: Text(
                            disease['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Affects: ${disease['crop']}"),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDiseaseInfo("Symptoms", disease['symptoms']),
                                  _buildDiseaseInfo("Treatment", disease['treatment']),
                                  _buildDiseaseInfo("Prevention", disease['prevention']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Prevention Tips
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tips_and_updates, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        "Prevention Tips",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Use disease-resistant crop varieties"),
                  const Text("Maintain proper irrigation and drainage"),
                  const Text("Practice crop rotation"),
                  const Text("Keep fields clean of crop debris"),
                  const Text("Regular monitoring and early detection"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _takePhoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("AI Disease Detection"),
          content: const Text(
            "Camera functionality would be integrated here. The AI would analyze the plant image and provide:\n\n"
            "• Disease identification\n"
            "• Severity assessment\n"
            "• Treatment recommendations\n"
            "• Prevention measures"
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

// Market Prices Screen
class MarketPricesScreen extends StatelessWidget {
  const MarketPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> marketPrices = [
      {'crop': 'Rice (Paddy)', 'price': '₹2,100', 'change': '+50', 'trend': 'up'},
      {'crop': 'Wheat', 'price': '₹2,250', 'change': '-25', 'trend': 'down'},
      {'crop': 'Maize', 'price': '₹1,850', 'change': '+75', 'trend': 'up'},
      {'crop': 'Cotton', 'price': '₹6,200', 'change': '+100', 'trend': 'up'},
      {'crop': 'Sugarcane', 'price': '₹350', 'change': '0', 'trend': 'stable'},
      {'crop': 'Soybean', 'price': '₹4,500', 'change': '-150', 'trend': 'down'},
      {'crop': 'Onion', 'price': '₹25', 'change': '+5', 'trend': 'up'},
      {'crop': 'Potato', 'price': '₹18', 'change': '-2', 'trend': 'down'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Prices"),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Market Summary
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade400, Colors.purple.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.trending_up, color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    "Today's Market Summary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMarketStat("Rising", "5", Colors.green.shade300),
                      _buildMarketStat("Falling", "2", Colors.red.shade300),
                      _buildMarketStat("Stable", "1", Colors.white70),
                    ],
                  ),
                ],
              ),
            ),

            // Price List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Prices (per quintal)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: marketPrices.length,
                    itemBuilder: (context, index) {
                      final item = marketPrices[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getTrendColor(item['trend'] as String).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getTrendIcon(item['trend'] as String),
                              color: _getTrendColor(item['trend'] as String),
                            ),
                          ),
                          title: Text(
                            item['crop'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "Change: ${item['change']}",
                            style: TextStyle(
                              color: _getTrendColor(item['trend'] as String),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item['price'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item['trend'] as String,
                                style: TextStyle(
                                  color: _getTrendColor(item['trend'] as String),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Market Tips
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        "Market Tips",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Cotton prices showing upward trend - good time to sell"),
                  const Text("Wheat prices declining - consider holding inventory"),
                  const Text("Rice demand expected to increase next month"),
                  const Text("Monitor weather forecasts for price impacts"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 14),
        ),
      ],
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }
}

// home_screen.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Krishi Saathi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationScreen()),
            ),
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            icon: const Icon(Icons.account_circle, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green.shade700, Colors.green.shade500],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🌱 Welcome to Krishi Saathi!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your smart farming companion for better yields",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Quick Stats Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      "Weather",
                      "28°C",
                      Icons.wb_sunny,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      "Humidity",
                      "65%",
                      Icons.water_drop,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      "Soil pH",
                      "6.8",
                      Icons.grass,
                      Colors.brown,
                    ),
                  ),
                ],
              ),
            ),

            // Main Features Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Features",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildFeatureCard(
                        context,
                        "Crop Information",
                        "Detailed crop guides & tips",
                        Icons.agriculture,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CropInformationScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        "Weather Forecast",
                        "7-day weather predictions",
                        Icons.cloud,
                        Colors.blue,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeatherForecastScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        "Soil Testing",
                        "Check soil health & pH",
                        Icons.science,
                        Colors.brown,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SoilTestingScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        "Plant Disease",
                        "AI-powered disease detection",
                        Icons.local_hospital,
                        Colors.red,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlantDiseaseScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        "Market Prices",
                        "Live commodity prices",
                        Icons.trending_up,
                        Colors.purple,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MarketPricesScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        "Irrigation Timer",
                        "Smart watering schedule",
                        Icons.water,
                        Colors.cyan,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const IrrigationTimerScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        "Fertilizer Guide",
                        "Nutrient recommendations",
                        Icons.eco,
                        Colors.lightGreen,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FertilizerGuideScreen()),
                        ),
                      ),
                      _buildFeatureCard(
                        context,
                        "Farm Records",
                        "Track expenses & yields",
                        Icons.assessment,
                        Colors.indigo,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FarmRecordsScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Additional Tools Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Smart Tools",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CropCalendarScreen()),
                    ),
                    child: _buildToolCard(
                      context,
                      "Crop Calendar",
                      "Plan your farming activities",
                      Icons.calendar_today,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PestControlScreen()),
                    ),
                    child: _buildToolCard(
                      context,
                      "Pest Control",
                      "Identify and treat pests",
                      Icons.bug_report,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GovernmentSchemesScreen()),
                    ),
                    child: _buildToolCard(
                      context,
                      "Government Schemes",
                      "Latest farming subsidies & schemes",
                      Icons.account_balance,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExpertConsultationScreen()),
                    ),
                    child: _buildToolCard(
                      context,
                      "Expert Consultation",
                      "Connect with agricultural experts",
                      Icons.people,
                      Colors.teal,
                    ),
                  ),
                ],
              ),
            ),

            // Emergency Contacts
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.emergency, color: Colors.red.shade600, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Emergency Helpline",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showEmergencyDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Call"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade400,
            size: 16,
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Emergency Contacts"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmergencyContact("Agriculture Helpline", "1800-180-1551"),
              _buildEmergencyContact("Kisan Call Centre", "1800-180-1551"),
              _buildEmergencyContact("Weather Emergency", "1077"),
              _buildEmergencyContact("Veterinary Services", "1962"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmergencyContact(String title, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(number, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}

// Crop Information Screen
class CropInformationScreen extends StatefulWidget {
  const CropInformationScreen({super.key});

  @override
  State<CropInformationScreen> createState() => _CropInformationScreenState();
}

class _CropInformationScreenState extends State<CropInformationScreen> {
  final List<Map<String, dynamic>> crops = [
    {
      'name': 'Rice',
      'season': 'Kharif',
      'duration': '120-150 days',
      'waterReq': 'High',
      'soilType': 'Clay, Loam',
      'tips': 'Maintain water level 2-5cm, Use certified seeds',
    },
    {
      'name': 'Wheat',
      'season': 'Rabi',
      'duration': '110-130 days',
      'waterReq': 'Medium',
      'soilType': 'Loam, Sandy Loam',
      'tips': 'Sow after November, Apply nitrogen in 3 splits',
    },
    {
      'name': 'Maize',
      'season': 'Kharif/Rabi',
      'duration': '90-120 days',
      'waterReq': 'Medium',
      'soilType': 'Well-drained Loam',
      'tips': 'Ensure proper drainage, Side-dress with nitrogen',
    },
    {
      'name': 'Cotton',
      'season': 'Kharif',
      'duration': '180-200 days',
      'waterReq': 'Medium-High',
      'soilType': 'Black cotton soil',
      'tips': 'Monitor for bollworm, Pick cotton when fully mature',
    },
    {
      'name': 'Sugarcane',
      'season': 'Year-round',
      'duration': '10-12 months',
      'waterReq': 'High',
      'soilType': 'Heavy Loam',
      'tips': 'Plant disease-free setts, Maintain soil moisture',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Information"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: crops.length,
        itemBuilder: (context, index) {
          final crop = crops[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: const Icon(Icons.agriculture, color: Colors.green),
              title: Text(
                crop['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${crop['season']} • ${crop['duration']}"),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Season", crop['season']),
                      _buildInfoRow("Duration", crop['duration']),
                      _buildInfoRow("Water Requirement", crop['waterReq']),
                      _buildInfoRow("Soil Type", crop['soilType']),
                      const SizedBox(height: 12),
                      const Text(
                        "Tips:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        crop['tips'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// Weather Forecast Screen
class WeatherForecastScreen extends StatelessWidget {
  const WeatherForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> weatherData = [
      {'day': 'Today', 'temp': '28°C', 'desc': 'Sunny', 'humidity': '65%', 'icon': Icons.wb_sunny},
      {'day': 'Tomorrow', 'temp': '26°C', 'desc': 'Partly Cloudy', 'humidity': '70%', 'icon': Icons.wb_cloudy},
      {'day': 'Wednesday', 'temp': '24°C', 'desc': 'Light Rain', 'humidity': '85%', 'icon': Icons.grain},
      {'day': 'Thursday', 'temp': '22°C', 'desc': 'Heavy Rain', 'humidity': '90%', 'icon': Icons.thunderstorm},
      {'day': 'Friday', 'temp': '25°C', 'desc': 'Cloudy', 'humidity': '75%', 'icon': Icons.cloud},
      {'day': 'Saturday', 'temp': '27°C', 'desc': 'Sunny', 'humidity': '60%', 'icon': Icons.wb_sunny},
      {'day': 'Sunday', 'temp': '29°C', 'desc': 'Hot', 'humidity': '55%', 'icon': Icons.wb_sunny},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Forecast"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current Weather Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.white, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    "28°C",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Sunny",
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherStat("Humidity", "65%", Icons.water_drop),
                      _buildWeatherStat("Wind", "12 km/h", Icons.air),
                      _buildWeatherStat("Pressure", "1013 hPa", Icons.speed),
                    ],
                  ),
                ],
              ),
            ),

            // 7-Day Forecast
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "7-Day Forecast",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weatherData.length,
                    itemBuilder: (context, index) {
                      final weather = weatherData[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(weather['icon'] as IconData, size: 32, color: Colors.blue),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      weather['day'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(weather['desc'] as String),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    weather['temp'] as String,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(weather['humidity'] as String),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Farming Alerts
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        "Farming Alerts",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("⚠️ Heavy rain expected on Thursday - consider postponing pesticide application"),
                  const SizedBox(height: 8),
                  const Text("💡 Good weather for harvesting this weekend"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

// Soil Testing Screen
class SoilTestingScreen extends StatefulWidget {
  const SoilTestingScreen({super.key});

  @override
  State<SoilTestingScreen> createState() => _SoilTestingScreenState();
}

class _SoilTestingScreenState extends State<SoilTestingScreen> {
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();

  String? _recommendation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Soil Testing"),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Soil Test Results",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            _buildInputField("pH Level", _phController, "6.0 - 7.5 (Optimal)"),
            _buildInputField("Nitrogen (N)", _nitrogenController, "kg/hectare"),
            _buildInputField("Phosphorus (P)", _phosphorusController, "kg/hectare"),
            _buildInputField("Potassium (K)", _potassiumController, "kg/hectare"),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _analyzeResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Analyze Results"),
              ),
            ),
            
            if (_recommendation != null) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Recommendations",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(_recommendation!),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Soil Health Guide
            const Text(
              "Soil Health Guide",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            _buildGuideCard(
              "pH Levels",
              "6.0-7.5: Optimal for most crops\n5.5-6.0: Slightly acidic\n7.5-8.0: Slightly alkaline",
              Icons.science,
              Colors.blue,
            ),
            
            _buildGuideCard(
              "Nitrogen (N)",
              "Essential for leaf growth and protein synthesis\nDeficiency: Yellowing of leaves\nExcess: Delayed maturity",
              Icons.eco,
              Colors.green,
            ),
            
            _buildGuideCard(
              "Phosphorus (P)",
              "Important for root development and flowering\nDeficiency: Purple leaves, poor root growth\nSources: Bone meal, rock phosphate",
              Icons.grass,
              Colors.orange,
            ),
            
            _buildGuideCard(
              "Potassium (K)",
              "Helps in disease resistance and water regulation\nDeficiency: Brown leaf edges\nSources: Wood ash, potash fertilizers",
              Icons.shield,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.science),
        ),
      ),
    );
  }

  Widget _buildGuideCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(content, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _analyzeResults() {
    final ph = double.tryParse(_phController.text) ?? 0;
    final nitrogen = double.tryParse(_nitrogenController.text) ?? 0;
    final phosphorus = double.tryParse(_phosphorusController.text) ?? 0;
    final potassium = double.tryParse(_potassiumController.text) ?? 0;

    String recommendation = "Based on your soil test results:\n\n";

    // pH Analysis
    if (ph < 5.5) {
      recommendation += "• Your soil is acidic. Add lime to increase pH.\n";
    } else if (ph > 7.5) {
      recommendation += "• Your soil is alkaline. Add sulfur to decrease pH.\n";
    } else if (ph >= 6.0 && ph <= 7.5) {
      recommendation += "• pH level is optimal for most crops.\n";
    }

    // Nutrient Analysis
    if (nitrogen < 200) {
      recommendation += "• Nitrogen is low. Apply nitrogen-rich fertilizers like urea.\n";
    } else if (nitrogen > 400) {
      recommendation += "• Nitrogen is high. Reduce nitrogen fertilizer application.\n";
    }

    if (phosphorus < 15) {
      recommendation += "• Phosphorus is deficient. Apply DAP or single super phosphate.\n";
    }

    if (potassium < 150) {
      recommendation += "• Potassium is low. Apply muriate of potash.\n";
    }

    setState(() {
      _recommendation = recommendation;
    });
  }
}