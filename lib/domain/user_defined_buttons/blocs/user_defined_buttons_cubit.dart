import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

class UserDefinedButtonsCubit extends Cubit<List<UserDefinedButton>>
    with ConsumerBlocMixin {
  UserDefinedButtonsCubit({required this.storage}) : super([]) {
    subscribe(storage, emit);
  }
  @protected
  final UserDefinedButtonsStorage storage;

  void load() => storage.read();
}
