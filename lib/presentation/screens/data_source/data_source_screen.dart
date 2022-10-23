import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/data/services/bluetooth_data_source.dart';
import 'package:pixel_app_flutter/data/services/demo_data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/settings_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/settings_base_layout.dart';

class DataSourceScreen extends StatelessWidget {
  const DataSourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: BlocConsumer<SelectDataSourceBloc, SelectDataSourceState>(
        listener: (context, state) {
          state.maybeWhen(
            failure: (payload, error) {
              final stringError = error?.when(
                    unknown: () =>
                        context.l10n.unknownErrorSelectingDataSourceMessage,
                    isUnavailable: () =>
                        context.l10n.unavailableDataSourceErrorMessage,
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
                  context.router.push(
                    SelectDeviceDialogRoute(dataSource: source),
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
              .watch<DataSourceCubit>()
              .state
              .ds
              .when(undefined: () => null, presented: (v) => v);

          return SettingsBaseLayout(
            screenTitle: currentDataSource != null
                ? context.l10n.dataSourceScreenTitle
                : context.l10n.selectDataSourceScreenTitle,
            // TODO(radomir9720): ew
            showBottom: context.router.current.parent?.parent?.name != 'Root',
            buttons: state.payload.all.map(
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

                return SettingsButton(
                  icon: icon,
                  title: title,
                  onPressed: onPressed,
                  state: currentDataSource != null &&
                          currentDataSource.dataSource.key == e.key
                      ? SettingsButtonState.selected
                      : SettingsButtonState.enabled,
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
