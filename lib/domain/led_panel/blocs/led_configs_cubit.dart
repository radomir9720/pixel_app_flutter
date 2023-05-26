import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:re_seedwork/re_seedwork.dart';

class LEDConfigsCubit extends Cubit<List<LEDPanelConfig>>
    with ConsumerBlocMixin {
  LEDConfigsCubit({required this.storage}) : super(storage.data) {
    subscribe<List<LEDPanelConfig>>(storage, emit);
  }

  @protected
  final LEDConfigsStorage storage;
}
