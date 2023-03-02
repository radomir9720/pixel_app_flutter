import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:re_seedwork/re_seedwork.dart';

@sealed
@immutable
class AndroidUsbDeviceData {
  const AndroidUsbDeviceData({
    this.vid,
    this.pid,
    this.deviceName,
    this.deviceId,
    this.productName,
  });

  factory AndroidUsbDeviceData.fromJson(String source) =>
      AndroidUsbDeviceData.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory AndroidUsbDeviceData.fromMap(Map<String, dynamic> map) {
    return AndroidUsbDeviceData(
      vid: map.tryParse<int>('vid'),
      pid: map.tryParse<int>('pid'),
      deviceId: map.tryParse<int>('deviceId'),
      deviceName: map.tryParse<String>('deviceName'),
      productName: map.tryParse<String>('productName'),
    );
  }
  final int? vid;
  final int? pid;
  final int? deviceId;
  final String? deviceName;
  final String? productName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AndroidUsbDeviceData &&
        other.vid == vid &&
        other.pid == pid &&
        other.productName == productName;
  }

  @override
  int get hashCode => vid.hashCode ^ pid.hashCode ^ productName.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'vid': vid,
      'pid': pid,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'productName': productName,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'AndroidUsbDeviceData(vid: $vid, '
        'pid: $pid, '
        'deviceId: $deviceId, '
        'deviceName: $deviceName, '
        'productName: $productName)';
  }
}
