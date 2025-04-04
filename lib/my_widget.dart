import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final String data;
  const MyWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(data),
      ),
    );
  }
}
