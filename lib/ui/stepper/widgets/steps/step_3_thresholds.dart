import 'package:flutter/material.dart';
import 'package:mobile_app/domain/entities/measurement/parameter.dart';
import 'package:mobile_app/ui/stepper/ui/threshold_card.dart';
import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';
import 'package:provider/provider.dart';

double? _parseDouble(String text) {
  if (text.isEmpty) return null;
  return double.tryParse(text.replaceAll(',', '.'));
}

class Step3Thresholds extends StatefulWidget {
  final CreateCropViewModel viewModel;
  const Step3Thresholds({super.key, required this.viewModel});

  @override
  State<Step3Thresholds> createState() => _Step3ThresholdsState();
}

class _Step3ThresholdsState extends State<Step3Thresholds> {
  final List<Map<Parameter, ThresholdTextControllers>> _phaseControllers = [];
  late final CreateCropViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.addListener(_onVmChanged);
    _syncControllersWithViewModel();
  }

  void _onVmChanged() {
    if (_viewModel.phases.length != _phaseControllers.length) {
      _syncControllersWithViewModel();
      return;
    }

    if (mounted) setState(() {});
  }

  void _syncControllersWithViewModel() {
    _disposeControllers();
    for (int i = 0; i < _viewModel.phases.length; i++) {
      final phase = _viewModel.phases[i];
      final parameterControllers = <Parameter, ThresholdTextControllers>{};
      for (final param in Parameter.values) {
        final current = phase.thresholds[param] ?? const ThresholdRange();
        final minC = TextEditingController(text: current.min?.toString() ?? '');
        final maxC = TextEditingController(text: current.max?.toString() ?? '');

        minC.addListener(() =>
            _viewModel.updateThreshold(i, param, min: _parseDouble(minC.text)));
        maxC.addListener(() =>
            _viewModel.updateThreshold(i, param, max: _parseDouble(maxC.text)));

        parameterControllers[param] =
            ThresholdTextControllers(minController: minC, maxController: maxC);
      }
      _phaseControllers.add(parameterControllers);
    }
    if (mounted) setState(() {});
  }

  void _disposeControllers() {
    for (final paramMap in _phaseControllers) {
      for (final controllerPair in paramMap.values) {
        controllerPair.minController.dispose();
        controllerPair.maxController.dispose();
      }
    }
    _phaseControllers.clear();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_syncControllersWithViewModel);
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final phases = context.watch<CreateCropViewModel>().phases;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Define los Umbrales',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Text(
          'Establece los umbrales para los parámetros de cada fase.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: _phaseControllers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final phaseState = phases[index];
              return ThresholdCard(
                phaseName: phaseState.name.isEmpty
                    ? 'Fase ${index + 1}'
                    : phaseState.name,
                controllers: _phaseControllers[index],
                errorTextOf: (parameter) {
                  return phaseState.thresholds[parameter]?.validationError;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
