import 'package:flutter/material.dart';

class ParameterThresholdInput extends StatelessWidget {
  final String label;
  final TextEditingController minController;
  final TextEditingController maxController;

  const ParameterThresholdInput({
    super.key,
    required this.label,
    required this.minController,
    required this.maxController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(label)),
        Expanded(
          flex: 2,
          child: TextField(
            controller: minController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Min.',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextField(
            controller: maxController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Max.',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }
}
