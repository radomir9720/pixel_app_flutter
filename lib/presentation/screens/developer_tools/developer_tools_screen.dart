import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';

class DeveloperToolsScreen extends StatelessWidget {
  const DeveloperToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.router.pop(),
        ),
        title: Text(context.l10n.developerToolsScreenTitle),
      ),
      body:
          BlocBuilder<DeveloperToolsParametersCubit, DeveloperToolsParameters>(
        builder: (context, state) {
          return ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text(context.l10n.protocolVersionLabel),
                  trailing: DropdownButton<DataSourceProtocolVersion>(
                    value: state.protocolVersion,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(
                        value: DataSourceProtocolVersion.subscription,
                        child: Text(
                          context.l10n.subscriptionProtocolVersionLabel,
                        ),
                      ),
                      DropdownMenuItem(
                        value: DataSourceProtocolVersion.periodicRequests,
                        child: Text(
                          context.l10n.periodicRequestsProtocolVersionLabel,
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      context
                          .read<DeveloperToolsParametersCubit>()
                          .update(protocolVersion: value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    context.l10n.requestPeriodInMillisListTileLabel,
                  ),
                  subtitle: Text(
                    context.l10n.requestPeriodInMillisListTileSubtitle,
                  ),
                  trailing: Text('${state.requestsPeriodInMillis}'),
                  onTap: () {
                    context.router
                        .push<int>(
                      ChangeRequestPeriodDialogRoute(
                        initialValue: state.requestsPeriodInMillis,
                        title: context.l10n.requestPeriodInMillisListTileLabel,
                      ),
                    )
                        .then((value) {
                      if (value != null) {
                        context
                            .read<DeveloperToolsParametersCubit>()
                            .update(requestsPeriodInMillis: value);
                      }
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    context.l10n.whichParametersToSubscribeToListTileLabel,
                  ),
                  onTap: () {
                    context.router
                        .push<List<int>>(
                      ChangeParametersSubscriptionDialogRoute(
                        initialChoosedOptions: state.subscriptionParameterIds,
                        title: context
                            .l10n.whichParametersToSubscribeToListTileLabel,
                        alwasysVisibleOptions: DataSourceParameterId.all
                            .map((e) => e.value)
                            .toList(),
                        validator: (integer) {
                          if (integer < 0 || integer > 0xFFFF) {
                            return context.l10n.parameterIdLimitsMessage;
                          }
                          return null;
                        },
                      ),
                    )
                        .then((value) {
                      if (value != null) {
                        context
                            .read<DeveloperToolsParametersCubit>()
                            .update(subscriptionParameterIds: value);
                      }
                    });
                  },
                  trailing: Text(state.subscriptionParameterIds.join(', ')),
                ),
                SwitchListTile(
                  value: state.enableHandshakeResponse,
                  title:
                      Text(context.l10n.enableHandshakeResponseListTileLabel),
                  onChanged: (value) {
                    context.read<DeveloperToolsParametersCubit>().update(
                          enableHandshakeResponse: value,
                        );
                  },
                ),
                if (state.enableHandshakeResponse)
                  ListTile(
                    title: Text(
                      context.l10n.sendHandshakeResponseTimeoutListTileLabel,
                    ),
                    onTap: () {
                      context.router
                          .push<int>(
                        ChangeHandshakeResponseTimeoutDialogRoute(
                          initialValue: state.handshakeResponseTimeoutInMillis,
                          title: context
                              .l10n.sendHandshakeResponseTimeoutListTileLabel,
                        ),
                      )
                          .then((value) {
                        if (value != null) {
                          context.read<DeveloperToolsParametersCubit>().update(
                                handshakeResponseTimeoutInMillis: value,
                              );
                        }
                      });
                    },
                    trailing: Text('${state.handshakeResponseTimeoutInMillis}'),
                  ),
                SwitchListTile(
                  value: state.enableRandomErrorGenerationForDemoDataSource,
                  title: Text(
                    context.l10n
                        .enableDemoDataSourceRandomErrorGenerationListTileLabel,
                  ),
                  onChanged: (value) {
                    context.read<DeveloperToolsParametersCubit>().update(
                          enableRandomErrorGenerationForDemoDataSource: value,
                        );
                  },
                ),
                ListTile(
                  title: Text(context.l10n.requestsExchangeLogsListTileLabel),
                  onTap: () {
                    context.router.push(const RequestsExchangeLogsFlow());
                  },
                ),
              ],
            ).toList(),
          );
        },
      ),
    );
  }
}
