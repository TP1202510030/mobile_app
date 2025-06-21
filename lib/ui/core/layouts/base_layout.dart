import 'package:flutter/material.dart';
import 'package:mobile_app/ui/core/themes/app_sizes.dart';

class BaseLayout extends StatefulWidget {
  final Widget body;
  // ✅ CAMBIO: El título ahora puede ser cualquier Widget.
  final Widget? title;
  final bool showBackButton;
  final List<Widget>? actions;
  // ✅ AÑADIDO: Permite un widget personalizado para el botón de "atrás".
  final Widget? leading;

  const BaseLayout({
    super.key,
    required this.body,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
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
        leading: widget.leading,
        automaticallyImplyLeading:
            widget.leading == null && widget.showBackButton,
        title: widget.title,
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
