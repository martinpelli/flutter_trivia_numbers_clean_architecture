import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String text;
  const MessageDisplay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Center(child: SingleChildScrollView(child: Text(text, style: const TextStyle(fontSize: 25), textAlign: TextAlign.center))));
  }
}
