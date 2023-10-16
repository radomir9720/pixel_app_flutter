import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/set_value.dart';

final class SetInt8Body extends SetValueBody {
  const SetInt8Body({required this.value});

  final int value;

  @override
  SetValueConverter<SetInt8Body> get bytesConverter =>
      const SetInt8BodyConverter();

  @override
  List<Object?> get props => [value];
}

final class SetInt8BodyConverter extends SetValueConverter<SetInt8Body> {
  const SetInt8BodyConverter();

  @override
  List<int> getBodyBytes(SetInt8Body model) {
    return model.value.toBytesInt8;
  }
}
