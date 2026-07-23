import 'package:flutter/material.dart';

class DataTicker extends StatelessWidget {
  const DataTicker({
    super.key,
    required this.title,
    required this.textColor,
    required this.bgColor,
  });

  final String title;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: BoxBorder.all(width: 1, color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }
}
