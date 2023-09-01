import 'package:flutter/cupertino.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';

class NumValueGetterSwitcherInputFieldWidget extends StatefulWidget {
  const NumValueGetterSwitcherInputFieldWidget({
    super.key,
    required this.onValueChanged,
    required this.groupValue,
  });

  @protected
  final ValueSetter<bool> onValueChanged;

  @protected
  final bool groupValue;

  @override
  State<NumValueGetterSwitcherInputFieldWidget> createState() =>
      _NumValueGetterSwitcherInputFieldWidgetState();
}

class _NumValueGetterSwitcherInputFieldWidgetState
    extends State<NumValueGetterSwitcherInputFieldWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onValueChanged(widget.groupValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<bool>(
      children: {
        true: Text(context.l10n.displaySwitcherButtonCaption),
        false: Text(context.l10n.dontDisplaySwitcherButtonCaption),
      },
      onValueChanged: (value) {
        if (value == null) return;
        widget.onValueChanged(value);
      },
      groupValue: widget.groupValue,
    );
  }
}
