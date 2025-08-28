/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';

class ActuatorsSection extends StatelessWidget {
  final ActiveCropViewModel viewModel;
  const ActuatorsSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        if (viewModel.isPhaseDataLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.phaseDataError != null) {
          return Center(child: Text(viewModel.phaseDataError!));
        }

        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (viewModel.actionsGroupedByDate.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.actuator,
              width: 64.0,
              height: 64.0,
            ),
            const SizedBox(height: 12),
            Text(
              'No hay acciones de control para mostrar en esta fase',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _CurrentStatusSection(viewModel: viewModel),
            const SizedBox(height: 24),
            _HistorySection(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}

class _CurrentStatusSection extends StatelessWidget {
  final ActiveCropViewModel viewModel;
  const _CurrentStatusSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado Actual',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: viewModel.latestActuatorStates.entries.map((entry) {
            return _ActuatorStatusWidget(
              actuator: entry.key,
              latestAction: entry.value,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ActuatorStatusWidget extends StatelessWidget {
  final Actuator actuator;
  final ControlAction? latestAction;

  const _ActuatorStatusWidget({required this.actuator, this.latestAction});

  @override
  Widget build(BuildContext context) {
    final bool isActive = latestAction?.controlActionType == 'ACTIVATED';
    final statusText = isActive ? 'On' : 'Off';
    final statusColor =
        isActive ? AppColors.accent : Theme.of(context).colorScheme.secondary;

    return Column(
      children: [
        SvgPicture.asset(
          actuator.iconPath,
          width: 60,
          height: 60,
          colorFilter: ColorFilter.mode(
            statusColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 8),
        Text(actuator.label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          statusText,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  final ActiveCropViewModel viewModel;
  const _HistorySection({required this.viewModel});

  String _buildHistoryDescription(ControlAction action) {
    final actuatorLabel =
        ActuatorData.fromKey(action.actuatorType).label.toLowerCase();
    final actionType = action.controlActionType == 'ACTIVATED'
        ? 'Se activó el sistema de'
        : 'Se desactivó el sistema de';
    return '$actionType $actuatorLabel.';
  }

  @override
  Widget build(BuildContext context) {
    final groupedActions = viewModel.actionsGroupedByDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial de acciones',
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groupedActions.keys.length,
          itemBuilder: (context, index) {
            final dateHeader = groupedActions.keys.elementAt(index);
            final actionsForDate = groupedActions[dateHeader]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    dateHeader,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ...actionsForDate.map((action) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      action.controlActionType == 'ACTIVATED'
                          ? Icons.play_circle_fill_outlined
                          : Icons.pause_circle_outline,
                      color: action.controlActionType == 'ACTIVATED'
                          ? AppColors.accent
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(_buildHistoryDescription(action),
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Text(
                      DateFormat('h:mm a', 'es_ES')
                          .format(action.timestamp.toLocal()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ],
    );
  }
}
*/