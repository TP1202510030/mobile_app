import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/locator.dart';
import 'package:mobile_app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:mobile_app/ui/core/layouts/base_layout.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/core/ui/search_bar.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/ui/home/widgets/archived_crops_section.dart';
import 'package:mobile_app/ui/home/widgets/grow_rooms_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  final _signOutUseCase = locator<SignOutUseCase>();

  @override
  void initState() {
    super.initState();
    _viewModel = locator<HomeViewModel>();
    if (_viewModel.growRooms.isEmpty) {
      _viewModel.fetchInitialGrowRooms();
    }
  }

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
    final DateFormat formatter = DateFormat("dd 'de' MMMM, y", 'es');
    final String formattedDate = formatter.format(DateTime.now());

    return BaseLayout(
      title: 'Bienvenido a Greenhouse',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await _signOutUseCase(null);
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
        child: Column(
          children: [
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSizes.spacingExtraLarge),
            HorizontalOptionList(
              options: _buildTabOptions(),
              initialIndex: _viewModel.selectedTab.index,
              onItemSelected: _viewModel.selectTab,
            ),
            const SizedBox(height: AppSizes.spacingExtraLarge),
            CustomSearchBar(
              hintText: 'Buscar nave...',
              controller: _viewModel.searchController,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSizes.spacingExtraLarge),
            Expanded(
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, child) {
                  switch (_viewModel.selectedTab) {
                    case HomeTab.growRooms:
                      return GrowRoomsSection(viewModel: _viewModel);
                    case HomeTab.archive:
                      return ArchivedCropsSection(viewModel: _viewModel);
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
