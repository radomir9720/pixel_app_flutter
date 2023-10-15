import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class ActionBody extends BytesConvertible {
  const ActionBody();

  @override
  BytesConverter<ActionBody> get bytesConverter => const ActionBodyConverter();

  @override
  List<Object?> get props => [];
}

class ActionBodyConverter extends BytesConverter<ActionBody> {
  const ActionBodyConverter();

  @override
  ActionBody fromBytes(List<int> bytes) => const ActionBody();

  @override
  List<int> toBytes(ActionBody model) {
    return [FunctionId.action.value];
  }
}
