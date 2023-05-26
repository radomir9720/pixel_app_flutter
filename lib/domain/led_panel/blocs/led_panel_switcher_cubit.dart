import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/outgoing_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'led_panel_switcher_cubit.freezed.dart';

@freezed
class LEDPanelSwitcherState with _$LEDPanelSwitcherState {
  const LEDPanelSwitcherState._();

  const factory LEDPanelSwitcherState.initial() = _Initial;
  const factory LEDPanelSwitcherState.turningOn(
    LEDPanelConfig config, [
    DateTime? shutdownTime,
  ]) = _TurningOn;
  const factory LEDPanelSwitcherState.on(
    LEDPanelConfig config, [
    DateTime? shutdownTime,
  ]) = _On;
  const factory LEDPanelSwitcherState.errorTurningOn(LEDPanelConfig config) =
      _ErrorTurningOn;
  const factory LEDPanelSwitcherState.turningOff(LEDPanelConfig config) =
      _TurningOff;
  const factory LEDPanelSwitcherState.off() = _Off;
  const factory LEDPanelSwitcherState.errorTurningOff(LEDPanelConfig config) =
      _ErrorTurningOff;

  LEDPanelConfig? get config => whenOrNull(
        errorTurningOff: (config) => config,
        errorTurningOn: (config) => config,
        on: (config, shutdownTime) => config,
        turningOff: (config) => config,
        turningOn: (config, shutdownTime) => config,
      );
}

class LEDPanelSwitcherCubit extends Cubit<LEDPanelSwitcherState>
    with ConsumerBlocMixin {
  LEDPanelSwitcherCubit({
    required this.dataSource,
    this.timeoutDuration = kDefaultTimeoutDuration,
  }) : super(const LEDPanelSwitcherState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (value) {
      value.voidOnModel<SuccessEventUint8Body,
          CustomImageIncomingDataSourcePackage>((model) {
        if (model.value == 0) return emit(const LEDPanelSwitcherState.off());

        state.maybeWhen(
          turningOn: (config, shutdownTime) {
            // TODO(Radomir): logic with autoshutdown should be at L2 level

            if (config.fileId == model.value) {
              emit(
                LEDPanelSwitcherState.on(
                  config,
                  state.whenOrNull(
                    turningOn: (_, shutdownTime) => shutdownTime,
                  ),
                ),
              );
            }
          },
          orElse: () {},
        );
      });
    });
  }

  void turnOn(LEDPanelConfig config) {
    _sendSetImagePackage(config);

    config.when(
      autoShutdown: (id, fileId, name, shutdownTimeMillis) {
        Future<void>.delayed(Duration(milliseconds: shutdownTimeMillis))
            .then((value) {
          if (isClosed) return;
          state.whenOrNull(
            on: (conf, _) {
              if (conf.id == config.id) turnOff();
            },
          );
        });
      },
      manualShutdown: (id, fileId, name) {},
    );
  }

  void turnOff() {
    state.whenOrNull(
      turningOn: (id, shutdownTime) => _sendTurnOffImagePackage(id),
      on: (id, shutdownTime) => _sendTurnOffImagePackage(id),
      turningOff: (id) {},
      errorTurningOff: _sendTurnOffImagePackage,
    );
  }

  void _sendSetImagePackage(LEDPanelConfig config) {
    emit(
      LEDPanelSwitcherState.turningOn(
        config,
        config.whenOrNull(
          autoShutdown: (id, fileId, name, shutdownTimeMillis) =>
              DateTime.now().add(Duration(milliseconds: shutdownTimeMillis)),
        ),
      ),
    );

    dataSource.sendPackage(
      OutgoingSetValuePackage(
        parameterId: const DataSourceParameterId.customImage(),
        setValueBody: SetUint8Body(value: config.fileId),
      ),
    );
    Future<void>.delayed(timeoutDuration).then((value) {
      if (isClosed) return;
      state.whenOrNull(
        turningOn: (id, _) {
          emit(LEDPanelSwitcherState.errorTurningOn(id));
        },
      );
    });
  }

  void _sendTurnOffImagePackage(LEDPanelConfig config) {
    emit(LEDPanelSwitcherState.turningOff(config));

    dataSource.sendPackage(
      OutgoingSetValuePackage(
        parameterId: const DataSourceParameterId.customImage(),
        setValueBody: const SetUint8Body(value: 0),
      ),
    );

    Future<void>.delayed(timeoutDuration).then((value) {
      if (isClosed) return;

      state.whenOrNull(
        turningOff: (conf) {
          if (conf.id == config.id) {
            emit(LEDPanelSwitcherState.errorTurningOff(conf));
          }
        },
      );
    });
  }

  @protected
  final DataSource dataSource;

  @protected
  final Duration timeoutDuration;

  @visibleForTesting
  static const kDefaultTimeoutDuration = Duration(milliseconds: 700);
}

extension CurrentOrInitialExtension on LEDPanelSwitcherState {
  LEDPanelSwitcherState currentOrInitial(int other) {
    const initial = LEDPanelSwitcherState.initial();
    final a = when(
      off: () => this,
      initial: () => this,
      on: (config, _) => config.id == other ? this : initial,
      turningOff: (config) => config.id == other ? this : initial,
      turningOn: (config, _) => config.id == other ? this : initial,
      errorTurningOn: (config) => config.id == other ? this : initial,
      errorTurningOff: (config) => config.id == other ? this : initial,
    );

    return a;
  }
}
