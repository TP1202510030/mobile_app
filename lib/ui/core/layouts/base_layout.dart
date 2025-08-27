import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showAppBar;

  const BaseLayout({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: title != null ? Text(title!) : null,
              actions: actions,
            )
          : null,
      body: child,
    );
  }
}
