import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:re_seedwork/re_seedwork.dart';

class ExchangeLogCard extends StatelessWidget {
  const ExchangeLogCard({super.key, required this.item});

  @protected
  final RequestsExchangeLogsEvent item;

  @override
  Widget build(BuildContext context) {
    final package = item.event.toPackage();

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          _ExchangeLogCardListTile(
            title: context.l10n.directionListTileLabel,
            trailing: Row(
              children: [
                Text(
                  item.event.whenDirection(
                    incoming: () => context.l10n.incomingListTileLabel,
                    outgoing: () => context.l10n.outgoingListTileLabel,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  item.event.whenDirection(
                    incoming: () => Icons.arrow_circle_left,
                    outgoing: () => Icons.arrow_circle_right,
                  ),
                  color: item.event.whenDirection(
                    incoming: () => AppColors.of(context).successPastel,
                    outgoing: () => AppColors.of(context).errorAccent,
                  ),
                ),
              ],
            ),
          ),
          _ExchangeLogCardListTile(
            title: context.l10n.timeListTileLabel,
            trailing: Text(DateFormat('HH:mm:ss.SSS').format(item.dateTime)),
          ),
          FittedBox(
            alignment: Alignment.centerLeft,
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              border: TableBorder.symmetric(
                inside: BorderSide(
                  color: AppColors.of(context).border,
                ),
              ),
              children: [
                TableRow(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(4),
                      child: Text(context.l10n.indexListTileLabel),
                    ),
                    ...List.generate(
                      package.length,
                      (index) => Container(
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          '$index',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(4),
                      child: Text(context.l10n.integerListTileLabel),
                    ),
                    ...package.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          '$e',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.all(4),
                      child: Text(context.l10n.hexListTileLabel),
                    ),
                    ...package.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          e.toRadixString(16).padLeft(2, '0').toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ].divideBy(const Divider(height: 12)).toList(),
      ),
    );
  }
}

class _ExchangeLogCardListTile extends StatelessWidget {
  const _ExchangeLogCardListTile({
    required this.title,
    required this.trailing,
  });

  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        const SizedBox(width: 10),
        trailing,
      ],
    );
  }
}
