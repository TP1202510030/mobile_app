import 'package:flutter/material.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Text('Home Screen',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
