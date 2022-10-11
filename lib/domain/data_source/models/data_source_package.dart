import 'package:collection/collection.dart';
import 'package:crclib/catalog.dart';
import 'package:flutter/foundation.dart';

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
      throw const InvalidEndingByteDataSourcePackageException();
    }

    final checkSum = sublist(length - 3, length - 1);
    final calculatedCheckSum = calculateCheckSum(body);
    if (!const DeepCollectionEquality().equals(checkSum, calculatedCheckSum)) {
      throw WrongCheckSumDataSourcePackageException(
        packageCheckSum: checkSum,
        calculatedCheckSum: calculatedCheckSum,
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
  const InvalidEndingByteDataSourcePackageException()
      : super('Invalid ending byte');
}

class WrongCheckSumDataSourcePackageException
    extends DataSourcePackageException {
  const WrongCheckSumDataSourcePackageException({
    required List<int> packageCheckSum,
    required List<int> calculatedCheckSum,
  }) : super(
          'Wrong checkSum. Package checkSum: $packageCheckSum '
          'Calculated checkSum: $calculatedCheckSum',
        );
}
