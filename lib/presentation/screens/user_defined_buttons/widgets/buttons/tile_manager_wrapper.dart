import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class TileModel {
  const TileModel(this.id);

  final int id;
}

class TilesManagerWrapper<T extends TileModel> extends StatefulWidget {
  const TilesManagerWrapper({
    super.key,
    this.initialCount = 0,
    required this.tileModelBuilder,
    required this.widgetMapper,
    this.customViewBuilder,
    this.bottom,
    this.initialTiles = const [],
    this.notifier,
  });

  @protected
  final int initialCount;

  @protected
  final Widget Function(
    int index,
    T object,
    void Function() deleteCallback,
  ) widgetMapper;

  @protected
  final List<T> initialTiles;

  @protected
  final ValueNotifier<List<T>>? notifier;

  @protected
  final T Function(int index) tileModelBuilder;

  @protected
  final Widget Function(VoidCallback generateNewTile, int itemsCount)? bottom;

  @protected
  final ValueWidgetBuilder<List<Widget>>? customViewBuilder;

  @override
  State<TilesManagerWrapper<T>> createState() => _TilesManagerWrapperState<T>();
}

class _TilesManagerWrapperState<T extends TileModel>
    extends State<TilesManagerWrapper<T>> {
  late final ValueNotifier<List<T>> valueNotifier;

  @override
  void initState() {
    valueNotifier = widget.notifier ?? ValueNotifier([]);
    valueNotifier.value = widget.initialTiles;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addNewTiles(widget.initialCount - widget.initialTiles.length);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.notifier == null) valueNotifier.dispose();
    super.dispose();
  }

  void addNewTiles([int count = 1]) {
    final tiles = <T>[];
    for (var i = 0; i < count; i++) {
      tiles.add(widget.tileModelBuilder(i));
    }

    valueNotifier.value = [
      ...valueNotifier.value,
      ...tiles,
    ];
  }

  void deleteCallback(int id) {
    valueNotifier.value =
        valueNotifier.value.whereNot((element) => element.id == id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Column(
          children: [
            ...List<Widget>.generate(
              value.length,
              (index) => widget.widgetMapper(index, value[index], () {
                deleteCallback(value[index].id);
              }),
            ).divideBy(const Divider()),
            widget.bottom?.call(addNewTiles, value.length) ??
                const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
