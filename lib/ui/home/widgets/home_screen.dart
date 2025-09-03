import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/core/ui/search_bar.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/ui/home/widgets/archived_crops_section.dart';
import 'package:mobile_app/ui/home/widgets/grow_rooms_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: locator<HomeViewModel>()..fetchInitialGrowRooms(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  List<OptionItemData> _buildTabOptions() {
    return [
      OptionItemData(
        title: 'Naves de cultivo',
        iconPath: AppIcons.home,
      ),
      OptionItemData(
        title: 'Cultivos terminados',
        iconPath: AppIcons.cropsArchive,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final formatter = DateFormat("dd 'de' MMMM, y", 'es');
    final String today = formatter.format(DateTime.now());

    return BaseLayout(
      title: 'Bienvenido a Greenhouse',
      actions: [
        IconButton(
          tooltip: 'Cerrar sesión',
          onPressed: () async {
            await viewModel.signOut();
            locator.resetLazySingleton<HomeViewModel>();
          },
          icon: const Icon(Icons.logout),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
        child: Column(
          children: [
            Text(
              today,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSizes.spacingExtraLarge),
            HorizontalOptionList(
              options: _buildTabOptions(),
              initialIndex: viewModel.selectedTab.index,
              onItemSelected: viewModel.selectTab,
            ),
            const SizedBox(height: AppSizes.spacingExtraLarge),
            CustomSearchBar(
              hintText: 'Buscar nave...',
              controller: viewModel.searchController,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSizes.spacingExtraLarge),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (viewModel.isLoading && viewModel.growRooms.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.error != null && viewModel.growRooms.isEmpty) {
                    return Center(
                      child: Text(viewModel.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          )),
                    );
                  }
                  switch (viewModel.selectedTab) {
                    case HomeTab.growRooms:
                      return GrowRoomsSection(viewModel: viewModel);
                    case HomeTab.archive:
                      return ArchivedCropsSection(viewModel: viewModel);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
