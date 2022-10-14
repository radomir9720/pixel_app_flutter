import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';

class ChangeParametersSubscriptionDialog extends StatefulWidget {
  const ChangeParametersSubscriptionDialog({
    super.key,
    required this.initialValue,
  });

  @protected
  final List<int> initialValue;

  @override
  State<ChangeParametersSubscriptionDialog> createState() =>
      _ChangeParametersSubscriptionDialogState();
}

class _ChangeParametersSubscriptionDialogState
    extends State<ChangeParametersSubscriptionDialog> {
  late Set<int> newValue;
  bool showCustomIdTextField = false;
  String textFieldValue = '';

  @override
  void initState() {
    super.initState();
    newValue = {...widget.initialValue};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        context.l10n.whichParametersToSubscribeToListTileLabel,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 16,
            children: [
              ...{
                ...ParameterId.all.map((e) => e.value),
                ...newValue,
              }.map((current) {
                // final current = e.value;
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
          const SizedBox(height: 16),
          if (showCustomIdTextField)
            TextField(
              inputFormatters: [OnlyNumbersInputFormatter()],
              onChanged: (value) {
                textFieldValue = value;
              },
              decoration: InputDecoration(
                label: Text(context.l10n.enterParameterIdTextFieldLabel),
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

                    if (integer < 0 || integer > 0xFFFF) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.parameterIdLimitsMessage,
                          ),
                        ),
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
              child: Text(context.l10n.addCustomIdButtonCaption),
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
        )
      ],
    );
  }
}

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
