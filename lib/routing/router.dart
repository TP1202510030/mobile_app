import 'package:go_router/go_router.dart';
import 'package:mobile_app/ui/home/view_models/home_viewmodel.dart';

import '../ui/home/widgets/home_screen.dart';
import 'routes.dart';

/// Top go_router entry point.
GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            final viewModel = HomeViewModel();
            return HomeScreen(viewModel: viewModel);
          },
        ),
      ],
    );
