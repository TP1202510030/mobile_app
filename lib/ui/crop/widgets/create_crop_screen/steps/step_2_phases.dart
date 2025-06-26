import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/ui/phase_card.dart';

class Step2Phases extends StatelessWidget {
  final CreateCropViewModel viewModel;
  const Step2Phases({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Define las Fases del Cultivo',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Text(
          'Especifica cuántas fases tendrá el cultivo y define la duración de cada una.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return ListView.separated(
                itemCount: viewModel.phases.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return PhaseCard(
                    nameController: viewModel.phases[index].nameController,
                    durationController:
                        viewModel.phases[index].durationController,
                    canBeDeleted: viewModel.phases.length > 1,
                    onDelete: () => viewModel.removePhase(index),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: viewModel.addPhase,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Añadir nueva fase',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
