import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/periodic_value_status.dart';

abstract class BytesConvertibleWithStatus
    with EquatableMixin
    implements BytesConvertible {
  const BytesConvertibleWithStatus({required this.status});

  BytesConvertibleWithStatus.fromId(int id)
      : status = PeriodicValueStatus.fromId(id);

  const BytesConvertibleWithStatus.normal()
      : status = PeriodicValueStatus.normal;

  final PeriodicValueStatus status;

  @override
  List<int> get toBytes => bytesConverter.toBytes(this);

  @override
  List<Object?> get props => [status];
}
