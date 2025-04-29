import 'package:flutter/material.dart';

class CropsArchiveScreen extends StatelessWidget {
  const CropsArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Historial de Cultivos",
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }
}
