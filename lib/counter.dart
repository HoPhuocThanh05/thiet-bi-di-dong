import 'package:flutter/material.dart';

class MyCounter extends StatefulWidget {
  const MyCounter({super.key});

  @override
  State<MyCounter> createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  int _Counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Column(
        children: [
          Center(child: Text('Bộ đếm hiện tại là :$_Counter')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _Counter--;
              });
              print('bộ đếm hiện tại là: $_Counter');
            },
            child: const Text('giam bo dem'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _Counter++;
              });
              print('bộ đếm hiện tại là: $_Counter');
            },
            child: const Text('tang bo dem'),
          ),
        ],
      ),
    );
  }
}
