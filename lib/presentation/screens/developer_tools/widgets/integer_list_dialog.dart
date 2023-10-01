import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';

class OnlyNumbersInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    } else if (RegExp(r'^([0-9]*)+$').hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class IntegerListDialog extends StatefulWidget {
  const IntegerListDialog({
    super.key,
    required this.title,
    required this.alwasysVisibleOptions,
    required this.initialChoosedOptions,
    this.validator,
  });

  @protected
  final String title;

  @protected
  final List<int> alwasysVisibleOptions;

  @protected
  final List<int> initialChoosedOptions;

  @protected
  final String? Function(int)? validator;

  @override
  State<IntegerListDialog> createState() => _IntegerListDialogState();
}

class _IntegerListDialogState extends State<IntegerListDialog> {
  late Set<int> newValue;
  bool showCustomIdTextField = false;
  String textFieldValue = '';

  @override
  void initState() {
    super.initState();
    newValue = {...widget.initialChoosedOptions};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ...{
                    ...widget.alwasysVisibleOptions,
                    ...newValue,
                  }.map((current) {
                    return FilterChip(
                      label: Text('$current'),
                      showCheckmark: false,
                      selected: newValue.contains(current),
                      onSelected: (selected) {
                        if (selected) {
                          newValue.add(current);
                        } else {
                          newValue.remove(current);
                        }
                        setState(() {});
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (showCustomIdTextField)
            TextField(
              inputFormatters: [OnlyNumbersInputFormatter()],
              onChanged: (value) {
                textFieldValue = value;
              },
              decoration: InputDecoration(
                label: Text(context.l10n.enterValueIntegerDialogTextFieldLabel),
                suffixIcon: IconButton(
                  onPressed: () {
                    final integer = int.tryParse(textFieldValue);

                    if (integer == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.errorParsingIntegerValueMessage,
                          ),
                        ),
                      );
                      return;
                    }

                    final error = widget.validator?.call(integer);
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                      return;
                    }

                    newValue.add(integer);

                    setState(() => showCustomIdTextField = false);
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                setState(() => showCustomIdTextField = true);
              },
              child:
                  Text(context.l10n.addCustomValueIntegerDialogButtonCaption),
            ),
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
            Navigator.of(context).pop<List<int>>(newValue.toList());
          },
          child: Text(context.l10n.saveButtonCaption),
        ),
      ],
    );
  }
}
