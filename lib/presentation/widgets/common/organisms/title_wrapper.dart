import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';

class TitleWrapper extends StatelessWidget {
  const TitleWrapper({
    super.key,
    required this.title,
    required this.body,
  });

  @protected
  final String title;

  @protected
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);

    final titlePadding = screenData.whenType(
      orElse: () => const EdgeInsets.only(left: 32, top: 37),
      handset: () => EdgeInsets.zero,
    );
    final bodyPadding = screenData.whenType(
      orElse: () => EdgeInsets.only(
        left: !screenData.type.isHandset && screenData.size.width > 700
            ? 190
            : 100,
        right: 32,
        bottom: 16,
      ),
      handset: () => EdgeInsets.zero,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: titlePadding,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: bodyPadding,
            child: body,
          ),
        ),
      ],
    );
  }
}
