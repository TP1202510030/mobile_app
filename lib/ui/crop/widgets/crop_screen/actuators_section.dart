import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/entities/control_action/actuator.dart';
import 'package:mobile_app/domain/entities/control_action/control_action.dart';
import 'package:mobile_app/domain/entities/control_action/control_action_type.dart';
import 'package:mobile_app/ui/core/themes/app_accent_colors.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/actuator_icon.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/core/utils/actuator_extensions.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';

class ActuatorsSection extends StatefulWidget {
  final ActiveCropViewModel viewModel;
  final ActiveCropSuccess state;

  const ActuatorsSection({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  State<ActuatorsSection> createState() => _ActuatorsSectionState();
}

class _ActuatorsSectionState extends State<ActuatorsSection> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.viewModel.fetchMoreActionsForSelectedPhase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.isPhaseDataLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state.actionsForSelectedPhase.isEmpty) {
      return const EmptyState(
        message: 'No hay acciones de control para mostrar en esta fase.',
        iconAsset: AppIcons.actuator,
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _CurrentStatusSection(viewModel: widget.viewModel),
          const SizedBox(height: AppSizes.spacingExtraLarge),
          _HistorySection(viewModel: widget.viewModel, state: widget.state),
        ],
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
        Text('Estado Actual', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSizes.spacingLarge),
        Divider(
          color: Theme.of(context).colorScheme.outline,
          height: 1,
          thickness: 1,
        ),
        const SizedBox(height: AppSizes.spacingExtraLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: viewModel.currentActuatorStates.entries
              .map((entry) => _ActuatorStatus(
                    actuator: entry.key,
                    actionType: entry.value,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ActuatorStatus extends StatelessWidget {
  final Actuator actuator;
  final ControlActionType? actionType;
  const _ActuatorStatus({required this.actuator, this.actionType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isActive = actionType == ControlActionType.activated;
    final statusText = isActive ? 'On' : 'Off';
    final statusColor = isActive
        ? theme.extension<AppAccentColors>()!.accent!
        : theme.colorScheme.secondary;

    return Column(
      children: [
        ActuatorIcon(actuator: actuator, isActive: isActive, size: 60),
        const SizedBox(height: AppSizes.spacingMedium),
        Text(actuator.label, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSizes.spacingSmall),
        Text(
          statusText,
          style: theme.textTheme.titleMedium
              ?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  final ActiveCropViewModel viewModel;
  final ActiveCropSuccess state;
  const _HistorySection({required this.viewModel, required this.state});

  @override
  Widget build(BuildContext context) {
    final groupedActions = viewModel.actionsGroupedByDate;
    final isFetchingMore = state.isFetchingMoreActions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Historial de acciones',
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSizes.spacingLarge),
        Divider(
          color: Theme.of(context).colorScheme.outline,
          height: 1,
          thickness: 1,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groupedActions.keys.length,
          itemBuilder: (context, index) {
            final dateHeader = groupedActions.keys.elementAt(index);
            final actions = groupedActions[dateHeader]!;
            return _HistoryDateGroup(date: dateHeader, actions: actions);
          },
        ),
        if (isFetchingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _HistoryDateGroup extends StatelessWidget {
  final String date;
  final List<ControlAction> actions;
  const _HistoryDateGroup({required this.date, required this.actions});

  String _buildDescription(ControlAction action) {
    final actionType = action.controlActionType == ControlActionType.activated
        ? 'Se activó'
        : 'Se desactivó';
    return '$actionType el sistema de ${action.actuatorType.label.toLowerCase()}.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingLarge),
          child: Text(date,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
        ...actions.map((action) {
          final isActive =
              action.controlActionType == ControlActionType.activated;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              isActive ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: isActive
                  ? theme.extension<AppAccentColors>()!.accent
                  : theme.colorScheme.secondary,
            ),
            title: Text(_buildDescription(action),
                style: theme.textTheme.bodyMedium),
            trailing: Text(
              DateFormat('h:mm a', 'es_ES').format(action.timestamp.toLocal()),
              style: theme.textTheme.bodySmall,
            ),
          );
        })
      ],
    );
  }
}
