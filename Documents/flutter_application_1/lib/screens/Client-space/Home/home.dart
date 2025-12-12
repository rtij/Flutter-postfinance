import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  


  testClick() {
    print("Test click");
    context.beamToNamed('/parent');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: testClick,
          child: const Text('Test Click'),
        ),
      ),
    );
  }
}