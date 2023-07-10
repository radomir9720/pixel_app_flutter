import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, this.popable = true});

  @protected
  final bool popable;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: WillPopScope(
        onWillPop: () async => popable,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class NonPopableLoadingScreen extends LoadingScreen {
  const NonPopableLoadingScreen({super.key}) : super(popable: false);
}
