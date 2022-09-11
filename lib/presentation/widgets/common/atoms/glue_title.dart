import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

enum GlueTitleSide {
  left,
  right,
  bottom;

  bool get isLeft => this == GlueTitleSide.left;
  bool get isRight => this == GlueTitleSide.right;
  bool get isBottom => this == GlueTitleSide.bottom;
}

class GlueTitle extends StatelessWidget {
  const GlueTitle({
    super.key,
    required this.widget,
    required this.title,
    required this.side,
    this.alignment = Alignment.center,
    this.gap = 8,
  });

  @protected
  final Widget widget;

  @protected
  final String title;

  @protected
  final GlueTitleSide side;

  @protected
  final double gap;

  @protected
  final Alignment alignment;

  @protected
  static const textStyle = TextStyle(
    fontSize: 11,
    height: 1.21,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      title,
      style: textStyle.copyWith(
        color: AppColors.of(context).text,
      ),
    );

    return Align(
      alignment: alignment,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (side.isLeft) textWidget,
              Padding(
                padding: EdgeInsets.only(
                  left: side.isLeft ? gap : 0,
                  right: side.isRight ? gap : 0,
                  bottom: side.isBottom ? gap : 0,
                ),
                child: widget,
              ),
              if (side.isRight) textWidget,
            ],
          ),
          if (side.isBottom) textWidget,
        ],
      ),
    );
  }
}
