import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class ErrorWithCodeAndSectionPackageData extends BytesConvertible
    with EquatableMixin {
  const ErrorWithCodeAndSectionPackageData({
    required this.code,
    required this.section,
    required this.functionId,
  });

  final int code;
  final int section;
  final int functionId;

  @override
  BytesConverter<ErrorWithCodeAndSectionPackageData> get bytesConverter =>
      const ErrorWithCodeAndSectionConverter();

  @override
  List<Object?> get props => [code, section, functionId];
}

class ErrorWithCodeAndSectionConverter
    extends BytesConverter<ErrorWithCodeAndSectionPackageData> {
  const ErrorWithCodeAndSectionConverter();

  @override
  ErrorWithCodeAndSectionPackageData fromBytes(List<int> bytes) {
    return ErrorWithCodeAndSectionPackageData(
      functionId: bytes[0],
      section: bytes[1],
      code: bytes[2],
    );
  }

  @override
  List<int> toBytes(ErrorWithCodeAndSectionPackageData model) {
    return [
      model.functionId,
      model.section,
      model.code,
    ];
  }
}
