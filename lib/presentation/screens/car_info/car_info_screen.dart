import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final tabsRouter = AutoTabsRouter.of(context);
    final isHandset = Screen.of(context, watch: false).type.isHandset;

    // If screenType changed from handset to other type, then changing tab to
    // general, as CarInfoScreen should be available only on handset screen type
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (tabsRouter.activeIndex == 1 && !isHandset) {
        tabsRouter.setActiveIndex(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: const Center(
        child: Text('Car Info Screen'),
      ),
    );
  }
}
