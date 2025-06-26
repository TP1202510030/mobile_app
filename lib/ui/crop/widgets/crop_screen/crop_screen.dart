import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/button.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/crop/view_models/active_crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/sensors_section.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/actuators_section.dart';

class CropScreen extends StatelessWidget {
  final ActiveCropViewModel viewModel;

  const CropScreen({super.key, required this.viewModel});

  List<OptionItemData> _getHorizontalOptions(ActiveCropViewModel viewModel) => [
        OptionItemData(
          title: "Sensores",
          onTap: () => viewModel.selectSection(0),
          iconPath: AppIcons.sensor,
        ),
        OptionItemData(
          title: "Actuadores",
          onTap: () => viewModel.selectSection(1),
          iconPath: AppIcons.actuator,
        ),
      ];

  Widget _getCurrentSectionWidget(
      int selectedIndex, ActiveCropViewModel viewModel) {
    switch (selectedIndex) {
      case 0:
        return SensorsSection(viewModel: viewModel);
      case 1:
        return ActuatorsSection(viewModel: viewModel);
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context, String title,
      String content, VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
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
                    'Ingresa la producción total obtenida en este cultivo (en toneladas).'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Producción (Tn)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, ingresa un número válido.';
                    }
                    return null;
                  },
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

                  final bool success = await viewModel.finishCrop(production);

                  if (success && context.mounted) {
                    context.go(Routes.home);
                  }
                }
              },
              child: const Text('Confirmar y Finalizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          return Column(
            children: [
              _buildPhaseNavigator(context),
              const SizedBox(height: 16),
              HorizontalOptionList(
                options: _getHorizontalOptions(viewModel),
                initialIndex: viewModel.selectedSectionIndex,
                onItemSelected: (index) {
                  viewModel.selectSection(index);
                },
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _getCurrentSectionWidget(
                    viewModel.selectedSectionIndex, viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPhaseNavigator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: viewModel.canGoBack ? viewModel.goToPreviousPhase : null,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Fase: ${viewModel.selectedPhase?.name ?? 'Cargando...'}",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (viewModel.isCurrentActivePhase)
          SizedBox(
            width: 150,
            child: CustomButton(
              onTap: () {
                if (viewModel.isLastPhase) {
                  _showProductionInputDialog(context);
                } else {
                  _showConfirmationDialog(
                      context,
                      "Finalizar Fase",
                      '¿Estás seguro de que deseas avanzar a la siguiente fase?',
                      viewModel.advancePhase);
                }
              },
              child: Text(
                viewModel.isLastPhase ? 'Finalizar Cultivo' : 'Finalizar Fase',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: viewModel.canGoForward ? viewModel.goToNextPhase : null,
          ),
      ],
    );
  }
}
