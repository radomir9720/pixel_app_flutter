import 'package:meta/meta.dart';
import 'package:re_seedwork/re_seedwork.dart';

@immutable
final class IncomingPackageGetter {
  const IncomingPackageGetter({
    required this.requestType,
    required this.parameterId,
    this.functionId,
  });

  factory IncomingPackageGetter.fromMap(Map<String, dynamic> map) {
    return IncomingPackageGetter(
      requestType: map.parse('requestType'),
      parameterId: map.parse('parameterId'),
      functionId: map.tryParse('functionId'),
    );
  }

  bool satisfies({
    required int requestType,
    required int parameterId,
    int? functionId,
  }) {
    return requestType == this.requestType &&
        parameterId == this.parameterId &&
        (this.functionId == null || functionId == this.functionId);
  }

  final int requestType;
  final int parameterId;
  final int? functionId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomingPackageGetter &&
        other.requestType == requestType &&
        other.parameterId == parameterId &&
        other.functionId == functionId;
  }

  @override
  int get hashCode =>
      requestType.hashCode ^ parameterId.hashCode ^ functionId.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'requestType': requestType,
      'parameterId': parameterId,
      'functionId': functionId,
    };
  }
}
