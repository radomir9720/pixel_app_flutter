import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

class DemoDataSource implements DataSource {
  DemoDataSource({
    this.generateRandomErrors = false,
    this.updatePeriodMillis = 800,
  })  : controller = StreamController.broadcast(),
        subscriptionCallbacks = {},
        valueCache = {};

  @protected
  final int updatePeriodMillis;

  @protected
  final bool generateRandomErrors;

  @visibleForTesting
  final Map<ParameterId, int> valueCache;

  @protected
  Result<E, V> returnValueOrErrorFromList<E extends Enum, V>(
    List<E> en,
    V value,
  ) {
    if (generateRandomErrors && math.Random().nextBool()) {
      final errorIndex = math.Random().nextInt(en.length);
      final error = en[errorIndex];
      return Result.error(error);
    }

    return Result<E, V>.value(value);
  }

  @visibleForTesting
  StreamController<DataSourceDevice>? deviceStream;

  @visibleForTesting
  final StreamController<DataSourceIncomingEvent> controller;

  @visibleForTesting
  final Set<void Function()> subscriptionCallbacks;

  @visibleForTesting
  Timer? timer;

  @override
  Future<Result<CancelDeviceDiscoveringError, void>>
      cancelDeviceDiscovering() async {
    return returnValueOrErrorFromList(
      CancelDeviceDiscoveringError.values,
      null,
    );
  }

  @override
  Future<Result<ConnectError, void>> connect(String address) async {
    return returnValueOrErrorFromList(ConnectError.values, null);
  }

  @override
  Future<void> dispose() async {
    await controller.close();
  }

  @override
  Future<Result<EnableError, void>> enable() async {
    return returnValueOrErrorFromList(EnableError.values, null);
  }

  @override
  Stream<DataSourceIncomingEvent> get eventStream => controller.stream;

  @override
  Future<Result<GetDeviceListError, Stream<DataSourceDevice>>>
      getDeviceStream() async {
    await deviceStream?.close();
    deviceStream = null;
    deviceStream = StreamController.broadcast();

    // Adding bonded device to stream
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 1300)).then((value) {
        deviceStream?.sink.add(
          const DataSourceDevice(
            address: 'testAdress1',
            isBonded: true,
            name: 'Device 1(bonded)',
          ),
        );
      }),
    );

    // Adding unbonded device to stream
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 2500)).then((value) {
        deviceStream?.sink.add(
          const DataSourceDevice(
            address: 'testAdress2',
            isBonded: false,
            name: 'Device 2(unbonded)',
          ),
        );
      }),
    );

    final _deviceStream = deviceStream;
    if (_deviceStream == null) {
      return const Result.error(GetDeviceListError.unknown);
    }

    return returnValueOrErrorFromList(
      GetDeviceListError.values,
      _deviceStream.stream,
    );
  }

  @override
  Future<bool> get isAvailable async => math.Random().nextBool();

  @override
  Future<bool> get isEnabled async => math.Random().nextBool();

  @override
  Future<Result<SendEventError, void>> sendEvent(
    DataSourceOutgoingEvent event,
  ) async {
    return event.maybeWhen(
      getParameterValue: (parameterId) {
        controller.sink.add(
          DataSourceGetParameterValueIncomingEvent(
            DataSourcePackage.fromBody([
              0x00,
              int.parse('10000001', radix: 2),
              ...parameterId.value.toTwoBytes,
              0x00,
            ]),
          ),
        );
        return const Result.value(null);
      },
      handshake: () {
        Future<void>.delayed(const Duration(seconds: 1)).then(
          (value) {
            controller.sink.add(
              DataSourceHandshakeIncomingEvent(
                DataSourcePackage.fromBody([
                  0x00,
                  int.parse('10010000', radix: 2),
                  0xFF,
                  0xFF,
                  0x00,
                ]),
              ),
            );
          },
        );

        return const Result.value(null);
      },
      subscribe: (id) {
        if (id == ParameterId.speed) {
          subscriptionCallbacks.add(_sendNewSpeedCallback);
        } else if (id == ParameterId.current) {
          subscriptionCallbacks.add(_sendNewCurrentCallback);
        } else if (id == ParameterId.voltage) {
          subscriptionCallbacks.add(_sendNewVoltageCallback);
        }

        timer ??= Timer.periodic(
          Duration(milliseconds: updatePeriodMillis),
          (timer) {
            for (final element in subscriptionCallbacks) {
              element();
            }
          },
        );

        return const Result.value(null);
      },
      unsubscribe: (id) {
        if (id == ParameterId.speed) {
          subscriptionCallbacks.remove(_sendNewSpeedCallback);
        } else if (id == ParameterId.current) {
          subscriptionCallbacks.remove(_sendNewCurrentCallback);
        } else if (id == ParameterId.voltage) {
          subscriptionCallbacks.remove(_sendNewVoltageCallback);
        }

        return const Result.value(null);
      },
      orElse: () => const Result.value(null),
    );
  }

  void _sendNewSpeedCallback() {
    final lastValue = valueCache[ParameterId.speed] ?? 0;
    final newValue =
        (lastValue + Random().nextInt(10) * (Random().nextBool() ? 1 : -1))
            .clamp(0, 100);
    valueCache[ParameterId.speed] = newValue;
    _updateValueCallback(
      ParameterId.speed,
      newValue,
    );
  }

  void _sendNewVoltageCallback() {
    final lastValue = valueCache[ParameterId.voltage] ?? 80;
    final newValue =
        (lastValue + Random().nextInt(2) * (Random().nextBool() ? 1 : -1))
            .clamp(0, 100);
    valueCache[ParameterId.voltage] = newValue;
    _updateValueCallback(ParameterId.voltage, newValue);
  }

  void _sendNewCurrentCallback() {
    final lastValue = valueCache[ParameterId.current] ?? 200;
    final newValue =
        (lastValue + Random().nextInt(20) * (Random().nextBool() ? 1 : -1))
            .clamp(0, 255);
    valueCache[ParameterId.current] = newValue;
    _updateValueCallback(ParameterId.current, newValue);
  }

  void _updateValueCallback(
    ParameterId parameterId,
    int value,
  ) {
    controller.sink.add(
      DataSourceUpdateValueIncomingEvent(
        DataSourcePackage.fromBody([
          0x00,
          int.parse('10010101', radix: 2),
          ...parameterId.value.toTwoBytes,
          0x01,
          value,
        ]),
      ),
    );
  }

  @override
  String get key => 'demo';
}
