import 'package:meta/meta.dart';

@immutable
class UsbPortParametersConfig {
  const UsbPortParametersConfig({
    this.baudRate = 115200,
    this.dataBits = 8,
    this.stopBits = 1,
    this.parity = 0,
  });

  final int baudRate;
  final int dataBits;
  final int stopBits;
  final int parity;

  UsbPortParametersConfig copyWith({
    int? baudRate,
    int? dataBits,
    int? stopBits,
    int? parity,
  }) {
    return UsbPortParametersConfig(
      baudRate: baudRate ?? this.baudRate,
      dataBits: dataBits ?? this.dataBits,
      stopBits: stopBits ?? this.stopBits,
      parity: parity ?? this.parity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UsbPortParametersConfig &&
        other.baudRate == baudRate &&
        other.dataBits == dataBits &&
        other.stopBits == stopBits &&
        other.parity == parity;
  }

  @override
  int get hashCode {
    return baudRate.hashCode ^
        dataBits.hashCode ^
        stopBits.hashCode ^
        parity.hashCode;
  }

  @override
  String toString() {
    return 'UsbPortParametersConfig(baudRate: $baudRate, '
        'dataBits: $dataBits, '
        'stopBits: $stopBits, '
        'parity: $parity)';
  }
}
