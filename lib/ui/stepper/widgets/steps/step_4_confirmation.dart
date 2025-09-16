import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/utils/parameter_extensions.dart';
import 'package:mobile_app/ui/stepper/ui/confirmation_summary_card.dart';
import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';
import 'package:provider/provider.dart';

class Step4Confirmation extends StatelessWidget {
  const Step4Confirmation({super.key});

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  ConfirmationSummaryData _buildPhaseSummaryData(PhaseState phase) {
    final items = phase.thresholds.entries.map((entry) {
      final parameter = entry.key;
      final range = entry.value;
      return SummaryItem(
        label: parameter.label,
        value: '${range.min ?? '-'} / ${range.max ?? '-'}',
        iconPath: parameter.iconPath,
      );
    }).toList();

    return ConfirmationSummaryData(
      title: phase.name,
      subtitle: 'Duración: ${phase.days} días',
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateCropViewModel>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmar Datos',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Text(
            'Revisa todos los ajustes antes de iniciar el nuevo cultivo en la nave seleccionada.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Frecuencia de monitoreo',
                style: theme.textTheme.bodyMedium),
            trailing: Text(
              _formatDuration(viewModel.sensorActivationFrequency),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const Divider(),
          const SizedBox(height: 16),
          ...viewModel.phases.map((phase) {
            final summaryData = _buildPhaseSummaryData(phase);
            return ConfirmationSummaryCard(data: summaryData);
          }),
        ],
      ),
    );
  }
}
