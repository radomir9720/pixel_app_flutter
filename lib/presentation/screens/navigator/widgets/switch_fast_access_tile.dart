import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:re_widgets/re_widgets.dart';

class SwitchFastAccessTile extends StatelessWidget {
  const SwitchFastAccessTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigatorFastAccessBloc, NavigatorFastAccessState>(
      listenWhen: (previous, current) => current.isFailure,
      listener: (context, state) {
        context.showSnackBar(
          context.l10n.errorSwitchingFastAccessMessage,
        );
      },
      builder: (context, state) {
        return SwitchListTile(
          value: state.payload,
          title: Text(context.l10n.fastAccessTileTitle),
          subtitle: Text(context.l10n.fastAccessTileHint),
          onChanged: (value) async {
            bool? turnOn;
            if (value) {
              final selected = context.read<NavigatorAppBloc>().state.payload;
              if (selected == null) {
                await context.showSnackBar(
                  context.l10n.firstSelectDefaultNavAppErrorMessage,
                );
                return;
              }
              turnOn = await context.router
                  .push<bool>(const EnableFastAccessDialogRoute());
            }
            if (context.mounted && ((turnOn ?? false) || !value)) {
              context
                  .read<NavigatorFastAccessBloc>()
                  .add(NavigatorFastAccessEvent.set(value: value));
            }
          },
        );
      },
    );
  }
}
