import 'dart:async';

import 'package:flutter/widgets.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key, required this.target});

  @protected
  final DateTime target;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  Timer? timer;
  int countdown = -1;

  @override
  void initState() {
    super.initState();
    runTimer();
  }

  @override
  void didChangeDependencies() {
    runTimer();
    super.didChangeDependencies();
  }

  void runTimer() {
    timer?.cancel();
    final diff = widget.target.difference(DateTime.now());
    if (diff.isNegative) return;
    countdown = diff.inSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) setState(() => countdown--);
      if (countdown < 0) timer?.cancel();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (countdown < 0) return const SizedBox.shrink();
    return Text(countdown.toString());
  }
}
