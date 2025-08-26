import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  // Parámetros opcionales para la AppBar, que podrían ser controlados por un ViewModel global o pasados por el router si fuera necesario.
  final String? title;
  final List<Widget>? actions;

  const BaseLayout({
    super.key,
    required this.child,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // El título y las acciones ahora pueden ser dinámicos.
        // Podrías controlar esto con un ViewModel de estado global
        // que cambie el título según la ruta actual.
        title: title != null ? Text(title!) : null,
        actions: actions,
      ),
      body: SafeArea(
        bottom: false,
        child: child,
      ),
    );
  }
}
