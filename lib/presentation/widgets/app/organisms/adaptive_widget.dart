import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

enum ScreenType {
  desktop,
  tablet,
  handset,
}

class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({
    super.key,
    required this.child,
    this.desktopSize = 900,
    this.tabletSize = 600,
    this.handsetSize = 300,
  });

  @protected
  final Widget child;

  @protected
  final double desktopSize;

  @protected
  final double tabletSize;

  @protected
  final double handsetSize;

  static ScreenData of(BuildContext context, {bool watch = true}) {
    final getInheritedElement = context.getElementForInheritedWidgetOfExactType;
    final inheritedAdapriveWidget = getInheritedElement<InheritedScreenData>();

    if (inheritedAdapriveWidget == null) {
      throw FlutterError(
        'AdaptiveWidget.of(context) called with a context that does not '
        'contain a ScreenData',
      );
    }

    if (watch) {
      context.dependOnInheritedElement(inheritedAdapriveWidget);
    }

    return (inheritedAdapriveWidget.widget as InheritedScreenData).data;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final shortestSize = size.shortestSide;
        final screenType = shortestSize > desktopSize
            ? ScreenType.desktop
            : shortestSize > tabletSize
                ? ScreenType.tablet
                : ScreenType.handset;

        return OrientationBuilder(
          builder: (context, orientation) {
            return InheritedScreenData(
              data: ScreenData(
                size: size,
                type: screenType,
                orientation: orientation,
              ),
              child: child,
            );
          },
        );
      },
    );
  }
}

@immutable
class ScreenData {
  const ScreenData({
    required this.size,
    required this.type,
    required this.orientation,
  });

  final Size size;

  final ScreenType type;

  final Orientation orientation;

  R whenType<R>({
    required R Function(Size size, Orientation orientation) orElse,
    R Function(Size size, Orientation orientation)? desktop,
    R Function(Size size, Orientation orientation)? tablet,
    R Function(Size size, Orientation orientation)? handset,
  }) {
    switch (type) {
      case ScreenType.desktop:
        return desktop?.call(size, orientation) ?? orElse(size, orientation);
      case ScreenType.tablet:
        return tablet?.call(size, orientation) ?? orElse(size, orientation);
      case ScreenType.handset:
        return handset?.call(size, orientation) ?? orElse(size, orientation);
    }
  }

  @override
  bool operator ==(dynamic other) {
    return other is ScreenData &&
        size == other.size &&
        type == other.type &&
        orientation == other.orientation;
  }

  @override
  int get hashCode => hashValues(
        type.hashCode,
        size.hashCode,
        orientation.hashCode,
      );
}

@protected
class InheritedScreenData extends InheritedWidget {
  @literal
  const InheritedScreenData({
    required super.child,
    required this.data,
    super.key,
  });
  @protected
  final ScreenData data;

  @override
  bool updateShouldNotify(InheritedScreenData oldWidget) {
    return data != oldWidget.data;
  }
}
