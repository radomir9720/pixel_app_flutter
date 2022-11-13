import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class ApplicationInfo {
  const ApplicationInfo({
    this.name,
    this.icon,
    this.packageName,
    this.versionName,
    this.versionCode,
  });

  factory ApplicationInfo.fromMap(Map<String, dynamic> map) {
    return ApplicationInfo(
      name: map['name'] as String?,
      icon: map['icon'] != null
          ? Uint8List.fromList(map['icon'] as List<int>)
          : null,
      packageName: map['packageName'] as String?,
      versionName: map['versionName'] as String?,
      versionCode: map['versionCode'] as int?,
    );
  }

  factory ApplicationInfo.fromJson(String source) =>
      ApplicationInfo.fromMap(jsonDecode(source) as Map<String, dynamic>);

  final String? name;
  final Uint8List? icon;
  final String? packageName;
  final String? versionName;
  final int? versionCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApplicationInfo &&
        other.name == name &&
        other.icon == icon &&
        other.packageName == packageName &&
        other.versionName == versionName &&
        other.versionCode == versionCode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        icon.hashCode ^
        packageName.hashCode ^
        versionName.hashCode ^
        versionCode.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon?.toList(),
      'packageName': packageName,
      'versionName': versionName,
      'versionCode': versionCode,
    };
  }

  String toJson() => jsonEncode(toMap());

  @override
  String toString() {
    return toJson();
  }
}
