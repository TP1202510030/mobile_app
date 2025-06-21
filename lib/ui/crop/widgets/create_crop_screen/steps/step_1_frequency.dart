import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';

class Step1Frequency extends StatelessWidget {
  final CreateCropViewModel viewModel;
  const Step1Frequency({super.key, required this.viewModel});

  String _formatDuration(Duration d) {
    return "${d.inHours}h ${d.inMinutes.remainder(60)}m ${d.inSeconds.remainder(60)}s";
  }

  void _showFrequencyPicker(BuildContext context) {
    final hController = TextEditingController(
        text: viewModel.sensorActivationFrequency.inHours.toString());
    final mController = TextEditingController(
        text: viewModel.sensorActivationFrequency.inMinutes
            .remainder(60)
            .toString());
    final sController = TextEditingController(
        text: viewModel.sensorActivationFrequency.inSeconds
            .remainder(60)
            .toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Definir Frecuencia',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hController,
                    decoration: const InputDecoration(labelText: 'Horas'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                      controller: mController,
                      decoration: const InputDecoration(labelText: 'Minutos'),
                      keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                      controller: sController,
                      decoration: const InputDecoration(labelText: 'Segundos'),
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              child: Text(
                'Guardar',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              onTap: () {
                final h = int.tryParse(hController.text) ?? 0;
                final m = int.tryParse(mController.text) ?? 0;
                final s = int.tryParse(sController.text) ?? 0;
                viewModel.updateSensorFrequency(
                    Duration(hours: h, minutes: m, seconds: s));
                Navigator.of(ctx).pop();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frecuencia de Monitoreo',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Define cada cuánto tiempo se activarán los sensores para medir los parámetros de la nave.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 32),
        ListTile(
          title: Text(
            'Tiempo',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_formatDuration(viewModel.sensorActivationFrequency)),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                  ],
                );
              }),
          onTap: () => _showFrequencyPicker(context),
        ),
      ],
    );
  }
}
