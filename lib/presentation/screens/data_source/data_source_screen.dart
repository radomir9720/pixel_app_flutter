import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pixel_app_flutter/app/scopes/flows/select_data_source_scope.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/extensions.dart';
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
              context.showSnackBar(stringError);
            },
            success: (payload) {
              payload.when(
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

          return SettingsBaseLayout(
            screenTitle: currentDataSource != null
                ? context.l10n.dataSourceScreenTitle
                : context.l10n.selectDataSourceScreenTitle,
            bottomLeft: showCloseButton
                ? null
                : GlueTitle(
                    alignment: Alignment.centerLeft,
                    title: context.l10n.settingsButtonCaption,
                    side: GlueTitleSide.bottom,
                    child: PIconButton(
                      onPressed: () {
                        context.router.push(const SettingsFlow());
                      },
                      icon: PixelIcons.settings,
                      size: PIconButtonSize.normal,
                    ),
                  ),
            buttons: context.read<List<DataSourceEntity>>().map(
              (e) {
                void onPressed() {
                  context
                      .read<SelectDataSourceBloc>()
                      .add(SelectDataSourceEvent.select(e.initializer));
                }

                final selected = currentDataSource != null &&
                    currentDataSource.dataSource.key == e.key;

                return SettingsButton(
                  icon: e.icon,
                  title: e.title,
                  onPressed: onPressed,
                  state: selected
                      ? SettingsButtonState.selected
                      : SettingsButtonState.enabled,
                );
              },
            ).toList(),
            bottom: Text(
              context.l10n.appVersion(
                context.read<PackageInfo>().versionAndBuildNumber,
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        },
      ),
    );
  }
}
