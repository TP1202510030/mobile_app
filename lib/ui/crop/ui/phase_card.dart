import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhaseCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController durationController;
  final VoidCallback onDelete;
  final bool canBeDeleted;

  const PhaseCard({
    super.key,
    required this.nameController,
    required this.durationController,
    required this.onDelete,
    this.canBeDeleted = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (canBeDeleted)
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Fase',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: 'Duración (en días)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ],
        ),
      ),
    );
  }
}
