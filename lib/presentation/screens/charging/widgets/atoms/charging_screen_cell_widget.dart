import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class ChargingScreenCellWidget extends StatelessWidget {
  const ChargingScreenCellWidget({
    super.key,
    required this.number,
    required this.content,
  });

  @protected
  final int number;

  @protected
  final String content;

  static const kRadius = Radius.circular(6);

  @protected
  static const kNumberTextStyle = TextStyle(
    height: 1.21,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  @protected
  static const kContentTextStyle = TextStyle(
    height: 1.21,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(kRadius),
        border: Border.all(
          color: context.colors.successPastel,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: kRadius),
              color: context.colors.successPastel,
            ),
            child: Text(
              '#$number',
              textAlign: TextAlign.center,
              style: kNumberTextStyle.copyWith(
                color: context.colors.disabled,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  content,
                  style: kContentTextStyle.copyWith(color: context.colors.text),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
