import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/widgets/exchange_log_card.dart';
import 'package:re_widgets/re_widgets.dart';

class PackagesExchangeConsoleScreen extends StatefulWidget {
  const PackagesExchangeConsoleScreen({super.key});

  @override
  State<PackagesExchangeConsoleScreen> createState() =>
      _PackagesExchangeConsoleScreenState();
}

class _PackagesExchangeConsoleScreenState
    extends State<PackagesExchangeConsoleScreen> {
  final typeController = TextEditingController();
  final idController = TextEditingController();
  final dataController = TextEditingController();
  final sentPackagesNotifier = _SentPackagesNotifier();

  @override
  void dispose() {
    typeController.dispose();
    idController.dispose();
    dataController.dispose();
    sentPackagesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.packagesExchangeConsoleScreenTitle),
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(const RequestsExchangeLogsFilterFlow());
            },
            icon: const Icon(Icons.filter_list_alt),
          ),
          BlocBuilder<PauseLogsUpdatingCubit, bool>(
            builder: (context, pause) {
              return IconButton(
                onPressed: () {
                  context.read<PauseLogsUpdatingCubit>().toggle();
                },
                icon: Icon(
                  pause ? Icons.play_arrow : Icons.pause,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<RawRequestsExchangeLogsCubit,
                List<RawRequestsExchangeLogsState>>(
              buildWhen: (previous, current) {
                return !context.read<PauseLogsUpdatingCubit>().state;
              },
              builder: (context, state) {
                final filter =
                    context.watch<RequestsExchangeLogsFilterCubit>().state;
                final items = state
                    .where(
                      (element) => element.filter(
                        parameterId: filter.parameterId,
                        requestType: filter.requestType,
                        direction: filter.direction,
                      ),
                    )
                    .toList();

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  reverse: true,
                  itemBuilder: (context, index) {
                    final reverseIndex = items.length - index - 1;

                    final item = items[reverseIndex];

                    return ExchangeLogCard.fromBytes(
                      bytes: item.data,
                      dateTime: item.dateTime,
                      direction: item.direction,
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _PackageTextFiled(
                      hint: context.l10n.requestTypeHint,
                      controller: typeController,
                    ),
                    _PackageTextFiled(
                      hint: context.l10n.parameterIDHint,
                      controller: idController,
                    ),
                    _PackageTextFiled(
                      hint: context.l10n.packageDataHint,
                      controller: dataController,
                      label: context.l10n.packageDataLabel,
                    )
                  ].map((e) => Expanded(child: e)).toList(),
                ),
                const SizedBox(height: 4),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      ValueListenableBuilder<Set<_PackageTypeIdAndData>>(
                        valueListenable: sentPackagesNotifier,
                        builder: (context, value, child) {
                          return SizedBox(
                            width: 50,
                            height: double.infinity,
                            child: PopupMenuButton<_PackageTypeIdAndData>(
                              itemBuilder: (context) {
                                return value
                                    .map(
                                      (e) =>
                                          PopupMenuItem<_PackageTypeIdAndData>(
                                        value: e,
                                        child: Text(e.toString()),
                                      ),
                                    )
                                    .toList();
                              },
                              onSelected: (value) {
                                context
                                    .read<OutgoingPackagesCubit>()
                                    .sendPackage(
                                      DataSourceOutgoingPackage.raw(
                                        requestType:
                                            DataSourceRequestType.fromInt(
                                          value.type,
                                        ),
                                        parameterId: value.parameterId,
                                        data: value.data,
                                      ),
                                    );
                              },
                              child: const Icon(Icons.history),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: const RoundedRectangleBorder(),
                          ),
                          icon: const Icon(Icons.send),
                          label: Text(
                            context.l10n.sendButtonCaption,
                            style: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            final requestType =
                                int.tryParse(typeController.text);
                            final parameterId = int.tryParse(idController.text);
                            final data = [
                              if (dataController.text.isNotEmpty)
                                ...dataController.text
                                    .replaceAll(',', ' ')
                                    .split(' ')
                                    .map((e) => int.tryParse(e.trim()))
                            ];
                            if (requestType == null ||
                                !DataSourceRequestType.isValid(requestType)) {
                              context.showSnackBar(
                                context.l10n.invalidRequestTypeMessage,
                              );
                              return;
                            }
                            if (parameterId == null) {
                              context.showSnackBar(
                                context.l10n.invalidParameterIDMessage,
                              );
                              return;
                            }
                            if (data.any((element) => element == null)) {
                              context.showSnackBar(
                                context.l10n.invalidDataFormatMessage,
                              );
                              return;
                            }

                            context.read<OutgoingPackagesCubit>().sendPackage(
                                  DataSourceOutgoingPackage.raw(
                                    requestType: DataSourceRequestType.fromInt(
                                      requestType,
                                    ),
                                    parameterId: parameterId,
                                    data: data.whereType<int>().toList(),
                                  ),
                                );

                            FocusScope.of(context).unfocus();

                            sentPackagesNotifier.add(
                              _PackageTypeIdAndData(
                                requestType,
                                parameterId,
                                data.whereType<int>().toList(),
                              ),
                            );

                            typeController.clear();
                            idController.clear();
                            dataController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _PackageTextFiled extends StatelessWidget {
  const _PackageTextFiled({
    required this.hint,
    required this.controller,
    this.label,
  });

  @protected
  final String hint;

  @protected
  final String? label;

  @protected
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: hint,
        label: label == null ? null : Text(label ?? ''),
      ),
    );
  }
}

@immutable
class _PackageTypeIdAndData {
  const _PackageTypeIdAndData(this.type, this.parameterId, this.data);

  final int type;
  final int parameterId;
  final List<int> data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _PackageTypeIdAndData &&
        other.type == type &&
        other.parameterId == parameterId &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => type.hashCode ^ parameterId.hashCode ^ data.hashCode;

  @override
  String toString() => '${type.toBytesUint8}, ${parameterId.toBytesUint16}, '
      'data: ${data.map((e) => e.toBytesUint8)}';
}

class _SentPackagesNotifier extends ValueNotifier<Set<_PackageTypeIdAndData>> {
  _SentPackagesNotifier() : super(const {});

  void add(_PackageTypeIdAndData package) {
    value = {...value, package};
  }
}
