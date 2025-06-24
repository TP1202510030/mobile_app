// lib/ui/home/widgets/home_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/colors.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/home/widgets/archive_section.dart'; // 1. Importa la sección de archivo
import 'package:mobile_app/ui/home/widgets/grow_rooms_section.dart';
import '../view_models/home_viewmodel.dart';
import 'package:flutter_svg/svg.dart';

// Nota: He eliminado las clases duplicadas RedDot y NotificationIcon
// que estaban al final del fichero en tu código.

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  // 2. Convierte las opciones en un método que toma el viewModel
  //    para poder llamar a `selectTab`.
  List<OptionItemData> _getHorizontalOptions(HomeViewModel viewModel) => [
        OptionItemData(
          title: "Naves de cultivo",
          onTap: () => viewModel.selectTab(0),
          iconPath: AppIcons.home,
        ),
        OptionItemData(
          title: "Cultivos terminados",
          onTap: () => viewModel.selectTab(1),
          iconPath: AppIcons.cropsArchive,
        ),
      ];

  // 3. Crea un método para devolver el widget de la sección correcta,
  //    igual que en tu ejemplo de CropScreen.
  Widget _getCurrentSectionWidget(int selectedIndex, HomeViewModel viewModel) {
    switch (selectedIndex) {
      case 0:
        return GrowRoomSection(viewModel: viewModel);
      case 1:
        return ArchiveSection(viewModel: viewModel);
      default:
        return const SizedBox.shrink(); // Fallback por si acaso
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              DateTime.now().toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 32),

          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return HorizontalOptionList(
                options: _getHorizontalOptions(viewModel),
                initialIndex: viewModel.selectedTabIndex,
                onItemSelected: (index) => viewModel.selectTab(index),
              );
            },
          ),
          const SizedBox(height: 32),

          // 5. Usa un ListenableBuilder para reconstruir la sección principal
          //    cuando cambie el estado en el viewModel.
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                // Muestra un indicador de carga mientras se obtienen los datos iniciales
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Muestra la sección correspondiente a la pestaña seleccionada
                return _getCurrentSectionWidget(
                    viewModel.selectedTabIndex, viewModel);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
    required this.icon,
    required this.hasNotification,
  });

  final String icon;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32.0,
      height: 32.0,
      child: Stack(
        children: [
          SvgPicture.asset(
            icon,
            width: 32.0,
            height: 32.0,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
          if (hasNotification)
            const Positioned(
              top: 0,
              right: 0,
              child: RedDot(),
            ),
        ],
      ),
    );
  }
}

class RedDot extends StatelessWidget {
  const RedDot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      width: 16,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: AppColors.alert,
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
