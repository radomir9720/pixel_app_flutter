import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:re_seedwork/re_seedwork.dart';

class ExchangeLogCard extends StatelessWidget {
  const ExchangeLogCard._({
    this.event,
    this.package,
    required this.dateTime,
  }) : assert(
          (event == null) != (package == null),
          'Either "package" must be not null, or "event"',
        );

  factory ExchangeLogCard.fromDataSourceEvent({
    required DataSourceEvent event,
    required DateTime dateTime,
  }) =>
      ExchangeLogCard._(
        event: event,
        dateTime: dateTime,
      );

  factory ExchangeLogCard.fromPackage({
    required List<int> package,
    required DateTime dateTime,
  }) =>
      ExchangeLogCard._(
        package: package,
        dateTime: dateTime,
      );

  @protected
  final DataSourceEvent? event;

  @protected
  final List<int>? package;

  @protected
  final DateTime dateTime;

  R whenDirection<R>(
    int? direction, {
    required R Function() incoming,
    required R Function() outgoing,
    required R Function(int? directionId) unknown,
  }) {
    switch (direction) {
      case 0:
        return outgoing();
      case 1:
        return incoming();
      default:
        return unknown(direction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _package = ArgumentError.checkNotNull(
      event?.toPackage() ?? package,
      '_package',
    );

    final instanceOrNull = DataSourcePackage.instanceOrNUll(package ?? []);

    final direction = event?.requestDirection ?? instanceOrNull?.directionFlag;

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
                  whenDirection(
                    direction,
                    incoming: () => context.l10n.incomingListTileLabel,
                    outgoing: () => context.l10n.outgoingListTileLabel,
                    unknown: (id) => 'Unknown${id == null ? '' : ': "$id"'}',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  whenDirection(
                    direction,
                    incoming: () => Icons.arrow_circle_left,
                    outgoing: () => Icons.arrow_circle_right,
                    unknown: (id) => Icons.question_mark,
                  ),
                  color: whenDirection(
                    direction,
                    incoming: () => AppColors.of(context).successPastel,
                    outgoing: () => AppColors.of(context).primaryAccent,
                    unknown: (id) => AppColors.of(context).errorAccent,
                  ),
                ),
              ],
            ),
          ),
          _ExchangeLogCardListTile(
            title: context.l10n.timeListTileLabel,
            trailing: Text(DateFormat('HH:mm:ss.SSS').format(dateTime)),
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
                      _package.length,
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
                    ..._package.map(
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
                    ..._package.map(
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
