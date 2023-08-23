import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:re_seedwork/re_seedwork.dart';

class ResponsiveGridView extends StatelessWidget {
  const ResponsiveGridView({
    super.key,
    required this.minWidth,
    required this.children,
    this.maxWidth,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
  });

  @protected
  final double minWidth;

  @protected
  final double? maxWidth;

  @protected
  final List<Widget> children;

  @protected
  final double crossAxisSpacing;

  @protected
  final double mainAxisSpacing;

  int getColumnItemsCount({
    required int totalItemsCount,
    required int columnsCount,
    required int columnIndex,
  }) {
    var count = (totalItemsCount / columnsCount).floor();
    final remainder = totalItemsCount % columnsCount;
    if (remainder >= columnIndex + 1) count++;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (children.isEmpty) return const SizedBox.shrink();
        final _maxWidth = maxWidth;

        final screenWidth = constraints.maxWidth;
        var columns = (screenWidth / minWidth).floor();
        columns = columns < 1 ? 1 : columns;
        if (columns > children.length) {
          columns = children.length;
          if (_maxWidth != null) {
            final columnWidth = screenWidth / columns;
            if (columnWidth > _maxWidth) {
              final maxWidthColumns = (screenWidth / _maxWidth).floor();
              columns = maxWidthColumns;
            }
          }
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var c = 0; c < columns; c++)
              Expanded(
                child: Column(
                  children: List.generate(
                    getColumnItemsCount(
                      columnIndex: c,
                      columnsCount: columns,
                      totalItemsCount: children.length,
                    ),
                    (index) {
                      final i = index * columns + c;
                      return children[i];
                    },
                  ).divideBy(SizedBox(height: mainAxisSpacing)).toList(),
                ),
              ),
          ].divideBy(SizedBox(width: crossAxisSpacing)).toList(),
        );
      },
    );
  }
}
