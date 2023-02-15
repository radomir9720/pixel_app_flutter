import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:re_seedwork/re_seedwork.dart';

@immutable
class ApplicationInfo {
  const ApplicationInfo({
    this.name,
    this.icon,
    this.packageName,
    this.versionName,
    this.versionCode,
    this.pinned = false,
  });

  factory ApplicationInfo.fromMap(Map<String, dynamic> map) {
    return ApplicationInfo(
      name: map.tryParse<String>('name'),
      icon:
          map.tryParseAndMap<Uint8List, List<int>>('icon', Uint8List.fromList),
      packageName: map.tryParse<String>('packageName'),
      versionName: map.tryParse<String>('versionName'),
      versionCode: map.tryParse<int>('versionCode'),
      pinned: map.tryParse<bool>('pinned') ?? false,
    );
  }

  factory ApplicationInfo.fromJson(String source) =>
      ApplicationInfo.fromMap(jsonDecode(source) as Map<String, dynamic>);

  final String? name;
  final Uint8List? icon;
  final String? packageName;
  final String? versionName;
  final int? versionCode;
  final bool pinned;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // final listEquals = const DeepCollectionEquality().equals;

    return other is ApplicationInfo &&
        other.name == name &&
        // listEquals(other.icon, icon) &&
        other.packageName == packageName &&
        other.versionName == versionName &&
        other.versionCode == versionCode &&
        other.pinned == pinned;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        // icon.hashCode ^
        packageName.hashCode ^
        versionName.hashCode ^
        versionCode.hashCode ^
        pinned.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon?.toList(),
      'packageName': packageName,
      'versionName': versionName,
      'versionCode': versionCode,
      'pinned': pinned,
    };
  }

  String toJson() => jsonEncode(toMap());

  @override
  String toString() {
    return toJson();
  }

  ApplicationInfo copyWith({
    String? name,
    Uint8List? icon,
    String? packageName,
    String? versionName,
    int? versionCode,
    bool? pinned,
  }) {
    return ApplicationInfo(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      packageName: packageName ?? this.packageName,
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      pinned: pinned ?? this.pinned,
    );
  }
}
