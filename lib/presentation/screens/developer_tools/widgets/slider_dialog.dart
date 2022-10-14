import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';

class SliderDialog extends StatefulWidget {
  const SliderDialog({
    super.key,
    required this.initialValue,
    this.maxValueInMillis = 10000,
    required this.title,
  });

  @protected
  final int initialValue;

  @protected
  final int maxValueInMillis;

  @protected
  final String title;

  @override
  State<SliderDialog> createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  late double newValue;

  @override
  void initState() {
    super.initState();
    newValue = widget.initialValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: newValue,
            max: widget.maxValueInMillis.toDouble(),
            onChanged: (value) {
              setState(() {
                newValue = value;
              });
            },
          ),
          Text('${newValue.toInt()}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n.cancelButtonCaption),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop<int>(newValue.toInt());
          },
          child: Text(context.l10n.saveButtonCaption),
        )
      ],
    );
  }
}
