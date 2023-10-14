import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class ChargingScreenSectionSubitle extends StatelessWidget {
  const ChargingScreenSectionSubitle({
    super.key,
    required this.subtitle,
  });

  @protected
  final String subtitle;

  @protected
  static const kTextStyle = TextStyle(
    height: 1.2,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Text(
          subtitle,
          style: kTextStyle.copyWith(color: context.colors.text),
        ),
      ),
    );
  }
}
