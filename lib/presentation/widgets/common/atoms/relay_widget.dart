import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelayWidget extends StatefulWidget {
  const RelayWidget({
    super.key,
    required this.builder,
    required this.initiallyEnabled,
    required this.switchStream,
  });

  @protected
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(bool isOn) builder;

  @protected
  final bool initiallyEnabled;

  @protected
  final Stream<bool> switchStream;

  @override
  State<RelayWidget> createState() => _RelayWidgetState();
}

class _RelayWidgetState extends State<RelayWidget> {
  final relayCubit = TurnSignalRelayCubit();
  late final StreamSubscription<void> subscription;

  @override
  void initState() {
    super.initState();
    if (widget.initiallyEnabled) relayCubit.enable();
    subscription = widget.switchStream.listen((isOn) {
      if (isOn) {
        relayCubit.enable();
        return;
      }
      relayCubit.disable();
    });
  }

  @override
  void dispose() {
    relayCubit.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurnSignalRelayCubit, bool>(
      bloc: relayCubit,
      builder: (context, state) => widget.builder(state),
    );
  }
}

class TurnSignalRelayCubit extends Cubit<bool> {
  TurnSignalRelayCubit({this.interval = kDefaultInterval}) : super(false);

  @protected
  final Duration interval;

  @visibleForTesting
  static const Duration kDefaultInterval = Duration(milliseconds: 700);

  @visibleForTesting
  Timer? timer;

  void enable() {
    if (timer?.isActive ?? false) return;
    emit(!state);
    timer = Timer.periodic(interval, (timer) {
      emit(!state);
    });
  }

  void disable() {
    emit(false);
    timer?.cancel();
    timer = null;
  }

  @override
  Future<void> close() {
    disable();
    return super.close();
  }
}
