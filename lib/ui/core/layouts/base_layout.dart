import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/routing/routes.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';
import 'package:mobile_app/ui/core/themes/icons.dart';
import 'package:mobile_app/ui/core/ui/bottom_navigation_bar.dart';

class BaseLayout extends StatefulWidget {
  final Widget body;

  const BaseLayout({super.key, required this.body});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    AppSizes().initSizes(context);

    final currentRoute = GoRouterState.of(context).uri.toString();

    if (currentRoute == Routes.notifications) {
      _currentIndex = 0;
    } else if (currentRoute == Routes.home) {
      _currentIndex = 1;
    } else if (currentRoute == Routes.cropsArchive) {
      _currentIndex = 2;
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.body,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: CustomBottomNavigationBar(
                items: const [
                  NavigationBarItem(
                    icon: AppIcons.bell,
                    hasNotification: true,
                  ),
                  NavigationBarItem(
                    icon: AppIcons.home,
                    hasNotification: false,
                  ),
                  NavigationBarItem(
                    icon: AppIcons.cropsArchive,
                    hasNotification: false,
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });

                  if (index == 0) {
                    context.go(Routes.notifications);
                  } else if (index == 1) {
                    context.go(Routes.home);
                  } else if (index == 2) {
                    context.go(Routes.cropsArchive);
                  }
                },
                currentIndex: _currentIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
