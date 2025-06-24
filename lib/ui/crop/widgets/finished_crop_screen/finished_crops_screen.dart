import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/domain/models/grow_room/crop.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crops_viewmodel.dart';

class FinishedCropsScreen extends StatelessWidget {
  final FinishedCropsViewModel viewModel;

  const FinishedCropsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(child: Text(viewModel.error!));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                viewModel.growRoomName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              // Sección de la barra de búsqueda y botón de filtro
              _SearchBarSection(viewModel: viewModel),
              const SizedBox(height: 24),

              // Lista de cultivos o mensaje si está vacía
              if (viewModel.finishedCrops.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No hay cultivos finalizados para mostrar.'),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: viewModel.finishedCrops.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final crop = viewModel.finishedCrops[index];
                      return _FinishedCropCard(crop: crop);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget para la barra de búsqueda y el botón de filtro.
class _SearchBarSection extends StatelessWidget {
  final FinishedCropsViewModel viewModel;

  const _SearchBarSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: viewModel.searchController,
            decoration: InputDecoration(
              hintText: 'Buscar cultivo...',
              prefixIcon: const Icon(Icons.search),
              // Muestra un botón para limpiar el texto si no está vacío
              suffixIcon: viewModel.searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => viewModel.searchController.clear(),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget de tarjeta para mostrar la información de un cultivo finalizado.
class _FinishedCropCard extends StatelessWidget {
  final Crop crop;

  const _FinishedCropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDate = dateFormat.format(crop.startDate);
    final endDate =
        crop.endDate != null ? dateFormat.format(crop.endDate!) : 'N/A';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cultivo #${crop.id}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          // Fila para la información de fechas
          _CardInfoRow(
            materialIcon: Icons.calendar_today_outlined,
            text: '$startDate - $endDate',
          ),
          const SizedBox(height: 8),
          // Fila para la información de producción (con datos de ejemplo)
          _CardInfoRow(
            svgIconPath: AppIcons.co2, // Ícono de la captura de pantalla
            text: 'Producción total: 24 T', // Dato de ejemplo de la captura
          ),
        ],
      ),
    );
  }
}

/// Widget reutilizable para una fila con un ícono y texto dentro de la tarjeta.
class _CardInfoRow extends StatelessWidget {
  final String? svgIconPath;
  final IconData? materialIcon;
  final String text;

  const _CardInfoRow({
    this.svgIconPath,
    this.materialIcon,
    required this.text,
  }) : assert(svgIconPath != null || materialIcon != null,
            'Se debe proveer un svgIconPath o un materialIcon.');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (svgIconPath != null)
          SvgPicture.asset(
            svgIconPath!,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          )
        else
          Icon(
            materialIcon,
            size: 20.0,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
