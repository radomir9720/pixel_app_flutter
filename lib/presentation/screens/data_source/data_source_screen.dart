import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/data/services/bluetooth_data_source.dart';
import 'package:pixel_app_flutter/data/services/demo_data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/screens/data_source/select_device_dialog.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/close_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/settings_button.dart';

class DataSourceScreen extends StatelessWidget {
  const DataSourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: CustomScrollView(
        primary: false,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const Spacer(),
                BlocConsumer<SelectDataSourceBloc, SelectDataSourceState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      failure: (payload, error) {
                        final stringError = error?.when(
                              unknown: () => context
                                  .l10n.unknownErrorSelectingDataSourceMessage,
                              isUnavailable: () => context
                                  .l10n.unavailableDataSourceErrorMessage,
                              unsuccessfulEnableAttempt: () =>
                                  context.l10n.errorEnablingDataSourceMessage,
                            ) ??
                            context.l10n.unknownErrorSelectingDataSourceMessage;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(stringError)),
                        );
                      },
                      success: (payload) {
                        payload.selected.when(
                          presented: (source) {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              routeSettings: const RouteSettings(
                                name: 'SelectDeviceDialog',
                              ),
                              builder: (context) => SelectDeviceDialog(
                                dataSource: source,
                              ),
                            );
                          },
                          undefined: () {},
                        );
                      },
                      orElse: (_) {},
                    );
                  },
                  builder: (context, state) {
                    final currentDataSource = context
                        .watch<DataSourceConnectBloc>()
                        .state
                        .payload
                        .when(undefined: () => null, presented: (v) => v);

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: state.payload.all.map(
                          (e) {
                            void onPressed() {
                              context
                                  .read<SelectDataSourceBloc>()
                                  .add(SelectDataSourceEvent.select(e));
                            }

                            var icon = Icons.source_outlined;
                            var title = e.runtimeType.toString();

                            if (e is DemoDataSource) {
                              icon = Icons.bug_report;
                              title = context.l10n.demoDataSourceTitle;
                            } else if (e is BluetoothDataSource) {
                              icon = PixelIcons.bluetooth;
                              title = context.l10n.bluetoothDataSourceTitle;
                            }

                            return SourceItem(
                              icon: icon,
                              title: title,
                              onPressed: onPressed,
                              selected: currentDataSource != null &&
                                  currentDataSource.dataSource.key == e.key,
                            );
                          },
                        ).toList(),
                      ),
                    );
                  },
                ),
                const Spacer(),
                if (context.router.canNavigateBack)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: PCloseButton(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SourceItem extends StatelessWidget {
  const SourceItem({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    this.onPressed,
  });

  @protected
  final VoidCallback? onPressed;

  @protected
  final IconData icon;

  @protected
  final String title;

  @protected
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 120,
        minWidth: 60,
        maxWidth: math.min(MediaQuery.of(context).size.width / 2.3, 250),
      ),
      child: SettingsButton(
        icon: icon,
        title: title,
        onPressed: onPressed,
        state: selected
            ? SettingsButtonState.selected
            : SettingsButtonState.enabled,
      ),
    );
  }
}
