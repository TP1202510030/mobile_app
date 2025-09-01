import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

abstract final class _PhaseCardLabels {
  static const String phaseName = "Nombre de la Fase";
  static const String durationInDays = "Duración (en días)";
}

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
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canBeDeleted)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                  onPressed: onDelete,
                  tooltip: "Eliminar fase",
                ),
              ),
            _PhaseTextField(
              controller: nameController,
              labelText: _PhaseCardLabels.phaseName,
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            _PhaseTextField(
              controller: durationController,
              labelText: _PhaseCardLabels.durationInDays,
              prefixIcon: Icons.timer_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhaseTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _PhaseTextField({
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }
}
