import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

enum PIconButtonState {
  enabled,
  error;

  bool get isError => this == PIconButtonState.error;
}

enum PIconButtonSize {
  normal,
  big;

  bool get isNormal => this == PIconButtonSize.normal;
}

class PIconButton extends StatelessWidget {
  const PIconButton({
    super.key,
    this.state = PIconButtonState.enabled,
    this.size = PIconButtonSize.normal,
    this.onPressed,
    required this.icon,
  });

  factory PIconButton.error({
    VoidCallback? onPressed,
    required IconData icon,
    PIconButtonSize size = PIconButtonSize.normal,
  }) =>
      PIconButton(
        onPressed: onPressed,
        state: PIconButtonState.error,
        icon: icon,
        size: size,
      );

  @protected
  final IconData icon;

  @protected
  final PIconButtonSize size;

  @protected
  final PIconButtonState state;

  @protected
  final VoidCallback? onPressed;

  @protected
  static const borderRaius = BorderRadius.all(Radius.circular(100));

  @override
  Widget build(BuildContext context) {
    final color = state.isError
        ? AppColors.of(context).error
        : AppColors.of(context).border;
    final padding = size.isNormal ? 9.0 : 11.0;
    final iconSize = size.isNormal ? 14.0 : 18.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRaius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRaius,
            border: Border.all(
              color: color,
              width: 2,
            ),
            color: color.withOpacity(.2),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Icon(icon, size: iconSize),
          ),
        ),
      ),
    );
  }
}
