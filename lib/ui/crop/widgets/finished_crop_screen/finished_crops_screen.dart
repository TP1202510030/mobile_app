import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/empty_state.dart';
import 'package:mobile_app/ui/core/ui/search_bar.dart';
import 'package:mobile_app/ui/crop/ui/finished_crop_card.dart';
import 'package:mobile_app/ui/crop/view_models/finished_crops_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/core/locator.dart';

class FinishedCropsScreen extends StatelessWidget {
  final int growRoomId;

  const FinishedCropsScreen({super.key, required this.growRoomId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<FinishedCropsViewModel>(param1: growRoomId),
      child: Consumer<FinishedCropsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          }

          final crops = viewModel.finishedCrops;

          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.growRoomName,
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  CustomSearchBar(
                    controller: viewModel.searchController,
                    hintText: 'Buscar por ID de cultivo...',
                    onChanged: (_) {},
                    onClear: () => viewModel.setSearchQuery(''),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 24),
                  if (crops.isEmpty && viewModel.searchQuery.isNotEmpty)
                    Expanded(
                      child: EmptyState(
                          message:
                              "No se encontró el cultivo #${viewModel.searchQuery}",
                          iconAsset: AppIcons.mushroom),
                    )
                  else if (crops.isEmpty)
                    const Expanded(
                      child: EmptyState(
                          message: "No hay cultivos finalizados",
                          iconAsset: AppIcons.mushroom),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: crops.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) =>
                            FinishedCropCard(crop: crops[index]),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
