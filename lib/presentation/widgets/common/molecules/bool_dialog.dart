import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';

class BoolDialog extends StatelessWidget {
  const BoolDialog({
    super.key,
    required this.title,
    this.content,
  });

  @protected
  final String title;

  @protected
  final String? content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content == null ? null : Text(content ?? ''),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(context.l10n.noButtonCaption),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop<bool>(true);
          },
          child: Text(context.l10n.yesButtonCaption),
        ),
      ],
    );
  }
}
