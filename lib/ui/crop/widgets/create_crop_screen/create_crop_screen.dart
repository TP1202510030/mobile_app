import 'package:flutter/material.dart';

import 'package:mobile_app/ui/core/ui/button.dart';

import 'package:mobile_app/ui/crop/view_models/create_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/create_crop_screen/steps/step_1_frequency.dart';
import 'package:mobile_app/ui/crop/widgets/create_crop_screen/steps/step_2_phases.dart';
import 'package:mobile_app/ui/crop/widgets/create_crop_screen/steps/step_3_thresholds.dart';
import 'package:mobile_app/ui/crop/widgets/create_crop_screen/steps/step_4_confirmation.dart';

class CreateCropScreen extends StatefulWidget {
  final CreateCropViewModel viewModel;

  const CreateCropScreen({super.key, required this.viewModel});

  @override
  State<CreateCropScreen> createState() => _CreateCropScreenState();
}

class _CreateCropScreenState extends State<CreateCropScreen> {
  late final CreateCropViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: _viewModel.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Step1Frequency(viewModel: _viewModel),
                Step2Phases(viewModel: _viewModel),
                Step3Thresholds(viewModel: _viewModel),
                Step4Confirmation(viewModel: _viewModel),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, child) {
              return CustomButton(
                onTap: _viewModel.isCurrentStepValid
                    ? () => _viewModel.nextStep(context)
                    : null,
                child: Text(
                  _viewModel.currentStep == _viewModel.steps.length - 1
                      ? 'Completar'
                      : 'Continuar',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
