import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

mixin SendPackagesMixin on DataSource {
  @override
  Future<Result<SendPackageError, void>> sendPackages(
    List<DataSourceOutgoingPackage> packages,
  ) async {
    for (final package in packages) {
      final result = await sendPackage(package);
      if (result.isError) return result;
    }
    return const Result.value(null);
  }
}
