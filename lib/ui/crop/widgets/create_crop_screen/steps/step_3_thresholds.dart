import 'package:flutter/material.dart';
import 'package:mobile_app/ui/crop/ui/threshold_card.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';

class Step3Thresholds extends StatelessWidget {
  final CreateCropViewModel viewModel;
  const Step3Thresholds({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Define los Umbrales',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Text(
          'Establece los umbrales para temperatura, humedad y CO₂ en cada fase.',
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
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final phase = viewModel.phases[index];
                  return ThresholdCard(
                    viewModel: viewModel,
                    phaseName: phase.nameController.text.isEmpty
                        ? 'Fase ${index + 1}'
                        : phase.nameController.text,
                    thresholdControllers: phase.thresholdControllers,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
