import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

class BaseLayout extends StatefulWidget {
  final Widget body;
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;

  const BaseLayout({
    super.key,
    required this.body,
    this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  @override
  Widget build(BuildContext context) {
    AppSizes().initSizes(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        title: widget.title != null
            ? Text(
                widget.title!,
                style: Theme.of(context).textTheme.displaySmall,
              )
            : null,
        actions: widget.actions,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.body,
            ),
          ],
        ),
      ),
    );
  }
}
