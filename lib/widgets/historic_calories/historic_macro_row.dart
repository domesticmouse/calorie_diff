import 'package:flutter/material.dart';

class HistoricMacroRow extends StatelessWidget {
  final String label;
  final num data;
  final num target;

  const HistoricMacroRow({
    required this.label,
    required this.data,
    required this.target,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey[400],
              fontSize: 14,
              height: 1.25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          data.toStringAsFixed(0),
          style: TextStyle(
            color: Colors.blueGrey[400],
            fontSize: 14,
            height: 1.25,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "of",
          style: TextStyle(
            color: Colors.blueGrey[400],
            fontSize: 14,
            height: 1.25,
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 40,
          child: Text(
            "${target.toStringAsFixed(0)}g",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.blueGrey[400],
              fontSize: 14,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
