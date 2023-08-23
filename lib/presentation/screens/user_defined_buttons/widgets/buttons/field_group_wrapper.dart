import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class FieldGroupWrapper extends StatelessWidget {
  const FieldGroupWrapper({
    super.key,
    required this.title,
    required this.children,
    this.error,
    this.padding = EdgeInsets.zero,
  });

  @protected
  final String title;

  @protected
  final String? error;

  @protected
  final List<Widget> children;

  @protected
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(
          color: error != null ? context.colors.error : context.colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 8),
            child: Text(
              title,
              style: TextStyle(color: context.colors.hintText),
            ),
          ),
          Padding(
            padding: padding,
            child: Column(
              children: children,
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
                top: 16,
              ),
              child: Text(
                error ?? '',
                style: TextStyle(color: context.colors.error),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
