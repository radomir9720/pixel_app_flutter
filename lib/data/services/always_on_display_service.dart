import 'package:injectable/injectable.dart';
import 'package:pixel_app_flutter/domain/settings/settings.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

@Injectable(as: AlwaysOnDisplayService)
class AlwaysOnDisplayServiceImpl implements AlwaysOnDisplayService {
  const AlwaysOnDisplayServiceImpl();

  @override
  Future<Result<AlwaysOnDisplayToggleError, bool>> toggle({
    required bool enable,
  }) async {
    await WakelockPlus.toggle(enable: enable);
    final enabled = await WakelockPlus.enabled;
    return Result.value(enabled);
  }
}
