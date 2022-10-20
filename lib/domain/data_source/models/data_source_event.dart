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

  int get parameterId;

  R whenDirection<R>({
    required R Function() incoming,
    required R Function() outgoing,
  }) {
    return DataSourceRequestDirection.fromInt(requestDirection).when(
      outgoing: outgoing,
      incoming: incoming,
    );
  }
}

abstract class DataSourceOutgoingEvent extends DataSourceEvent {
  const DataSourceOutgoingEvent({required this.id, this.data});

  final DataSourceParameterId id;

  final int? data;

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? subscribe,
    R Function(DataSourceParameterId id)? unsubscribe,
  });

  @override
  int get requestDirection => DataSourceRequestDirection.outgoing.value;

  @override
  int get parameterId => id.value;

  int get firstConfigByte => 0x00;

  int? get fixedBytesDataLength => null;

  @override
  List<int> get body => [
        firstConfigByte,
        requestType, // Config byte 2,
        ...id.value.toTwoBytes, // parameter id. Two bytes
        fixedBytesDataLength ?? DataSourcePackage.dataBytesLength(data),
        ...DataSourcePackage.dataToBytes(
          data,
          fixedBytesLenght: fixedBytesDataLength,
        ),
      ];
}

abstract class DataSourceIncomingEvent extends DataSourceEvent {
  const DataSourceIncomingEvent(this.package);

  final DataSourcePackage package;

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? updateValue,
  });

  @override
  List<int> get body => package.body;

  @override
  int get parameterId => package.parameterId;

  @override
  int get requestDirection => package.directionFlag;
}

// Outgoing events

class DataSourceHandshakeOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceHandshakeOutgoingEvent.initial(int data)
      : super(id: const DataSourceParameterId.custom(0), data: data);

  const DataSourceHandshakeOutgoingEvent.ping(int data)
      : super(id: const DataSourceParameterId.custom(0xFFFF), data: data);

  @override
  int get requestType => DataSourceRequestType.handshake.value;

  @override
  int? get fixedBytesDataLength => 4;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? subscribe,
    R Function(DataSourceParameterId id)? unsubscribe,
  }) {
    return handshake?.call() ?? orElse();
  }
}

class DataSourceGetParameterValueOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceGetParameterValueOutgoingEvent({required super.id});

  @override
  int get requestType => DataSourceRequestType.bufferRequest.value;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? subscribe,
    R Function(DataSourceParameterId id)? unsubscribe,
  }) {
    return getParameterValue?.call(id) ?? orElse();
  }
}

class DataSourceSubscribeOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceSubscribeOutgoingEvent({required super.id});

  @override
  int get requestType => DataSourceRequestType.subscription.value;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? subscribe,
    R Function(DataSourceParameterId id)? unsubscribe,
  }) {
    return subscribe?.call(id) ?? orElse();
  }
}

class DataSourceUnsubscribeOutgoingEvent extends DataSourceOutgoingEvent {
  const DataSourceUnsubscribeOutgoingEvent({required super.id});

  @override
  List<int> get body => [
        0x00, // Config byte 1
        requestType, // Config byte 2,
        ...(id.value + 0x8000).toTwoBytes, // parameter id. Two bytes
        0x00, // data length,
      ];

  @override
  int get requestType => DataSourceRequestType.subscription.value;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? subscribe,
    R Function(DataSourceParameterId id)? unsubscribe,
  }) {
    return unsubscribe?.call(id) ?? orElse();
  }
}

// Incoming events
class DataSourceHandshakeIncomingEvent extends DataSourceIncomingEvent {
  const DataSourceHandshakeIncomingEvent(super.package);

  @override
  int get requestType => DataSourceRequestType.handshake.value;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? updateValue,
  }) {
    return handshake?.call() ?? orElse();
  }
}

class DataSourceGetParameterValueIncomingEvent extends DataSourceIncomingEvent {
  DataSourceGetParameterValueIncomingEvent(super.package);

  @override
  int get requestType => DataSourceRequestType.bufferRequest.value;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? updateValue,
  }) {
    return getParameterValue
            ?.call(DataSourceParameterId.fromInt(package.parameterId)) ??
        orElse();
  }
}

class DataSourceUpdateValueIncomingEvent extends DataSourceIncomingEvent {
  const DataSourceUpdateValueIncomingEvent(
    super.packageBody,
  );

  @override
  int get requestType => DataSourceRequestType.valueUpdate.value;

  @override
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? handshake,
    R Function(DataSourceParameterId id)? getParameterValue,
    R Function(DataSourceParameterId id)? updateValue,
  }) {
    return updateValue
            ?.call(DataSourceParameterId.fromInt(package.parameterId)) ??
        orElse();
  }
}

// Exceptions
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
