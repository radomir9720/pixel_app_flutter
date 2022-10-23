import 'package:collection/collection.dart';
import 'package:crclib/catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

extension UintListToInt on List<int> {
  int get toInt {
    return int.parse(
      map((e) => e.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16,
    );
  }
}

class DataSourcePackage extends UnmodifiableListView<int> {
  DataSourcePackage(super.source) {
    validatePackage();
  }

  factory DataSourcePackage.fromBody(List<int> body) {
    return DataSourcePackage([
      startingByte,
      ...body,
      ...calculateCheckSum(body),
      endingByte,
    ]);
  }

  factory DataSourcePackage.builder({
    int firstConfigByte = 0x00,
    required int secondConfigByte,
    required int parameterId,
    int? data,
  }) {
    final body = <int>[
      firstConfigByte,
      secondConfigByte,
      ...parameterId.toTwoBytes,
      dataBytesLength(data),
      ...dataToBytes(data),
    ];

    return DataSourcePackage([
      startingByte,
      ...body,
      ...calculateCheckSum(body),
      endingByte,
    ]);
  }

  static DataSourcePackage? instanceOrNUll(List<int> package) {
    try {
      return DataSourcePackage(package);
    } catch (e) {
      return null;
    }
  }

  static int dataBytesLength(int? data) {
    if (data == null) return 0;
    final bits = (data.bitLength / 8).ceil();
    return bits.clamp(1, 100);
  }

  /// If [fixedBytesLenght] is not null, then bytes length will be set to this
  /// value, and element count in returned list will be equal to
  /// [fixedBytesLenght]
  static List<int> dataToBytes(
    int? data, {
    int? fixedBytesLenght,
  }) {
    if (data == null) {
      if (fixedBytesLenght != null) {
        return List.filled(fixedBytesLenght, 0);
      }
      return const [];
    }
    final bytesLength = fixedBytesLenght ?? dataBytesLength(data);

    return data
        .toRadixString(16)
        .padLeft(bytesLength * 2, '0')
        .split('')
        .splitAfterIndexed((index, element) => index.isOdd)
        .map((e) => int.parse(e.join(), radix: 16))
        .toList();
  }

  Uint8List get toUint8List => Uint8List.fromList(this);

  static const startingByte = 0x3c;
  static const endingByte = 0x3e;

  void validatePackage() {
    if (length < 9) {
      throw NotEnoughBytesDataSourcePackageException(length);
    }
    // Check starting byte
    if (this[0] != startingByte) {
      throw const InvalidStartingByteDataSourcePackageException();
    }
    // Check ending byte
    if (this[length - 1] != endingByte) {
      throw InvalidEndingByteDataSourcePackageException(this);
    }

    final checkSum = sublist(length - 3, length - 1);
    final calculatedCheckSum = calculateCheckSum(body);
    if (!const DeepCollectionEquality().equals(checkSum, calculatedCheckSum)) {
      throw WrongCheckSumDataSourcePackageException(
        packageCheckSum: checkSum,
        calculatedCheckSum: calculatedCheckSum,
        body: body,
        package: this,
      );
    }
  }

  // From 1(skipping starting byte),
  // to length - 3(-1 ending byte, - 2 checksum bytes))
  List<int> get body => sublist(1, length - 3);

  static List<int> calculateCheckSum(List<int> body) {
    final checkSum =
        Crc16Mcrf4xx().convert(body).toRadixString(16).padLeft(4, '0');

    final firstCheckSumByte = int.parse(checkSum.substring(0, 2), radix: 16);
    final secondCheckSumByte = int.parse(checkSum.substring(2), radix: 16);
    return [firstCheckSumByte, secondCheckSumByte];
  }

  String get secondConfigByte {
    // Contains request type and direction flag
    final configByte = this[2];
    return configByte.toRadixString(2).padLeft(8, '0');
  }

  int get directionFlag {
    // 0 - device to MainECU, 1 - MainECU to Device
    return int.parse(secondConfigByte[0]);
  }

  int get requestType {
    // request type is in the last 5 bits
    final last5bits = secondConfigByte.substring(3);
    return int.parse(last5bits, radix: 2);
  }

  int get firstParameterIDByte => this[3];
  int get secondParameterIDByte => this[4];

  int get parameterId {
    return int.parse(
      firstParameterIDByte.toRadixString(2) +
          secondParameterIDByte.toRadixString(2),
      radix: 2,
    );
  }

  int get dataLength => this[5];

  List<int> get data => sublist(6, 6 + dataLength);

  bool checkTypeAndDirectionIdentity({
    required int type,
    required int direction,
  }) {
    return type == requestType && directionFlag == direction;
  }
}

class DataSourcePackageException implements Exception {
  const DataSourcePackageException(this.message);

  final String message;

  @override
  String toString() {
    return 'DataSourcePackageException: $message';
  }
}

class NotEnoughBytesDataSourcePackageException
    extends DataSourcePackageException {
  const NotEnoughBytesDataSourcePackageException(int length)
      : super('Not enough bytes. Required at least 9. Received: $length');
}

class InvalidStartingByteDataSourcePackageException
    extends DataSourcePackageException {
  const InvalidStartingByteDataSourcePackageException()
      : super('Invalid starting byte');
}

class InvalidEndingByteDataSourcePackageException
    extends DataSourcePackageException {
  const InvalidEndingByteDataSourcePackageException(List<int> package)
      : super('Invalid ending byte. Package: $package');
}

class WrongCheckSumDataSourcePackageException
    extends DataSourcePackageException {
  const WrongCheckSumDataSourcePackageException({
    required List<int> packageCheckSum,
    required List<int> calculatedCheckSum,
    required List<int> body,
    required List<int> package,
  }) : super(
          'Wrong checkSum. Package checkSum: $packageCheckSum. '
          'Calculated checkSum: $calculatedCheckSum. '
          'Body: $body. '
          'Package: $package',
        );
}
