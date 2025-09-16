import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_accent_colors.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

class CustomStepper extends StatelessWidget {
  final List<StepData> steps;
  final ValueChanged<int>? onStepTapped;

  const CustomStepper({super.key, required this.steps, this.onStepTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        steps.length,
        (index) {
          return Expanded(
            child: _StepIndicator(
              step: steps[index],
              onTap: onStepTapped != null ? () => onStepTapped!(index) : null,
            ),
          );
        },
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final StepData step;
  final VoidCallback? onTap;

  const _StepIndicator({required this.step, this.onTap});

  Color _getTargetColor(BuildContext context) {
    final theme = Theme.of(context);

    final bool isHighlighted = step.isActive || step.isCompleted;

    return isHighlighted
        ? theme.extension<AppAccentColors>()!.accent!
        : theme.colorScheme.outline;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingSmall),
        child: ListenableBuilder(
          listenable: Listenable.merge([
            step.isActiveNotifier,
            step.isCompletedNotifier,
          ]),
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 5.0,
              decoration: BoxDecoration(
                color: _getTargetColor(context),
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StepData {
  final String title;
  final ValueNotifier<bool> isActiveNotifier;
  final ValueNotifier<bool> isCompletedNotifier;

  StepData({
    required this.title,
    bool isActive = false,
    bool isCompleted = false,
  })  : isActiveNotifier = ValueNotifier(isActive),
        isCompletedNotifier = ValueNotifier(isCompleted);

  bool get isActive => isActiveNotifier.value;
  bool get isCompleted => isCompletedNotifier.value;

  set isActive(bool value) {
    if (isActiveNotifier.value != value) {
      isActiveNotifier.value = value;
    }
  }

  set isCompleted(bool value) {
    if (isCompletedNotifier.value != value) {
      isCompletedNotifier.value = value;
    }
  }

  void dispose() {
    isActiveNotifier.dispose();
    isCompletedNotifier.dispose();
  }
}
