import 'package:flutter_bloc/flutter_bloc.dart';

class PauseLogsUpdatingCubit extends Cubit<bool> {
  PauseLogsUpdatingCubit() : super(false);

  void toggle() => emit(!state);
}
