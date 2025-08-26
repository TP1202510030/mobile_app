import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';

class CustomStepper extends StatefulWidget {
  final List<StepData> steps;
  final ValueChanged<int>? onStepTapped;

  const CustomStepper({super.key, required this.steps, this.onStepTapped});

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.steps.map((step) {
        int index = widget.steps.indexOf(step);
        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (widget.onStepTapped != null) {
                widget.onStepTapped!(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ListenableBuilder(
                listenable: Listenable.merge(
                  [step.isActiveNotifier, step.isCompletedNotifier],
                ),
                builder: (context, child) {
                  Color targetColor = step.isCompleted
                      ? AppColors.accent
                      : step.isActive
                          ? AppColors.accent
                          : Theme.of(context).colorScheme.outline;

                  return Container(
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: targetColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }).toList(),
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

  set isActive(bool value) => isActiveNotifier.value = value;
  set isCompleted(bool value) => isCompletedNotifier.value = value;
}
