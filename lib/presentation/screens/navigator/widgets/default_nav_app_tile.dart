import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/navigator/navigator_screen.dart';
import 'package:re_widgets/re_widgets.dart';

class DefaultNavAppTile extends StatelessWidget {
  const DefaultNavAppTile({super.key, required this.apps});

  @protected
  final List<NavApp> apps;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigatorAppBloc, NavigatorAppState>(
      listenWhen: (previous, current) => current.isFailure,
      listener: (context, state) {
        context.showSnackBar(
          context.l10n.errorSettingDefaultNavAppMessage,
        );
      },
      builder: (context, state) {
        return ListTile(
          title: Text(context.l10n.defaultNavAppTileTitle),
          trailing: DropdownButton<String?>(
            value: state.payload,
            items: [
              ...apps.map(
                (e) => DropdownMenuItem<String?>(
                  value: e.platformPackage,
                  child: Text(e.name),
                ),
              ),
              if (state.payload == null)
                DropdownMenuItem(
                  child: Text(context.l10n.notSelectedDropdownHint),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              context
                  .read<NavigatorAppBloc>()
                  .add(NavigatorAppEvent.set(value));
            },
          ),
        );
      },
    );
  }
}
