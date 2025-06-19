import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/crop/view_models/crop_viewmodel.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/sensors_section.dart';
import 'package:mobile_app/ui/crop/widgets/crop_screen/actuators_section.dart';

class CropScreen extends StatelessWidget {
  final CropViewModel viewModel;

  const CropScreen({super.key, required this.viewModel});

  List<OptionItemData> _getHorizontalOptions(CropViewModel viewModel) => [
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

  Widget _getCurrentSectionWidget(int selectedIndex, CropViewModel viewModel) {
    switch (selectedIndex) {
      case 0:
        return SensorsSection(viewModel: viewModel);
      case 1:
        return const ActuatorsSection();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Fase:",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          AnimatedBuilder(
            animation: viewModel,
            builder: (context, child) {
              return HorizontalOptionList(
                options: _getHorizontalOptions(viewModel),
                initialIndex: viewModel.selectedSectionIndex,
                onItemSelected: (index) {
                  viewModel.selectSection(index);
                },
              );
            },
          ),
          const SizedBox(height: 32),
          Expanded(
            child: AnimatedBuilder(
              animation: viewModel,
              builder: (context, child) {
                return _getCurrentSectionWidget(
                    viewModel.selectedSectionIndex, viewModel);
              },
            ),
          ),
        ],
      ),
    );
  }
}
