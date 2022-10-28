import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/fade_shader.dart';

class ShadeScrollable extends StatefulWidget {
  const ShadeScrollable({
    super.key,
    this.axis = Axis.vertical,
    required this.scrollable,
  });

  @protected
  final Axis axis;

  @protected
  final Widget Function(ScrollController controller) scrollable;

  @override
  State<ShadeScrollable> createState() => _ShadeScrollableState();
}

class _ShadeScrollableState extends State<ShadeScrollable> {
  late final ScrollController controller;

  final enableFadeSideChangeNotifier = EnableFadeSideChangeNotifier(
    const EnableFadeSideState(
      enableStart: false,
      enableEnd: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(onPositionChanged);
  }

  void onPositionChanged() {
    final enableStart = enableFadeSideChangeNotifier.value.enableStart;
    final enableEnd = enableFadeSideChangeNotifier.value.enableEnd;

    if (controller.offset <= 0) {
      if (enableStart) enableFadeSideChangeNotifier.update(enableStart: false);
    } else if (controller.offset >= controller.position.maxScrollExtent) {
      if (enableEnd) enableFadeSideChangeNotifier.update(enableEnd: false);
    } else {
      if (!enableStart || !enableEnd) {
        enableFadeSideChangeNotifier
          ..update(enableStart: true)
          ..update(enableEnd: true);
      }
    }
  }

  @override
  void dispose() {
    controller
      ..removeListener(onPositionChanged)
      ..dispose();
    enableFadeSideChangeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeShader(
      axis: widget.axis,
      enableFadeSideChangeNotifier: enableFadeSideChangeNotifier,
      child: widget.scrollable(controller),
    );
  }
}

class ShadeListViewBuilder extends ShadeScrollable {
  ShadeListViewBuilder({
    super.key,
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    super.axis,
  }) : super(
          scrollable: (controller) {
            return ListView.builder(
              controller: controller,
              scrollDirection: axis,
              primary: false,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            );
          },
        );
}

class ShadeSingleChildScrollView extends ShadeScrollable {
  ShadeSingleChildScrollView({
    super.key,
    required Widget child,
    super.axis,
  }) : super(
          scrollable: (controller) {
            return SingleChildScrollView(
              controller: controller,
              primary: false,
              scrollDirection: axis,
              child: child,
            );
          },
        );
}
