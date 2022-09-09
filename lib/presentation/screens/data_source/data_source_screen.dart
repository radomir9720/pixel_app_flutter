import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';

class DataSourceScreen extends StatelessWidget {
  const DataSourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: const Center(
        child: Text('Data Source Screen'),
      ),
    );
  }
}
