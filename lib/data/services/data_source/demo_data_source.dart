import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/default_data_source_observer_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/events_stream_controller_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

class DemoDataSource extends DataSource
    with DefaultDataSourceObserverMixin, EventsStreamControllerMixin {
  DemoDataSource({
    required this.generateRandomErrors,
    required this.updatePeriodMillis,
    required super.id,
  })  : subscriptionCallbacks = {},
        valueCache = {};

  @protected
  final int Function() updatePeriodMillis;

  @protected
  final bool Function() generateRandomErrors;

  @visibleForTesting
  final Map<int, int> valueCache;

  static const kKey = 'demo';

  @override
  String get key => kKey;

  @protected
  Result<E, V> returnValueOrErrorFromList<E extends Enum, V>(
    List<E> en,
    V value,
  ) {
    if (generateRandomErrors() && math.Random().nextBool()) {
      final errorIndex = math.Random().nextInt(en.length);
      final error = en[errorIndex];
      return Result.error(error);
    }

    return Result<E, V>.value(value);
  }

  @visibleForTesting
  StreamController<List<DataSourceDevice>>? deviceStream;

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
    await super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Future<Result<EnableError, void>> enable() async {
    return returnValueOrErrorFromList(EnableError.values, null);
  }

  @override
  Stream<DataSourceIncomingEvent> get eventStream => controller.stream;

  @override
  Future<Result<GetDeviceListError, Stream<List<DataSourceDevice>>>>
      getDevicesStream() async {
    await deviceStream?.close();
    deviceStream = null;
    deviceStream = StreamController.broadcast();

    const device1 = DataSourceDevice(
      address: 'testAdress1',
      isBonded: true,
      name: 'Device 1(bonded)',
    );

    const device2 = DataSourceDevice(
      address: 'testAdress2',
      name: 'Device 2(unbonded)',
    );

    // Adding bonded device to stream
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 200)).then((value) {
        deviceStream?.sink.add([device1]);
      }),
    );

    // Adding unbonded device to stream
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 2500)).then((value) {
        deviceStream?.sink.add([device1, device2]);
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
  Future<bool> get isAvailable async {
    if (generateRandomErrors()) {
      return math.Random().nextBool();
    }

    return true;
  }

  @override
  Future<bool> get isEnabled async {
    if (generateRandomErrors()) {
      return math.Random().nextBool();
    }

    return true;
  }

  @override
  Future<Result<SendEventError, void>> sendEvent(
    DataSourceOutgoingEvent event,
  ) async {
    observe(event.toPackage());

    return event.maybeWhen(
      getParameterValue: (id) {
        const version = DataSourceProtocolVersion.periodicRequests;
        if (id == const DataSourceParameterId.speed()) {
          _sendNewSpeedCallback(version: version);
        } else if (id == const DataSourceParameterId.current()) {
          _sendNewCurrentCallback(version: version);
        } else if (id == const DataSourceParameterId.voltage()) {
          _sendNewVoltageCallback(version: version);
        }

        return const Result.value(null);
      },
      handshake: () {
        Future<void>.delayed(const Duration(seconds: 1)).then(
          (value) {
            final package = DataSourcePackage.builder(
              secondConfigByte: int.parse('10010000', radix: 2),
              parameterId: 0xFFFF,
            );

            observe(package);

            if (!controller.isClosed) {
              controller.sink.add(
                DataSourceHandshakeIncomingEvent(package),
              );
            }
          },
        );

        return const Result.value(null);
      },
      subscribe: (id) {
        id.when(
          speed: () {
            subscriptionCallbacks.add(_sendNewSpeedCallback);
          },
          voltage: () {
            subscriptionCallbacks.add(_sendNewVoltageCallback);
          },
          current: () {
            subscriptionCallbacks.add(_sendNewCurrentCallback);
          },
          light: () {},
          custom: (_) {},
        );

        timer ??= Timer.periodic(
          Duration(milliseconds: updatePeriodMillis()),
          (timer) {
            for (final element in subscriptionCallbacks) {
              element();
            }
          },
        );

        return const Result.value(null);
      },
      unsubscribe: (id) {
        id.when(
          speed: () {
            subscriptionCallbacks.remove(_sendNewSpeedCallback);
          },
          voltage: () {
            subscriptionCallbacks.remove(_sendNewVoltageCallback);
          },
          current: () {
            subscriptionCallbacks.remove(_sendNewCurrentCallback);
          },
          light: () {},
          custom: (_) {},
        );

        return const Result.value(null);
      },
      orElse: () => const Result.value(null),
    );
  }

  @override
  Future<Result<DisconnectError, void>> disconnect() async {
    return const Result.value(null);
  }

  void _sendNewSpeedCallback({
    DataSourceProtocolVersion version = DataSourceProtocolVersion.subscription,
  }) {
    final lastValue =
        valueCache[const DataSourceParameterId.speed().value] ?? 0;
    final newValue =
        (lastValue + Random().nextInt(10) * (Random().nextBool() ? 1 : -1))
            .clamp(0, 100);
    valueCache[const DataSourceParameterId.speed().value] = newValue;
    _updateValueCallback(
      const DataSourceParameterId.speed(),
      newValue,
      version,
    );
  }

  void _sendNewVoltageCallback({
    DataSourceProtocolVersion version = DataSourceProtocolVersion.subscription,
  }) {
    final lastValue =
        valueCache[const DataSourceParameterId.voltage().value] ?? 80000;
    final newValue =
        (lastValue + Random().nextInt(2000) * (Random().nextBool() ? 1 : -1))
            .clamp(0, 100000);
    valueCache[const DataSourceParameterId.voltage().value] = newValue;
    _updateValueCallback(
      const DataSourceParameterId.voltage(),
      newValue,
      version,
    );
  }

  void _sendNewCurrentCallback({
    DataSourceProtocolVersion version = DataSourceProtocolVersion.subscription,
  }) {
    final lastValue =
        valueCache[const DataSourceParameterId.current().value] ?? 200;
    final newValue =
        (lastValue + Random().nextInt(20) * (Random().nextBool() ? 1 : -1))
            .clamp(0, 255);
    valueCache[const DataSourceParameterId.current().value] = newValue;

    _updateValueCallback(
      const DataSourceParameterId.current(),
      newValue,
      version,
    );
  }

  void _updateValueCallback(
    DataSourceParameterId parameterId,
    int value,
    DataSourceProtocolVersion version,
  ) {
    final requestType = version.when(
      subscription: () => '10010101',
      periodicRequests: () => '10000001',
    );

    final package = DataSourcePackage.builder(
      secondConfigByte: int.parse(requestType, radix: 2),
      parameterId: parameterId.value,
      data: value,
    );

    observe(package);

    final event = version.when(
      subscription: () => DataSourceUpdateValueIncomingEvent(package),
      periodicRequests: () => DataSourceGetParameterValueIncomingEvent(package),
    );

    controller.sink.add(event);
  }
}
