import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class ChargingScreenSectionTitle extends StatelessWidget {
  const ChargingScreenSectionTitle({super.key, required this.title});

  @protected
  final String title;

  @protected
  static const kTextStyle = TextStyle(
    height: 1.21,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: StadiumBorder(
              side: BorderSide(
                color: context.colors.border,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                title,
                style: kTextStyle.copyWith(
                  color: context.colors.text,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
