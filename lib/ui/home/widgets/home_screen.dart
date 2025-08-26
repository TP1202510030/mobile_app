import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/horizontal_option_list.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';
import 'package:mobile_app/ui/home/widgets/archive_section.dart';
import 'package:mobile_app/ui/home/widgets/grow_rooms_section.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  Widget _getCurrentSectionWidget(int selectedIndex, HomeViewModel viewModel) {
    switch (selectedIndex) {
      case 0:
        return GrowRoomSection(viewModel: viewModel);
      case 1:
        return ArchiveSection(viewModel: viewModel);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();
    final DateFormat formatter = DateFormat("dd 'de' MMMM, y", 'es_ES');
    final String formattedDate = formatter.format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              formattedDate,
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
                onItemSelected: viewModel.selectTab,
              );
            },
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.error != null) {
                  return Center(child: Text(viewModel.error!));
                }
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
