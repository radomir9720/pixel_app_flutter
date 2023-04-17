import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/data/services/data_source/bluetooth_data_source.dart';
import 'package:pixel_app_flutter/data/services/data_source/demo_data_source.dart';
import 'package:pixel_app_flutter/data/services/data_source/usb_data_source.dart';
import 'package:pixel_app_flutter/data/services/data_source/usb_data_source_android.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/glue_title.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/icon_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/settings_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/settings_base_layout.dart';
import 'package:re_widgets/re_widgets.dart';

class DataSourceScreen extends StatelessWidget {
  const DataSourceScreen({super.key});

  static const _dataSourceIconDataMap = {
    USBDataSource.kKey: PixelIcons.usb,
    DemoDataSource.kKey: Icons.bug_report,
    BluetoothDataSource.kKey: PixelIcons.bluetooth,
    USBAndroidDataSource.kKey: PixelIcons.usb,
  };

  IconData _getDataSourceIconDataByKey(String key) {
    return _dataSourceIconDataMap[key] ?? Icons.source_outlined;
  }

  String? _getDataSourceTitleByKey(String key, BuildContext context) {
    switch (key) {
      case USBDataSource.kKey:
      case USBAndroidDataSource.kKey:
        if (context.platform.isMacOS) {
          return context.l10n.usbOrBluetoothDataSourceTitle;
        }
        return context.l10n.usbDataSourceTitle;
      case DemoDataSource.kKey:
        return context.l10n.demoDataSourceTitle;
      case BluetoothDataSource.kKey:
        return context.l10n.bluetoothDataSourceTitle;
    }
    return null;
  }

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

          final showCloseButton =
              context.router.root.current.name != SelectDataSourceFlow.name;
          final showDevToolsButton = context.watch<Environment>().isDev;
          return SettingsBaseLayout(
            screenTitle: currentDataSource != null
                ? context.l10n.dataSourceScreenTitle
                : context.l10n.selectDataSourceScreenTitle,
            bottomLeft: showCloseButton
                ? null
                : showDevToolsButton
                    ? GlueTitle(
                        alignment: Alignment.centerLeft,
                        title: context.l10n.developerToolsButtonCaption
                            .replaceAll(' ', '\n'),
                        side: GlueTitleSide.bottom,
                        child: PIconButton(
                          onPressed: () {
                            context.router.push(const DeveloperToolsFlow());
                          },
                          icon: PixelIcons.settings,
                          size: PIconButtonSize.normal,
                        ),
                      )
                    : const SizedBox.shrink(),
            buttons: state.payload.all.map(
              (e) {
                void onPressed() {
                  context
                      .read<SelectDataSourceBloc>()
                      .add(SelectDataSourceEvent.select(e));
                }

                final icon = _getDataSourceIconDataByKey(e.key);
                final title = _getDataSourceTitleByKey(e.key, context) ??
                    e.runtimeType.toString();

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
