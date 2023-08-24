import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/blocs/add_user_defined_button_bloc.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_builder.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_properties_manager.dart';
import 'package:provider/provider.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:re_widgets/re_widgets.dart';

class AddUserDefinedButtonScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const AddUserDefinedButtonScreen({
    super.key,
    required this.buttonBuilder,
    required this.buttonName,
  });

  @protected
  final ButtonBuilder buttonBuilder;

  @protected
  final String buttonName;

  @override
  State<AddUserDefinedButtonScreen> createState() =>
      _AddUserDefinedButtonScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (context) => AddUserDefinedButtonBloc(
            storage: context.read(),
          ),
        ),
        BlocListener<AddUserDefinedButtonBloc, AddUserDefinedButtonState>(
          listener: (context, state) {
            state.maybeWhen(
              failure: (error) {
                context
                    .showSnackBar(context.l10n.errorWhenAddingTheButtonMessage);
              },
              success: () {
                context.router
                    .navigate(const SelectedDataSourceFlow())
                    .then((value) {
                  context.showSnackBar(
                    context.l10n.theButtonIsSuccessfullyAddedMessage,
                  );
                });
              },
              orElse: () {},
            );
          },
        ),
      ],
      child: this,
    );
  }
}

class _AddUserDefinedButtonScreenState
    extends State<AddUserDefinedButtonScreen> {
  late final ButtonPropertiesManager manager;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    manager = ButtonPropertiesManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: context.router.pop),
        title: Text(
          context.l10n.addUserDefinedButtonScreenTitle(
            widget.buttonName.toLowerCase(),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: widget.buttonBuilder.fields
                .map((e) => e.widgetBuilder(context, manager))
                .divideBy(const SizedBox(height: 16))
                .toList(),
          ),
        ),
      ),
      bottomNavigationBar: FilledButton(
        onPressed: () {
          final valid = _formKey.currentState?.validate() ?? false;
          if (!valid) return;

          final button = widget.buttonBuilder.builder(manager);
          context
              .read<AddUserDefinedButtonBloc>()
              .add(AddUserDefinedButtonEvent.add(button));
        },
        child: Text(context.l10n.addButtonCaption),
      ),
    );
  }
}
