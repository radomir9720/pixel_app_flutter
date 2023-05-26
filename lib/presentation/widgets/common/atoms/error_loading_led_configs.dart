import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:provider/provider.dart';

class ErrorLoadingLEDConfigsWidget extends StatefulWidget {
  const ErrorLoadingLEDConfigsWidget({super.key});

  @override
  State<ErrorLoadingLEDConfigsWidget> createState() =>
      _ErrorLoadingLEDConfigsWidgetState();
}

class _ErrorLoadingLEDConfigsWidgetState
    extends State<ErrorLoadingLEDConfigsWidget> {
  late final TapGestureRecognizer recognizer;

  @override
  void initState() {
    super.initState();
    recognizer = TapGestureRecognizer()
      ..onTap = () {
        context
            .read<LoadLEDConfigsBloc>()
            .add(const LoadLEDConfigsEvent.load());
      };
  }

  @override
  void dispose() {
    recognizer.dispose();
    super.dispose();
  }

  @protected
  static const kTextStyle = TextStyle(
    height: 1.2,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: kTextStyle,
        children: [
          TextSpan(text: context.l10n.errorLoadingConfigurations),
          const TextSpan(text: '\n'),
          TextSpan(
            text: context.l10n.tryAgainButtonCaption,
            style: TextStyle(color: context.colors.primary),
            recognizer: recognizer,
          ),
        ],
      ),
    );
  }
}
