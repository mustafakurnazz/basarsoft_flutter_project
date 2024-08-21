import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const InfoCard({
    super.key,
    required this.title,
    this.backgroundColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
