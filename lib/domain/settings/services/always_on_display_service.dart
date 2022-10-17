import 'package:re_seedwork/re_seedwork.dart';

abstract class AlwaysOnDisplayService {
  const AlwaysOnDisplayService();

  Future<Result<AlwaysOnDisplayToggleError, bool>> toggle({
    required bool enable,
  });
}

enum AlwaysOnDisplayToggleError { unknown }
