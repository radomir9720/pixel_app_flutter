import 'dart:typed_data';

// import 'package:byte_extensions/byte_extensions.dart';

extension ToBytesExtension on int {
  Int8List get toBytesInt8 {
    final data = ByteData(Int8List.bytesPerElement)..setInt8(0, this);
    return data.buffer.asInt8List();
  }

  Uint8List get toBytesUint8 {
    final data = ByteData(Uint8List.bytesPerElement)..setUint8(0, this);
    return data.buffer.asUint8List();
  }

  Int8List get toBytesInt16 {
    final data = ByteData(Int16List.bytesPerElement)..setInt16(0, this);
    return data.buffer.asInt8List();
  }

  Uint8List get toBytesUint16 {
    final data = ByteData(Uint16List.bytesPerElement)..setUint16(0, this);
    return data.buffer.asUint8List();
  }

  Int8List get toBytesInt32 {
    final data = ByteData(Int32List.bytesPerElement)..setInt32(0, this);
    return data.buffer.asInt8List();
  }

  Uint8List get toBytesUint32 {
    final data = ByteData(Uint32List.bytesPerElement)..setUint32(0, this);
    return data.buffer.asUint8List();
  }
}

extension AsIntBytesExtension on List<int> {
  int get toIntFromInt8 {
    return Int8List.fromList(this).buffer.asByteData().getInt8(0);
  }

  int get toIntFromUint8 {
    return Uint8List.fromList(this).buffer.asByteData().getUint8(0);
  }

  int get toIntFromInt16 {
    return Int8List.fromList(this).buffer.asByteData().getInt16(0);
  }

  int get toIntFromUint16 {
    return Uint8List.fromList(this).buffer.asByteData().getUint16(0);
  }

  int get toIntFromInt32 {
    return Int8List.fromList(this).buffer.asByteData().getInt32(0);
  }

  int get toIntFromUint32 {
    return Uint8List.fromList(this).buffer.asByteData().getUint32(0);
  }
}

extension FromMilliExtension on int {
  double get fromMilli => this / 1000;
}
