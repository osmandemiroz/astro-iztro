import 'package:flutter/material.dart';
import 'package:dart_iztro/dart_iztro.dart';

void main() {
  runApp(const AstroIztroApp());
}

class AstroIztroApp extends StatelessWidget {
  const AstroIztroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astro Iztro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AstroIztroHomePage(),
    );
  }
}

class AstroIztroHomePage extends StatelessWidget {
  const AstroIztroHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astro Iztro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Astro Iztro!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Use the dart_iztro package here
                // For example:
                // final result = Iztro.someFunction();
                // print(result);
              },
              child: const Text('Perform Action'),
            ),
          ],
        ),
      ),
    );
  }
}
