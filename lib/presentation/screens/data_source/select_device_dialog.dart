import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:re_seedwork/re_seedwork.dart';

class SelectDeviceDialog extends StatefulWidget {
  const SelectDeviceDialog({super.key, required this.dataSource});

  @protected
  final DataSource dataSource;

  @override
  State<SelectDeviceDialog> createState() => _SelectDeviceDialogState();
}

class _SelectDeviceDialogState extends State<SelectDeviceDialog> {
  late final DataSourceDeviceListCubit dataSourceDeviceListCubit;

  @override
  void initState() {
    super.initState();
    dataSourceDeviceListCubit = DataSourceDeviceListCubit(
      dataSource: widget.dataSource,
    );
  }

  @override
  void dispose() {
    dataSourceDeviceListCubit.close();
    super.dispose();
  }

  void showLoadingDialog(VoidCallback onInit) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConnectToDataSourceLoadingDialog(onInit: onInit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.selectDeviceDialogTitle),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .6,
        ),
        child:
            BlocBuilder<DataSourceDeviceListCubit, DataSourceDeviceListState>(
          bloc: dataSourceDeviceListCubit,
          builder: (context, state) {
            return state.maybeWhen(
              orElse: (_) {
                return state.payload.isEmpty
                    ? const UnconstrainedBox(
                        child: SizedBox.square(
                          dimension: 30,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(
                              context.l10n.deviceNameDialogLabel,
                            ),
                            trailing: Text(context.l10n.bondedDialogLabel),
                          ),
                          const Divider(),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                children: state.payload
                                    .map(
                                      (e) => ListTile(
                                        title: Text(
                                          e.name ??
                                              context
                                                  .l10n.noDeviceNameDialogStub,
                                        ),
                                        subtitle: Text(e.address),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          showLoadingDialog(
                                            () => context
                                                .read<DataSourceConnectBloc>()
                                                .add(
                                                  DataSourceConnectEvent
                                                      .connect(
                                                    DataSourceWithAddress(
                                                      dataSource:
                                                          widget.dataSource,
                                                      address: e.address,
                                                    ),
                                                  ),
                                                ),
                                          );
                                        },
                                        trailing: e.isBonded
                                            ? Icon(
                                                Icons.check,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            : null,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      );
              },
              failure: (payload, error) {
                return Text(context.l10n.errorDiscoveringDevicesMessage);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(context.l10n.cancelButtonCaption),
        ),
      ],
    );
  }
}

class ConnectToDataSourceLoadingDialog extends StatefulWidget {
  const ConnectToDataSourceLoadingDialog({super.key, required this.onInit});

  final VoidCallback onInit;

  @override
  State<ConnectToDataSourceLoadingDialog> createState() =>
      _ConnectToDataSourceLoadingDialogState();
}

class _ConnectToDataSourceLoadingDialogState
    extends State<ConnectToDataSourceLoadingDialog> {
  late final StreamSubscription<void> connectSub;
  late final String? currentRouteName;

  @override
  void initState() {
    super.initState();
    currentRouteName = context.router.stack.first.name;

    connectSub =
        context.read<DataSourceConnectBloc>().stream.listen(onNewState);
    widget.onInit();
  }

  void onNewState(AsyncData<Optional<DataSourceWithAddress>, Object> state) {
    if (state.isExecuted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (currentRouteName == RouteNames.homeFlow || state.isFailure) {
          Navigator.of(context).pop();
        }
      });
    }
    if (state.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errorConnectingToDataSourceMessage),
        ),
      );
    } else if (state.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.successfullyConnectedToDataSourceMessage),
        ),
      );
    }
  }

  @override
  void dispose() {
    connectSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
