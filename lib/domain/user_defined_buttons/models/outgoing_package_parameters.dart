import 'package:flutter/foundation.dart';

import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';

@immutable
class OutgoingPackageParameters {
  const OutgoingPackageParameters({
    required this.requestType,
    required this.parameterId,
    this.data = const [],
  });

  factory OutgoingPackageParameters.fromMap(Map<String, dynamic> map) {
    return OutgoingPackageParameters(
      requestType: map.parseRequestType,
      parameterId: map.parseParameterId,
      data: map.parseData,
    );
  }

  final int requestType;
  final int parameterId;
  final List<int> data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OutgoingPackageParameters &&
        other.requestType == requestType &&
        other.parameterId == parameterId &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode =>
      requestType.hashCode ^ parameterId.hashCode ^ data.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'requestType': requestType,
      'parameterId': parameterId,
      'data': data,
    };
  }

  OutgoingPackageParameters copyWith({
    int? requestType,
    int? parameterId,
    List<int>? data,
  }) {
    return OutgoingPackageParameters(
      requestType: requestType ?? this.requestType,
      parameterId: parameterId ?? this.parameterId,
      data: data ?? this.data,
    );
  }
}

extension OutgoingPackageParametersMapperExtension
    on Iterable<OutgoingPackageParameters> {
  List<Map<String, dynamic>> toMap() => [...map((e) => e.toMap())];
}
