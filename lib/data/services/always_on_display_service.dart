import 'package:injectable/injectable.dart';
import 'package:pixel_app_flutter/domain/settings/settings.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:wakelock/wakelock.dart';

@Injectable(as: AlwaysOnDisplayService)
class AlwaysOnDisplayServiceImpl implements AlwaysOnDisplayService {
  const AlwaysOnDisplayServiceImpl();

  @override
  Future<Result<AlwaysOnDisplayToggleError, bool>> toggle({
    required bool enable,
  }) async {
    await Wakelock.toggle(enable: enable);
    final enabled = await Wakelock.enabled;
    return Result.value(enabled);
  }
}
