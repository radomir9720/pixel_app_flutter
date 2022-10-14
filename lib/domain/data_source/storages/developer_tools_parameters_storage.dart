import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class DeveloperToolsParametersStorage
    extends ValueStore<DeveloperToolsParameters> {
  DeveloperToolsParametersStorage();

  Future<Result<DeveloperToolsParametersWriteError, void>> write(
    DeveloperToolsParameters parameters,
  );

  Result<DeveloperToolsParametersReadError, DeveloperToolsParameters> read();

  Future<Result<DeveloperToolsParametersRemoveError, void>> remove();

  DeveloperToolsParameters get defaultValue;
}

enum DeveloperToolsParametersWriteError { unknown }

enum DeveloperToolsParametersReadError { unknown, noValue }

enum DeveloperToolsParametersRemoveError { unknown }
