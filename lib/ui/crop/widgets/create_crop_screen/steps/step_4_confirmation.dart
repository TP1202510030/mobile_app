import 'package:flutter/material.dart';
import 'package:mobile_app/ui/crop/ui/confirmation_summary_card.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';

class Step4Confirmation extends StatelessWidget {
  final CreateCropViewModel viewModel;
  const Step4Confirmation({super.key, required this.viewModel});

  String _formatDuration(Duration d) {
    return "${d.inHours}h ${d.inMinutes.remainder(60)}m ${d.inSeconds.remainder(60)}s";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmar Datos',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Revisa todos los ajustes antes de iniciar el nuevo cultivo en la nave seleccionada.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Frecuencia de monitoreo'),
            trailing:
                Text(_formatDuration(viewModel.sensorActivationFrequency)),
          ),
          const Divider(),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return Column(
                children: viewModel.phases.map((phase) {
                  return ConfirmationSummaryCard(
                    phaseName: phase.nameController.text,
                    duration: phase.durationController.text,
                    thresholdControllers: phase.thresholdControllers,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
