import 'package:injectable/injectable.dart';
import 'package:installed_apps/app_info.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef GetInstalledAppsCallback = Future<List<AppInfo>> Function([
  // ignore: avoid_positional_boolean_parameters
  bool excludeSystemApps,
  bool withIcon,
  String packageNamePrefix,
]);

typedef StartAppCallback = Future<bool?> Function(String packageName);

@Injectable(as: AppsService)
class AppsServiceImpl implements AppsService {
  const AppsServiceImpl({
    required this.getInstalledAppsCallback,
    required this.startAppCallback,
  });

  @protected
  final GetInstalledAppsCallback getInstalledAppsCallback;

  @protected
  final StartAppCallback startAppCallback;

  @override
  Future<Result<GetAppsListAppServiceError, List<ApplicationInfo>>>
      getAppsList({
    bool excludeSystemApps = true,
    bool withIcon = true,
    String packageNamePrefix = '',
  }) async {
    final res = await getInstalledAppsCallback(
      excludeSystemApps,
      withIcon,
      packageNamePrefix,
    );

    final apps = res
        .map(
          (e) => ApplicationInfo(
            icon: e.icon,
            name: e.name,
            packageName: e.packageName,
            versionCode: e.versionCode,
            versionName: e.versionName,
          ),
        )
        .toList();

    return Result.value(apps);
  }

  @override
  Future<Result<StartAppAppsServiceError, void>> startApp(
    String packageName,
  ) async {
    final success = await startAppCallback(packageName) ?? false;
    if (!success) return const Result.error(StartAppAppsServiceError.unknown);
    return const Result.value(null);
  }
}
