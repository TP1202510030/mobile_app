import 'package:flutter/material.dart';
import 'package:mobile_app/ui/stepper/ui/phase_card.dart';
import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';

class Step2Phases extends StatefulWidget {
  final CreateCropViewModel viewModel;
  const Step2Phases({super.key, required this.viewModel});

  @override
  State<Step2Phases> createState() => _Step2PhasesState();
}

class _Step2PhasesState extends State<Step2Phases> {
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _durationControllers = [];
  late final CreateCropViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.addListener(_onVmChanged);
    _syncControllersWithViewModel();
  }

  void _onVmChanged() {
    if (_viewModel.phases.length != _nameControllers.length) {
      _syncControllersWithViewModel();
      return;
    }
    if (mounted) setState(() {});
  }

  void _syncControllersWithViewModel() {
    _disposeControllers();
    for (int i = 0; i < _viewModel.phases.length; i++) {
      final phase = _viewModel.phases[i];
      final nameController = TextEditingController(text: phase.name);
      nameController.addListener(
        () => _viewModel.updatePhase(i, name: nameController.text),
      );
      final durationController =
          TextEditingController(text: phase.days.toString());
      durationController.addListener(
        () => _viewModel.updatePhase(i,
            days: int.tryParse(durationController.text) ?? 0),
      );
      _nameControllers.add(nameController);
      _durationControllers.add(durationController);
    }
    if (mounted) setState(() {});
  }

  void _disposeControllers() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    for (final controller in _durationControllers) {
      controller.dispose();
    }
    _nameControllers.clear();
    _durationControllers.clear();
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Define las Fases del Cultivo',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Text(
          'Especifica cuántas fases tendrá el cultivo y define la duración de cada una.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: _nameControllers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return PhaseCard(
                nameController: _nameControllers[index],
                durationController: _durationControllers[index],
                canBeDeleted: _nameControllers.length > 1,
                onDelete: () => _viewModel.removePhase(index),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _viewModel.addPhase,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Añadir nueva fase',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
