import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:re_seedwork/re_seedwork.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
    required this.highlightInTitle,
    required this.fullTitle,
    this.maxLines = 2,
  });

  @protected
  final String highlightInTitle;

  @protected
  final String? fullTitle;

  @protected
  final int maxLines;

  TextSpan hightlightTitlePart({
    required String highlightInTitle,
    required String fullTitle,
    required Color highlightColor,
  }) {
    final title = fullTitle;

    if (highlightInTitle.isEmpty) {
      return TextSpan(text: title);
    }

    final indexes = RegExp(highlightInTitle, caseSensitive: false)
        .allMatches(title)
        .map((e) => [e.start, e.end])
        .expand((element) => element)
        .toList();

    final parts = title.splitByIndexes(indexes);

    return TextSpan(
      children: List.generate(
        parts.length,
        (index) {
          final part = parts[index];
          return TextSpan(
            text: part,
            style: TextStyle(
              backgroundColor:
                  part.toLowerCase() == highlightInTitle.toLowerCase()
                      ? highlightColor
                      : null,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: hightlightTitlePart(
        highlightInTitle: highlightInTitle,
        fullTitle: fullTitle ?? context.l10n.noAppNameCaption,
        highlightColor: AppColors.of(context).primaryAccent,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
