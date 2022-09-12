import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/fade_shader.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/measure_size.dart';
import 'package:re_seedwork/re_seedwork.dart';

@protected
enum FastActionWidgetMode {
  manyRows,
  oneRow;

  bool get isManyRows => this == FastActionWidgetMode.manyRows;
}

class FastActionsWidget extends StatefulWidget {
  const FastActionsWidget._({
    super.key,
    this.buttonsCnt = 6,
    this.itemsInOneRowCnt = 3,
    required this.mode,
  });

  factory FastActionsWidget.oneRow({
    Key? key,
    int buttonsCnt = 6,
  }) {
    return FastActionsWidget._(
      key: key,
      buttonsCnt: buttonsCnt,
      mode: FastActionWidgetMode.oneRow,
    );
  }

  factory FastActionsWidget.manyRows({
    Key? key,
    int buttonsCnt = 6,
    int itemsInOneRowCnt = 3,
  }) {
    return FastActionsWidget._(
      key: key,
      buttonsCnt: buttonsCnt,
      itemsInOneRowCnt: itemsInOneRowCnt,
      mode: FastActionWidgetMode.manyRows,
    );
  }

  @protected
  final int buttonsCnt;

  @protected
  final int itemsInOneRowCnt;

  @protected
  final FastActionWidgetMode mode;

  @override
  State<FastActionsWidget> createState() => _FastActionsWidgetState();
}

class _FastActionsWidgetState extends State<FastActionsWidget> {
  double manyRowsWidgetWidth = 0;

  Set<int> selectedIndexes = {};

  void _onSelected(int index, bool selected) {
    if (mounted) {
      if (selected) {
        selectedIndexes.add(index);
      } else {
        selectedIndexes.remove(index);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.fastActionsInfoPanelTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
            //
            const SizedBox(height: 16),
            //
            if (widget.mode.isManyRows &&
                manyRowsWidgetWidth <= constraints.maxWidth)
              UnconstrainedBox(
                child: MeasureSize(
                  onChange: (size) {
                    if (size.width != manyRowsWidgetWidth) {
                      manyRowsWidgetWidth = size.width;
                      setState(() {});
                    }
                  },
                  child: Opacity(
                    opacity: manyRowsWidgetWidth == 0 ? 0 : 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(
                        widget.buttonsCnt ~/ widget.itemsInOneRowCnt,
                        (index) {
                          final indexRow = index + 1;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List<Widget>.generate(
                              widget.itemsInOneRowCnt,
                              (index) {
                                final indexItem = (index + 1) +
                                    ((indexRow - 1) * widget.itemsInOneRowCnt);

                                return FilterChip(
                                  label: Text(
                                    context.l10n.actionSwitchTitle(indexItem),
                                  ),
                                  showCheckmark: false,
                                  onSelected: (selected) =>
                                      _onSelected(indexItem, selected),
                                  selected: selectedIndexes.contains(indexItem),
                                );
                              },
                            ).divideBy(const SizedBox(width: 16)).toList(),
                          );
                        },
                      ).divideBy(const SizedBox(height: 16)).toList(),
                    ),
                  ),
                ),
              )
            else
              // One row mode
              FadeScrollableShaderMask(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List<Widget>.generate(widget.buttonsCnt, (index) {
                    return FilterChip(
                      label: Text(context.l10n.actionSwitchTitle(index + 1)),
                      showCheckmark: false,
                      onSelected: (selected) => _onSelected(index, selected),
                      selected: selectedIndexes.contains(index),
                    );
                  }).divideBy(const SizedBox(width: 16)).toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class FadeScrollableShaderMask extends StatefulWidget {
  const FadeScrollableShaderMask({
    super.key,
    required this.child,
    required this.scrollDirection,
  });

  @protected
  final Widget child;

  @protected
  final Axis scrollDirection;

  @override
  State<FadeScrollableShaderMask> createState() =>
      _FadeScrollableShaderMaskState();
}

class _FadeScrollableShaderMaskState extends State<FadeScrollableShaderMask> {
  late final ScrollController controller;

  final enableStartShadeNotifier = ValueNotifier(false);
  final enableEndShadeNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(onPositionChanged);
  }

  void onPositionChanged() {
    final enableStart = enableStartShadeNotifier.value;
    final enableEnd = enableEndShadeNotifier.value;

    if (controller.offset <= 0) {
      if (enableStart) enableStartShadeNotifier.value = false;
    } else if (controller.offset >= controller.position.maxScrollExtent) {
      if (enableEnd) enableEndShadeNotifier.value = false;
    } else {
      if (!enableStart || !enableEnd) {
        enableEndShadeNotifier.value = true;
        enableStartShadeNotifier.value = true;
      }
    }
  }

  @override
  void dispose() {
    controller
      ..removeListener(onPositionChanged)
      ..dispose();
    enableEndShadeNotifier.dispose();
    enableStartShadeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeShader(
      enable: enableEndShadeNotifier,
      side: FadeSide.right,
      child: FadeShader(
        enable: enableStartShadeNotifier,
        side: FadeSide.left,
        child: SingleChildScrollView(
          scrollDirection: widget.scrollDirection,
          controller: controller,
          child: widget.child,
        ),
      ),
    );
  }
}
