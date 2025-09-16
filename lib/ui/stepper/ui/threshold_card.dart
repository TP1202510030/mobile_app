import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/utils/parameter_extensions.dart';

final _decimalInputFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));

class ThresholdTextControllers {
  final TextEditingController minController;
  final TextEditingController maxController;

  const ThresholdTextControllers({
    required this.minController,
    required this.maxController,
  });
}

class ThresholdCard extends StatelessWidget {
  final String phaseName;
  final Map<Parameter, ThresholdTextControllers> controllers;
  final String? Function(Parameter parameter) errorTextOf;

  const ThresholdCard({
    super.key,
    required this.phaseName,
    required this.controllers,
    required this.errorTextOf,
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
            Text(phaseName, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSizes.spacingLarge),
            ListView.separated(
              itemCount: Parameter.values.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSizes.spacingMedium),
              itemBuilder: (context, index) {
                final param = Parameter.values[index];
                final pair = controllers[param]!;
                return ListenableBuilder(
                  listenable: Listenable.merge([
                    pair.minController,
                    pair.maxController,
                  ]),
                  builder: (context, child) {
                    final errorText = errorTextOf(param);
                    return ParameterThresholdInput(
                      label: param.label,
                      minController: pair.minController,
                      maxController: pair.maxController,
                      errorText: errorText,
                    );
                  },
                );
              },
            ),
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
    final theme = Theme.of(context);
    final hasError = errorText != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
        ),
        const SizedBox(width: AppSizes.spacingSmall),
        Expanded(
          flex: 2,
          child: _ThresholdTextField(
            controller: minController,
            labelText: 'Min.',
            hasError: hasError,
          ),
        ),
        const SizedBox(width: AppSizes.spacingSmall),
        Expanded(
          flex: 2,
          child: _ThresholdTextField(
            controller: maxController,
            labelText: 'Max.',
            errorText: errorText,
            hasError: hasError,
          ),
        ),
      ],
    );
  }
}

class _ThresholdTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final bool hasError;

  const _ThresholdTextField({
    required this.controller,
    required this.labelText,
    this.errorText,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final errorBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: errorColor, width: 2),
    );

    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        labelText: labelText,
        labelStyle: theme.textTheme.bodySmall,
        focusedBorder: hasError ? errorBorder : null,
        enabledBorder: hasError
            ? UnderlineInputBorder(borderSide: BorderSide(color: errorColor))
            : null,
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 11, height: 1),
        errorMaxLines: 2,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [_decimalInputFormatter],
    );
  }
}
