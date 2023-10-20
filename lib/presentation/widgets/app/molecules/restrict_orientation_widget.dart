import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

abstract class RestrictOrientationConfig {
  List<DeviceOrientation>? onInit(BuildContext context);

  List<DeviceOrientation>? onDispose();

  static const portraitOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  static const landscapeOrientations = [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];
}

class RestrictOrientationWidget extends SingleChildStatefulWidget {
  const RestrictOrientationWidget({
    super.key,
    required this.config,
    super.child,
  });

  @protected
  final RestrictOrientationConfig config;

  @override
  State<RestrictOrientationWidget> createState() =>
      _RestrictOrientationWidgetState();
}

class _RestrictOrientationWidgetState
    extends SingleChildState<RestrictOrientationWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final orientations = widget.config.onInit(context);
      if (orientations != null) {
        SystemChrome.setPreferredOrientations(orientations);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    final orientations = widget.config.onDispose();
    if (orientations != null) {
      SystemChrome.setPreferredOrientations(orientations);
    }
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return child ?? const SizedBox.shrink();
  }
}

final class RestrictLandscapeOnInsufficientWidthOrientationConfig
    implements RestrictOrientationConfig {
  const RestrictLandscapeOnInsufficientWidthOrientationConfig({
    required this.minWidth,
  });

  const RestrictLandscapeOnInsufficientWidthOrientationConfig.w500()
      : minWidth = 500;

  @protected
  final double minWidth;

  @override
  List<DeviceOrientation>? onInit(BuildContext context) {
    final mq = (context
            .getElementForInheritedWidgetOfExactType<MediaQuery>()!
            .widget as MediaQuery)
        .data;

    final size = mq.size;
    final orientation = mq.orientation;
    final width =
        orientation == Orientation.landscape ? size.height : size.width;
    final enable = width < minWidth;

    return enable ? RestrictOrientationConfig.portraitOrientations : null;
  }

  @override
  List<DeviceOrientation>? onDispose() => [];
}
