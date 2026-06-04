import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: () {
        if (context.canPop()) {
          context.pop();
          return;
        }
        context.go(AppRoutes.home);
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}
