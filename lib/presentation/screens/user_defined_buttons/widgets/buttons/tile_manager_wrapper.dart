import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class TileWidget extends Widget {
  const TileWidget(this.id, {super.key});

  final int id;
}

class TilesManagerWrapper extends StatefulWidget {
  const TilesManagerWrapper({
    super.key,
    this.initialCount = 0,
    required this.tileBuilder,
    this.customViewBuilder,
    this.bottom,
  });

  @protected
  final int initialCount;

  @protected
  final TileWidget Function(int index, void Function(int id) deleteCallback)
      tileBuilder;

  @protected
  final Widget Function(VoidCallback generateNewTile, int itemsCount)? bottom;

  @protected
  final ValueWidgetBuilder<List<Widget>>? customViewBuilder;

  @override
  State<TilesManagerWrapper> createState() => _TilesManagerWrapperState();
}

class _TilesManagerWrapperState extends State<TilesManagerWrapper> {
  final valueNotifier = ValueNotifier<List<TileWidget>>([]);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addNewTiles(widget.initialCount);
    });
    super.initState();
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

  void addNewTiles([int count = 1]) {
    final tiles = <TileWidget>[];
    for (var i = 0; i < count; i++) {
      tiles.add(
        widget.tileBuilder(
          i,
          (id) {
            valueNotifier.value = valueNotifier.value
                .whereNot((element) => element.id == id)
                .toList();
          },
        ),
      );
    }

    valueNotifier.value = [
      ...valueNotifier.value,
      ...tiles,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Widget>>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Column(
          children: [
            ...List<Widget>.generate(
              value.length,
              (index) => value[index],
            ).divideBy(const Divider()),
            widget.bottom?.call(addNewTiles, value.length) ??
                const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
