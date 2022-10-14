import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

class DeveloperToolsParametersCubit extends Cubit<DeveloperToolsParameters>
    with ConsumerBlocMixin {
  DeveloperToolsParametersCubit({required this.developerToolsParametersStorage})
      : super(
          developerToolsParametersStorage.read().when(
                error: (e) {
                  developerToolsParametersStorage.remove();
                  return developerToolsParametersStorage.defaultValue;
                },
                value: (v) => v,
              ),
        ) {
    subscribe<DeveloperToolsParameters>(developerToolsParametersStorage, emit);
  }

  @protected
  final DeveloperToolsParametersStorage developerToolsParametersStorage;

  void update({
    int? requestsPeriodInMillis,
    List<int>? subscriptionParameterIds,
    DataSourceProtocolVersion? protocolVersion,
    bool? enableRandomErrorGenerationForDemoDataSource,
    bool? enableHandshakeResponse,
    int? handshakeResponseTimeoutInMillis,
  }) {
    developerToolsParametersStorage.write(
      state.copyWith(
        protocolVersion: protocolVersion,
        requestsPeriodInMillis: requestsPeriodInMillis,
        subscriptionParameterIds: subscriptionParameterIds,
        enableRandomErrorGenerationForDemoDataSource:
            enableRandomErrorGenerationForDemoDataSource,
        enableHandshakeResponse: enableHandshakeResponse,
        handshakeResponseTimeoutInMillis: handshakeResponseTimeoutInMillis,
      ),
    );
  }
}
