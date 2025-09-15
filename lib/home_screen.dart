import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Krishi Saathi - Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/crops'),
              child: const Text("View Crops"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/weather'),
              child: const Text("Check Weather"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text("Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
