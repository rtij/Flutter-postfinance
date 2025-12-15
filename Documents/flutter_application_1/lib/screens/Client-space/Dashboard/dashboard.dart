import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          Text(
            'Welcome to the Dashboard!',
            style: TextStyle(fontSize: 24),
          ),
          // back button
          SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            Beamer.of(context,root: true).beamToNamed('/login');
          }, child: 
            Text('Back to Home')
          ),
        ],
      ),
    );
  }
}