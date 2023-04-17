import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/default_data_source_observer_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/package_stream_controller_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/outgoing_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

class DemoDataSource extends DataSource
    with DefaultDataSourceObserverMixin, PackageStreamControllerMixin {
  DemoDataSource({
    required this.generateRandomErrors,
    required this.updatePeriodMillis,
    required super.id,
  })  : subscriptionCallbacks = {},
        isInitialHandshake = true;

  @protected
  final int Function() updatePeriodMillis;

  @protected
  final bool Function() generateRandomErrors;

  static const kKey = 'demo';

  @override
  String get key => kKey;

  @protected
  @visibleForTesting
  bool isInitialHandshake;

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
  Stream<DataSourceIncomingPackage> get packageStream => controller.stream;

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
  Future<Result<SendPackageError, void>> sendPackage(
    DataSourceOutgoingPackage package,
  ) async {
    observe(package);

    final parameterId = package.parameterId;

    return package.requestType.maybeWhen(
      bufferRequest: () => _updateValue(parameterId),
      valueUpdate: () => _updateValue(parameterId),
      handshake: () {
        Future<void>.delayed(const Duration(seconds: 1)).then(
          (value) {
            final package = DataSourceIncomingPackage.fromConvertible(
              secondConfigByte: 0x90, // 10010000(incoming 0x10)
              parameterId: isInitialHandshake ? 0 : 0xFFFF,
              convertible: isInitialHandshake
                  ? const EmptyHandshakeBody()
                  : const HandshakeID(0xFFFF),
            );

            isInitialHandshake = false;

            observe(package);

            if (!controller.isClosed) controller.add(package);
          },
        );

        return const Result.value(null);
      },
      subscription: () {
        if (parameterId.value > OutgoingUnsubscribePackage.kOperand) {
          // Unsubscribe package
          parameterId
            ..voidOn<SpeedParameterId>(
              () => subscriptionCallbacks.remove(_sendNewSpeedCallback),
            )
            ..voidOn<VoltageParameterId>(
              () => subscriptionCallbacks.remove(_sendNewVoltageCallback),
            )
            ..voidOn<CurrentParameterId>(
              () => subscriptionCallbacks.remove(_sendNewCurrentCallback),
            )
            ..voidOn<HighVoltageParameterId>(
              () => subscriptionCallbacks.remove(_sendHighVoltageCallback),
            )
            ..voidOn<HighCurrentParameterId>(
              () => subscriptionCallbacks.remove(_sendHighCurrentCallback),
            )
            ..voidOn<MaxTemperatureParameterId>(
              () => subscriptionCallbacks.remove(_sendMaxTemperatureCallback),
            );

          return const Result.value(null);
        }

        parameterId
          ..voidOn<SpeedParameterId>(
            () => subscriptionCallbacks.add(_sendNewSpeedCallback),
          )
          ..voidOn<VoltageParameterId>(
            () => subscriptionCallbacks.add(_sendNewVoltageCallback),
          )
          ..voidOn<CurrentParameterId>(
            () => subscriptionCallbacks.add(_sendNewCurrentCallback),
          )
          ..voidOn<HighVoltageParameterId>(
            () => subscriptionCallbacks.add(_sendHighVoltageCallback),
          )
          ..voidOn<HighCurrentParameterId>(
            () => subscriptionCallbacks.add(_sendHighCurrentCallback),
          )
          ..voidOn<MaxTemperatureParameterId>(
            () => subscriptionCallbacks.add(_sendMaxTemperatureCallback),
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
      orElse: () => const Result.value(null),
    );
  }

  Result<SendPackageError, void> _updateValue(DataSourceParameterId id) {
    const v = DataSourceProtocolVersion.periodicRequests;

    id
      ..voidOn<SpeedParameterId>(() => _sendNewSpeedCallback(version: v))
      ..voidOn<CurrentParameterId>(() => _sendNewCurrentCallback(version: v))
      ..voidOn<VoltageParameterId>(() => _sendNewVoltageCallback(version: v))
      ..voidOn<LowVoltageMinMaxDeltaParameterId>(_sendNewLowVoltageCallback)
      ..voidOn<HighVoltageParameterId>(_sendHighVoltageCallback)
      ..voidOn<HighCurrentParameterId>(_sendHighCurrentCallback)
      ..voidOn<MaxTemperatureParameterId>(_sendMaxTemperatureCallback)
      //
      ..voidOn<TemperatureFirstBatchParameterId>(
        _sendTemperatureFirstBatchCallback,
      )
      ..voidOn<TemperatureSecondBatchParameterId>(
        _sendTemperatureSecondBatchCallback,
      )
      ..voidOn<TemperatureThirdBatchParameterId>(
        _sendTemperatureThirdBatchCallback,
      )
      //
      ..voidOn<LowVoltageOneToThreeParameterId>(
        _sendLowVoltageOneToThreeCallback,
      )
      ..voidOn<LowVoltageFourToSixParameterId>(_sendLowVoltageFourToSixCallback)
      ..voidOn<LowVoltageSevenToNineParameterId>(
        _sendLowVoltageSevenToNineCallback,
      )
      ..voidOn<LowVoltageTenToTwelveParameterId>(
        _sendLowVoltageTenToTwelveCallback,
      )
      ..voidOn<LowVoltageThirteenToFifteenParameterId>(
        _sendLowVoltageThirteenToFifteenCallback,
      )
      ..voidOn<LowVoltageSixteenToEighteenParameterId>(
        _sendLowVoltageSixteenToEighteenCallback,
      )
      ..voidOn<LowVoltageNineteenToTwentyOneParameterId>(
        _sendLowVoltageNineteenToTwentyOneCallback,
      )
      ..voidOn<LowVoltageTwentyTwoToTwentyFourParameterId>(
        _sendLowVoltageTwentyTwoToTwentyFourCallback,
      );

    return const Result.value(null);
  }

  @override
  Future<Result<DisconnectError, void>> disconnect() async {
    return const Result.value(null);
  }

  void _sendNewSpeedCallback({
    DataSourceProtocolVersion version = DataSourceProtocolVersion.subscription,
  }) {
    _updateValueCallback(
      const DataSourceParameterId.speed(),
      Speed(
        status: _getRandomStatus,
        speed: Random().nextInt(101),
      ),
      version,
    );
  }

  void _sendNewVoltageCallback({
    DataSourceProtocolVersion version = DataSourceProtocolVersion.subscription,
  }) {
    _updateValueCallback(
      const DataSourceParameterId.voltage(),
      Voltage(value: randomDoubleUint32, status: _getRandomStatus),
      version,
    );
  }

  void _sendNewCurrentCallback({
    DataSourceProtocolVersion version = DataSourceProtocolVersion.subscription,
  }) {
    _updateValueCallback(
      const DataSourceParameterId.current(),
      Current(value: randomDoubleUint32, status: _getRandomStatus),
      version,
    );
  }

  void _sendNewLowVoltageCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.lowVoltageMinMaxDelta().value,
      convertible: LowVoltageMinMaxDelta(
        min: Random().nextDouble() * 65535,
        max: Random().nextDouble() * 65535,
        delta: Random().nextDouble() * 65535,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendHighVoltageCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.highVoltage().value,
      convertible: HighVoltage(
        value: Random().nextDouble() * 4294967,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendHighCurrentCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.highCurrent().value,
      convertible: HighCurrent(
        value: (Random().nextDouble() * 2147483).randomSign,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendMaxTemperatureCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.maxTemperature().value,
      convertible: MaxTemperature(
        value: randomInt8,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendTemperatureFirstBatchCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.temperatureFirstBatch().value,
      convertible: BatteryTemperatureFirstBatch(
        balancer: randomInt8,
        mos: randomInt8,
        first: randomInt8,
        second: randomInt8,
        third: randomInt8,
        fourth: randomInt8,
        fifth: randomInt8,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendTemperatureSecondBatchCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.temperatureSecondBatch().value,
      convertible: BatteryTemperatureSecondBatch(
        sixth: randomInt8,
        seventh: randomInt8,
        eighth: randomInt8,
        ninth: randomInt8,
        tenth: randomInt8,
        eleventh: randomInt8,
        twelfth: randomInt8,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendTemperatureThirdBatchCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.temperatureThirdBatch().value,
      convertible: BatteryTemperatureThirdBatch(
        thirteenth: randomInt8,
        fourteenth: randomInt8,
        fifteenth: randomInt8,
        sixteenth: randomInt8,
        seventeenth: randomInt8,
        eighteenth: randomInt8,
        nineteenth: randomInt8,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageOneToThreeCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.lowVoltageOneToThree().value,
      convertible: BatteryLowVoltageOneToThree(
        first: randomDoubleUint16,
        second: randomDoubleUint16,
        third: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageFourToSixCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.lowVoltageFourToSix().value,
      convertible: BatteryLowVoltageFourToSix(
        fourth: randomDoubleUint16,
        fifth: randomDoubleUint16,
        sixth: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageSevenToNineCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.lowVoltageSevenToNine().value,
      convertible: BatteryLowVoltageSevenToNine(
        seventh: randomDoubleUint16,
        eighth: randomDoubleUint16,
        ninth: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageTenToTwelveCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId: const DataSourceParameterId.lowVoltageTenToTwelve().value,
      convertible: BatteryLowVoltageTenToTwelve(
        tenth: randomDoubleUint16,
        eleventh: randomDoubleUint16,
        twelfth: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageThirteenToFifteenCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId:
          const DataSourceParameterId.lowVoltageThirteenToFifteen().value,
      convertible: BatteryLowVoltageThirteenToFifteen(
        thirteenth: randomDoubleUint16,
        fourteenth: randomDoubleUint16,
        fifteenth: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageSixteenToEighteenCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId:
          const DataSourceParameterId.lowVoltageSixteenToEighteen().value,
      convertible: BatteryLowVoltageSixteenToEighteen(
        sixteenth: randomDoubleUint16,
        seventeenth: randomDoubleUint16,
        eighteenth: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageNineteenToTwentyOneCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId:
          const DataSourceParameterId.lowVoltageNineteenToTwentyOne().value,
      convertible: BatteryLowVoltageNineteenToTwentyOne(
        nineteenth: randomDoubleUint16,
        twentieth: randomDoubleUint16,
        twentyFirst: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  void _sendLowVoltageTwentyTwoToTwentyFourCallback() {
    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: 0x95, // 10010101(incoming 0x15)
      parameterId:
          const DataSourceParameterId.lowVoltageTwentyTwoToTwentyFour().value,
      convertible: BatteryLowVoltageTwentyTwoToTwentyFour(
        twentySecond: randomDoubleUint16,
        twentyThird: randomDoubleUint16,
        twentyFourth: randomDoubleUint16,
        status: _getRandomStatus,
      ),
    );

    observe(package);

    controller.sink.add(package);
  }

  PeriodicValueStatus get _getRandomStatus {
    return PeriodicValueStatus.values[Random().nextInt(
      PeriodicValueStatus.values.length,
    )];
  }

  int get randomInt8 {
    return Random().nextInt(128).randomSign;
  }

  double get randomDoubleUint16 => Random().nextDouble() * 0xFFFF;
  double get randomDoubleUint32 => Random().nextDouble() * 0xFFFFFFFF;

  void _updateValueCallback(
    DataSourceParameterId parameterId,
    // int value,
    BytesConvertible convertible,
    DataSourceProtocolVersion version,
  ) {
    final requestType = version.when(
      subscription: () => 0x95, //'10010101'
      periodicRequests: () => 0x81, //'10000001'
    );

    final package = DataSourceIncomingPackage.fromConvertible(
      secondConfigByte: requestType,
      parameterId: parameterId.value,
      convertible: convertible,
    );

    observe(package);

    controller.sink.add(package);
  }
}

extension NumExtension<T extends num> on T {
  T get randomSign {
    return Random().nextBool() ? this * -1 as T : this;
  }
}
