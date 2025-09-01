import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';

class Step1Frequency extends StatelessWidget {
  final CreateCropViewModel viewModel;
  const Step1Frequency({super.key, required this.viewModel});

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${h}h ${two(m)}m ${two(s)}s';
  }

  Future<void> _showFrequencyPicker(BuildContext context) async {
    final picked = await showModalBottomSheet<Duration>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => _FrequencyPickerSheet(
        initial: viewModel.sensorActivationFrequency,
      ),
    );

    if (picked != null) {
      viewModel.updateSensorFrequency(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frecuencia de Monitoreo',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        Text(
          'Define cada cuánto tiempo se activarán los sensores para medir los parámetros de la nave.',
          style: theme.textTheme.bodyMedium,
        ),
        const Spacer(),
        ListTile(
          key: const Key('frequency_tile'),
          title: Text(
            'Frecuencia',
            style: theme.textTheme.bodyMedium,
          ),
          trailing: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDuration(viewModel.sensorActivationFrequency),
                    key: const Key('frequency_value'),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right),
                ],
              );
            },
          ),
          onTap: () => _showFrequencyPicker(context),
        ),
      ],
    );
  }
}

class _FrequencyPickerSheet extends StatefulWidget {
  final Duration initial;
  const _FrequencyPickerSheet({required this.initial});

  @override
  State<_FrequencyPickerSheet> createState() => _FrequencyPickerSheetState();
}

class _FrequencyPickerSheetState extends State<_FrequencyPickerSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _hoursCtrl;
  late final TextEditingController _minutesCtrl;
  late final TextEditingController _secondsCtrl;

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _hoursCtrl = TextEditingController(
      text: widget.initial.inHours.clamp(0, 99).toString(),
    );
    _minutesCtrl = TextEditingController(
      text: widget.initial.inMinutes.remainder(60).toString(),
    );
    _secondsCtrl = TextEditingController(
      text: widget.initial.inSeconds.remainder(60).toString(),
    );

    _hoursCtrl.addListener(_onFieldsChanged);
    _minutesCtrl.addListener(_onFieldsChanged);
    _secondsCtrl.addListener(_onFieldsChanged);

    _isValid = _computeIsValid();
  }

  @override
  void dispose() {
    _hoursCtrl.removeListener(_onFieldsChanged);
    _minutesCtrl.removeListener(_onFieldsChanged);
    _secondsCtrl.removeListener(_onFieldsChanged);
    _hoursCtrl.dispose();
    _minutesCtrl.dispose();
    _secondsCtrl.dispose();
    super.dispose();
  }

  void _onFieldsChanged() {
    final nowValid = _computeIsValid();
    if (nowValid != _isValid) {
      setState(() => _isValid = nowValid);
    }
  }

  bool _computeIsValid() {
    final h = int.tryParse(_hoursCtrl.text);
    final m = int.tryParse(_minutesCtrl.text);
    final s = int.tryParse(_secondsCtrl.text);
    if (h == null || m == null || s == null) return false;
    if (h < 0 || h > 99) return false;
    if (m < 0 || m > 59) return false;
    if (s < 0 || s > 59) return false;
    if (h == 0 && m == 0 && s == 0) return false;
    return true;
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    if (!_computeIsValid()) return;

    final h = int.parse(_hoursCtrl.text);
    final m = int.parse(_minutesCtrl.text);
    final s = int.parse(_secondsCtrl.text);

    final duration = Duration(hours: h, minutes: m, seconds: s);
    Navigator.of(context).pop(duration);
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  String? _validateHours(String? v) {
    final n = int.tryParse(v ?? '');
    if (n == null) return 'Requerido';
    if (n < 0 || n > 99) return '0–99';
    return null;
  }

  String? _validateMinuteSecond(String? v) {
    final n = int.tryParse(v ?? '');
    if (n == null) return 'Requerido';
    if (n < 0 || n > 59) return '0–59';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final numericAndMax2 = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(2),
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Set Frequency', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('hours_field'),
                    controller: _hoursCtrl,
                    decoration: _decoration('Horas'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: numericAndMax2,
                    validator: _validateHours,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: const Key('minutes_field'),
                    controller: _minutesCtrl,
                    decoration: _decoration('Minutos'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: numericAndMax2,
                    validator: _validateMinuteSecond,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: const Key('seconds_field'),
                    controller: _secondsCtrl,
                    decoration: _decoration('Segundos'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: numericAndMax2,
                    onFieldSubmitted: (_) {
                      if (_isValid) _onSave();
                    },
                    validator: _validateMinuteSecond,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              key: const Key('save_frequency_button'),
              onTap: _isValid ? _onSave : null,
              child: Text(
                'Confirmar',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
