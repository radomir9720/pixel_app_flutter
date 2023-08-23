import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/indicator_button.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/one_axis_joystick_button.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/send_packages_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/molecules/responsive_grid_view.dart';
import 'package:re_widgets/re_widgets.dart';

class UserDefinedButtonsEndDrawer extends StatelessWidget {
  const UserDefinedButtonsEndDrawer({super.key});

  @protected
  static const kTitleTextStyle = TextStyle(
    height: 1.2,
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    final buttons = context.watch<UserDefinedButtonsCubit>().state;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final minWidth = 300.0.clamp(0.0, screenWidth * .9);
    final maxWidth = screenWidth * .9;

    return BlocListener<RemoveUserDefinedBurronBloc,
        RemoveUserDefinedBurronState>(
      listener: (context, state) {
        state.maybeWhen(
          failure: (error) {
            context.showSnackBar(context.l10n.errorRemovingTheButtonMessage);
          },
          success: () {
            context.showSnackBar(
              context.l10n.theButtonIsSuccessfullyRemovedMessage,
            );
          },
          orElse: () {},
        );
      },
      child: Drawer(
        shadowColor: context.colors.primaryAccent,
        width: 500.0.clamp(minWidth, maxWidth),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.router.push(const UserDefinedButtonsFlow());
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: Text(context.l10n.userDefinedButtonsScreenTtitle),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: buttons.isEmpty
                        ? const _NoButtonsPlaceholder()
                        : SingleChildScrollView(
                            child: ResponsiveGridView(
                              minWidth: 200,
                              maxWidth: 400,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                for (final button in buttons)
                                  button.when(
                                    indicator: IndicatorButton.new,
                                    yAxisJoystick: YAxisJoystickButton.new,
                                    xAxisJoystick: XAxisJoystickButton.new,
                                    sendPackagesButton: SendPackagesButton.new,
                                  )
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoButtonsPlaceholder extends StatelessWidget {
  const _NoButtonsPlaceholder();

  @protected
  static const kTextStyle = TextStyle(
    height: 1.2,
    fontSize: 14,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Icon(
            Icons.list,
            size: 40,
            color: context.colors.hintText,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.itIsEmptyHereMessage,
            style: kTextStyle.copyWith(color: context.colors.hintText),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
