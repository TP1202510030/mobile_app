import 'package:flutter/material.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crop_details_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/common/phase_history_section.dart';
import 'package:provider/provider.dart';

class FinishedCropDetailsScreenWrapper extends StatelessWidget {
  final int cropId;
  final String totalProduction;

  const FinishedCropDetailsScreenWrapper({
    super.key,
    required this.cropId,
    required this.totalProduction,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<FinishedCropDetailViewModel>(param1: cropId),
      child: FinishedCropDetailsScreen(totalProduction: totalProduction),
    );
  }
}

class FinishedCropDetailsScreen extends StatelessWidget {
  final String totalProduction;

  const FinishedCropDetailsScreen({
    super.key,
    required this.totalProduction,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FinishedCropDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cultivo #${viewModel.crop?.id ?? ''}',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          if (viewModel.crop == null ||
              viewModel.selectedPhaseDetails == null) {
            return const EmptyState(
                message: "No hay historial para mostrar",
                iconAsset: AppIcons.mushroom);
          }

          return Column(
            children: [
              const SizedBox(height: AppSizes.spacingMedium),
              Center(
                child: Text('Producción total: $totalProduction Tn',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              _PhaseNavigator(viewModel: viewModel),
              Expanded(
                child: PhaseHistorySection(
                  measurements: viewModel.selectedPhaseDetails!.measurements,
                  // No se pasa scrollController para deshabilitar el scroll infinito
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PhaseNavigator extends StatelessWidget {
  final FinishedCropDetailViewModel viewModel;

  const _PhaseNavigator({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: viewModel.canGoBack ? viewModel.goToPreviousPhase : null,
        ),
        Expanded(
          child: Text(
            "Fase: ${viewModel.selectedPhaseDetails?.phase.name ?? ''}",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: viewModel.canGoForward ? viewModel.goToNextPhase : null,
        ),
      ],
    );
  }
}
