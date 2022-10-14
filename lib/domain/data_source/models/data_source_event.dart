import 'package:flutter/foundation.dart';

import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

extension ToTwoBytesExtension on int {
  List<int> get toTwoBytes {
    final radix16 = toRadixString(16).padLeft(4, '0');

    final firstByte = int.parse(radix16.substring(0, 2), radix: 16);
    final secondByte = int.parse(radix16.substring(2), radix: 16);
    return [firstByte, secondByte];
  }
}

abstract class DataSourceEvent {
  const DataSourceEvent();

  static List<DataSourceIncomingEvent Function(DataSourcePackage package)>
      eventBuilders = [
    DataSourceUpdateValueIncomingEvent.new,
    DataSourceHandshakeIncomingEvent.new,
    DataSourceGetParameterValueIncomingEvent.new,
  ];

  static DataSourceIncomingEvent fromPackage(DataSourcePackage package) {
    for (final eventBuilder in eventBuilders) {
      final event = eventBuilder(package);
      final typeAndDirectionMatch = package.checkTypeAndDirectionIdentity(
        type: event.requestType,
        direction: event.requestDirection,
      );

      if (typeAndDirectionMatch) return event;
    }

    throw NoEventFoundWithGivenDirectionAndTypeDataSourceEventException(
      directionFlag: package.directionFlag,
      requestType: package.requestType,
    );
  }

  Uint8List toPackage() => DataSourcePackage.fromBody(body).toUint8List;

  List<int> get body;

  int get requestType;

  int get requestDirection; // 0 - outgoing, 1 - incoming

  R whenDirection<R>({
    required R Function() incoming,
    required R Function() outgoing,
  }) {
    switch (requestDirection) {
      case 0:
        return outgoing();
      case 1:
        return incoming();
    }
    throw UnimplementedError('Unknown request direction id: $requestDirection');
  }
}

abstract class DataSourceOutgoingEvent extends DataSourceEvent {
  const DataSourceOutgoingEvent();

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? subscribe,
    R Function(ParameterId id)? unsubscribe,
  });

  @override
  int get requestDirection => 0;
}

abstract class DataSourceIncomingEvent extends DataSourceEvent {
  const DataSourceIncomingEvent(this.package);

  final DataSourcePackage package;

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? updateValue,
  });

  @override
  List<int> get body => package.body;

  @override
  int get requestDirection => 1;
}

class DataSourceHandshakeOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceHandshakeOutgoingEvent();

  @override
  List<int> get body => [
        0x00, // Config byte 1
        requestType, // Config byte 2
        0x00, // parameter id(first byte)
        0x00, // parameter id(second byte)
        0x00, // data length
      ];

  @override
  int get requestType => 0x10;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? subscribe,
    R Function(ParameterId id)? unsubscribe,
  }) {
    return handshake?.call() ?? orElse();
  }
}

class DataSourceHandshakeIncomingEvent extends DataSourceIncomingEvent {
  const DataSourceHandshakeIncomingEvent(super.package);

  @override
  int get requestType => 0x10;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? updateValue,
  }) {
    return handshake?.call() ?? orElse();
  }
}

class DataSourceGetParameterValueIncomingEvent extends DataSourceIncomingEvent {
  DataSourceGetParameterValueIncomingEvent(super.package);

  @override
  int get requestType => 0x01;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? updateValue,
  }) {
    return getParameterValue?.call(ParameterId.fromInt(package.parameterId)) ??
        orElse();
  }
}

class DataSourceGetParameterValueOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceGetParameterValueOutgoingEvent(this.id);

  final ParameterId id;

  @override
  List<int> get body => [
        0x00, // Config byte 1
        requestType, // Config byte 2,
        ...id.value.toTwoBytes, // parameter id. Two bytes
        0x00, // data length,
      ];

  @override
  int get requestType => 0x01;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? subscribe,
    R Function(ParameterId id)? unsubscribe,
  }) {
    return getParameterValue?.call(id) ?? orElse();
  }
}

class DataSourceSubscribeOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceSubscribeOutgoingEvent(this.id);

  final ParameterId id;

  @override
  int get requestType => 0x11;

  @override
  List<int> get body => [
        0x00, // Config byte 1
        requestType, // Config byte 2,
        ...id.value.toTwoBytes, // parameter id. Two bytes
        0x00, // data length,
      ];

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? subscribe,
    R Function(ParameterId id)? unsubscribe,
  }) {
    return subscribe?.call(id) ?? orElse();
  }
}

class DataSourceUnsubscribeOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceUnsubscribeOutgoingEvent(this.id);

  final ParameterId id;

  @override
  List<int> get body => [
        0x00, // Config byte 1
        requestType, // Config byte 2,
        ...(id.value + 0x8000).toTwoBytes, // parameter id. Two bytes
        0x00, // data length,
      ];

  @override
  int get requestType => 0x11;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? subscribe,
    R Function(ParameterId id)? unsubscribe,
  }) {
    return unsubscribe?.call(id) ?? orElse();
  }
}

class DataSourceUpdateValueIncomingEvent extends DataSourceIncomingEvent {
  const DataSourceUpdateValueIncomingEvent(
    super.packageBody,
  );

  @override
  int get requestType => 0x15;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(ParameterId id)? getParameterValue,
    R Function(ParameterId id)? updateValue,
  }) {
    return updateValue?.call(ParameterId.fromInt(package.parameterId)) ??
        orElse();
  }
}

class DataSourceEventException implements Exception {
  const DataSourceEventException(this.message);

  final String message;

  @override
  String toString() {
    return 'DataSourceEventException: $message';
  }
}

class NoEventFoundWithGivenDirectionAndTypeDataSourceEventException
    extends DataSourceEventException {
  const NoEventFoundWithGivenDirectionAndTypeDataSourceEventException({
    required int directionFlag,
    required int requestType,
  }) : super('No event found with flag direction $directionFlag '
            'and request type "$requestType"');
}
