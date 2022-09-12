import 'package:flutter/material.dart';

enum CarInterfacePointerSide {
  right,
  left;

  bool get isLeft => this == CarInterfacePointerSide.left;
  bool get isRight => this == CarInterfacePointerSide.right;
}

class CarInterfacePointer extends StatelessWidget {
  const CarInterfacePointer({
    super.key,
    this.pointerLength = 75,
    this.side = CarInterfacePointerSide.right,
    required this.color,
  });

  @protected
  final double pointerLength;

  @protected
  final CarInterfacePointerSide side;

  @protected
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (side == CarInterfacePointerSide.right)
          SizedBox(
            width: pointerLength,
            child: Divider(
              color: color,
              thickness: 1,
            ),
          ),
        SizedBox.square(
          dimension: 4,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: color,
            ),
          ),
        ),
        if (side == CarInterfacePointerSide.left)
          SizedBox(
            width: pointerLength,
            child: Divider(
              color: color,
              thickness: 1,
            ),
          ),
      ],
    );
  }
}
