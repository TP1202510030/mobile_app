import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/actuators_section.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/sensors_section.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/utils/command.dart';
import 'package:provider/provider.dart';

class CropScreen extends StatelessWidget {
  final int cropId;
  final String growRoomName;

  const CropScreen({
    super.key,
    required this.cropId,
    required this.growRoomName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<ActiveCropViewModel>(param1: cropId),
      child: _CropView(growRoomName: growRoomName),
    );
  }
}

class _CropView extends StatefulWidget {
  final String growRoomName;
  const _CropView({required this.growRoomName});

  @override
  State<_CropView> createState() => _CropViewState();
}

class _CropViewState extends State<_CropView> {
  CommandStatus _lastFinishStatus = CommandStatus.idle;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiveCropViewModel>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ActiveCropViewModel>();
    final state = viewModel.state;
    final finishStatus = viewModel.finishCropCommand.status;
    if (finishStatus != _lastFinishStatus) {
      _lastFinishStatus = finishStatus;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        if (finishStatus == CommandStatus.success) {
          await locator<HomeViewModel>().refreshGrowRooms();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cultivo finalizado con éxito.')),
          );
          if (!mounted) return;
          context.go(AppRoutes.home);
        } else if (finishStatus == CommandStatus.error) {
          final err = viewModel.finishCropCommand.error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al finalizar cultivo: $err')),
          );
        }
      });
    }

    return BaseLayout(
      title: widget.growRoomName,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
        child: RefreshIndicator(
          onRefresh: viewModel.refreshData,
          child: switch (state) {
            ActiveCropLoading() =>
              const Center(child: CircularProgressIndicator()),
            ActiveCropError(message: final msg) => Center(child: Text(msg)),
            ActiveCropSuccess() => _buildSuccessUI(context, viewModel, state),
          },
        ),
      ),
    );
  }

  Widget _buildSuccessUI(
    BuildContext context,
    ActiveCropViewModel viewModel,
    ActiveCropSuccess state,
  ) {
    return Column(
      children: [
        const SizedBox(height: AppSizes.spacingLarge),
        _PhaseNavigator(viewModel: viewModel, state: state),
        const SizedBox(height: AppSizes.spacingExtraLarge),
        HorizontalOptionList(
          options: [
            OptionItemData(title: "Sensores", iconPath: AppIcons.sensor),
            OptionItemData(title: "Actuadores", iconPath: AppIcons.actuator),
          ],
          initialIndex: viewModel.selectedSectionIndex,
          onItemSelected: viewModel.selectSection,
        ),
        const SizedBox(height: AppSizes.spacingExtraLarge),
        Expanded(
          child: IndexedStack(
            index: viewModel.selectedSectionIndex,
            children: [
              SensorsSection(viewModel: viewModel, state: state),
              ActuatorsSection(viewModel: viewModel, state: state),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhaseNavigator extends StatelessWidget {
  final ActiveCropViewModel viewModel;
  final ActiveCropSuccess state;

  const _PhaseNavigator({required this.viewModel, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: state.canGoBack ? viewModel.goToPreviousPhase : null,
        ),
        Expanded(
          child: Text(
            "Fase: ${state.selectedPhase.name}",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        _buildActionButton(context),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (state.isCurrentActivePhase &&
        state.canGoForward &&
        !state.isLastPhase) {
      return SizedBox(
        width: 150,
        child: CustomButton.text(
          onTap: () => _showConfirmationDialog(
            context,
            "Avanzar Fase",
            '¿Estás seguro de que deseas avanzar a la siguiente fase?',
            viewModel.advancePhase,
          ),
          text: 'Finalizar Fase',
        ),
      );
    }
    if (state.isCurrentActivePhase && state.isLastPhase) {
      return SizedBox(
        width: 150,
        child: CustomButton.text(
          onTap: () => _showProductionInputDialog(context),
          text: 'Finalizar Cultivo',
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.arrow_forward_ios),
      onPressed: state.canGoForward ? viewModel.goToNextPhase : null,
    );
  }

  Future<void> _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar')),
        ],
      ),
    );
    if (confirmed == true) {
      onConfirm();
    }
  }

  Future<void> _showProductionInputDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Finalizar Cultivo'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Ingresa la producción total obtenida (en toneladas).'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      const InputDecoration(labelText: 'Producción (Tn)'),
                  validator: (v) =>
                      (v == null || v.isEmpty || double.tryParse(v) == null)
                          ? 'Número inválido'
                          : null,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            FilledButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final production = double.parse(controller.text);
                  Navigator.of(dialogContext).pop();
                  await viewModel.finishCropCommand.execute(production);
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}
