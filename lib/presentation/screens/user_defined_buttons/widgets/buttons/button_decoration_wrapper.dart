import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nested/nested.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';

enum _MenuItem { remove }

class ButtonDecorationWrapper extends SingleChildStatelessWidget {
  const ButtonDecorationWrapper({
    super.key,
    super.child,
    required this.buttonId,
    this.border,
  });

  @protected
  final int buttonId;

  @protected
  final Border? border;

  static const kBorderRadius = BorderRadius.all(Radius.circular(12));

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return GestureDetector(
      onLongPress: () async {
        final button = context.findRenderObject()! as RenderBox;
        final overlay = Navigator.of(context)
            .overlay!
            .context
            .findRenderObject()! as RenderBox;

        const offset = Offset.zero;

        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(offset, ancestor: overlay),
            button.localToGlobal(
              button.size.bottomRight(Offset.zero) + offset,
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );
        final result = await showMenu(
          context: context,
          position: position,
          items: [
            PopupMenuItem(
              value: _MenuItem.remove,
              child: Text(context.l10n.removeButtonCaption),
            ),
          ],
        );
        if (result == null) return;
        if (result == _MenuItem.remove) {
          if (context.mounted) {
            context.read<RemoveUserDefinedBurronBloc>().add(
                  RemoveUserDefinedBurronEvent.remove(buttonId),
                );
          }
        }
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: kBorderRadius,
            color: Theme.of(context).colorScheme.background,
            border: border,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black12,
                spreadRadius: 5,
                blurRadius: 3,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}
