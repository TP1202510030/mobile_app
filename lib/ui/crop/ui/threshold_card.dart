import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/ui/core/utils/parameter_extensions.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';

class ThresholdCard extends StatelessWidget {
  final String phaseName;
  final Map<Parameter, ThresholdControllers> thresholdControllers;
  final CreateCropViewModel viewModel;

  const ThresholdCard({
    super.key,
    required this.phaseName,
    required this.thresholdControllers,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phaseName, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            ...Parameter.values.map((param) {
              final controllers = thresholdControllers[param]!;
              final errorText = viewModel.getThresholdErrorText(controllers);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ParameterThresholdInput(
                  label: param.label,
                  minController: thresholdControllers[param]!.minController,
                  maxController: thresholdControllers[param]!.maxController,
                  errorText: errorText,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ParameterThresholdInput extends StatelessWidget {
  final String label;
  final TextEditingController minController;
  final TextEditingController maxController;
  final String? errorText;

  const ParameterThresholdInput({
    super.key,
    required this.label,
    required this.minController,
    required this.maxController,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    final errorBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: errorColor, width: 2),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(label, style: theme.textTheme.bodyMedium),
            )),
        Expanded(
          flex: 2,
          child: TextField(
            controller: minController,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Min.',
              labelStyle: theme.textTheme.bodySmall,
              focusedBorder: hasError ? errorBorder : null,
              enabledBorder: hasError
                  ? errorBorder.borderSide.width == 1
                      ? errorBorder
                      : UnderlineInputBorder(
                          borderSide: BorderSide(color: errorColor))
                  : null,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextField(
            controller: maxController,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Max.',
              labelStyle: theme.textTheme.bodySmall,
              errorText: errorText,
              errorStyle: const TextStyle(fontSize: 11, height: 1),
              errorMaxLines: 2,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
        ),
      ],
    );
  }
}
