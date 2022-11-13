import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class AppsService {
  const AppsService();

  Future<Result<GetAppsListAppServiceError, List<ApplicationInfo>>>
      getAppsList({
    bool excludeSystemApps = true,
    bool withIcon = true,
    String packageNamePrefix = '',
  });

  Future<Result<StartAppAppsServiceError, void>> startApp(
    String packageName,
  );
}

enum GetAppsListAppServiceError { unknown }

enum StartAppAppsServiceError { unknown }
