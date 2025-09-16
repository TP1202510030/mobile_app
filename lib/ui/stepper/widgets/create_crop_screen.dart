import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/stepper/widgets/steps/step_2_phases.dart';
import 'package:mobile_app/ui/stepper/widgets/steps/step_3_thresholds.dart';
import 'package:mobile_app/ui/stepper/widgets/steps/step_4_confirmation.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/ui/stepper/ui/stepper.dart';
import 'package:mobile_app/ui/stepper/view_models/create_crop_viewmodel.dart';
import 'package:mobile_app/ui/stepper/widgets/steps/step_1_frequency.dart';

class CreateCropScreen extends StatelessWidget {
  final int growRoomId;
  const CreateCropScreen({super.key, required this.growRoomId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<CreateCropViewModel>(param1: growRoomId),
      child: const _CreateCropView(),
    );
  }
}

class _CreateCropView extends StatefulWidget {
  const _CreateCropView();
  @override
  State<_CreateCropView> createState() => _CreateCropViewState();
}

class _CreateCropViewState extends State<_CreateCropView> {
  late final PageController _pageController;
  late final CreateCropViewModel _viewModel;

  void _onStepChanged() {
    if (!mounted) return;
    final target = _viewModel.currentStepIndex;
    if (_pageController.hasClients && _pageController.page?.round() != target) {
      _pageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleProcessCompletion() {
    if (!mounted) return;

    if (_viewModel.isProcessComplete) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Cultivo iniciado con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
      context.go(AppRoutes.home);
    } else if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Error: ${_viewModel.errorMessage}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<CreateCropViewModel>();
    _pageController = PageController(initialPage: _viewModel.currentStepIndex);
    _viewModel.addListener(_onStepChanged);
    _viewModel.addListener(_handleProcessCompletion);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStepChanged);
    _viewModel.removeListener(_handleProcessCompletion);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateCropViewModel>();

    final steps = List.generate(viewModel.totalSteps, (i) {
      return StepData(
        title: '',
        isActive: i == viewModel.currentStepIndex,
        isCompleted: i < viewModel.currentStepIndex,
      );
    });

    return PopScope(
      canPop: viewModel.currentStepIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop) {
          viewModel.previousStep();
        }
      },
      child: BaseLayout(
        title: 'Iniciar Nuevo Cultivo',
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacingMedium),
              CustomStepper(
                steps: steps,
                onStepTapped: (index) {
                  if (index < viewModel.currentStepIndex) {
                    viewModel.goToStepIndex(index);
                  }
                },
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Step1Frequency(viewModel: viewModel),
                    Step2Phases(viewModel: viewModel),
                    Step3Thresholds(viewModel: viewModel),
                    const Step4Confirmation(),
                  ],
                ),
              ),
              _buildNavigationButton(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, CreateCropViewModel viewModel) {
    final bool isLastStep =
        viewModel.currentStepIndex == viewModel.totalSteps - 1;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.spacingMedium,
            bottom:
                MediaQuery.of(context).padding.bottom + AppSizes.spacingSmall,
          ),
          child: CustomButton(
            onTap: viewModel.isCurrentStepValid && !viewModel.isLoading
                ? viewModel.nextStep
                : null,
            isLoading: viewModel.isLoading,
            variant: ButtonVariant.primary,
            child: Text(isLastStep ? 'Confirmar' : 'Continuar'),
          ),
        );
      },
    );
  }
}
