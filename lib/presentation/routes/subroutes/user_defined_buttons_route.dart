part of '../main_router.dart';

const _userDefinedButtonsRoute = AutoRoute<void>(
  page: EmptyRouterScreen,
  path: 'user-defined-buttons',
  name: RouteNames.userDefinedButtonsFlow,
  children: [
    AutoRoute<void>(
      path: '',
      page: SelectButtonTypeScreen,
    ),
    AutoRoute<void>(
      path: 'add',
      page: AddUserDefinedButtonScreen,
    ),
    AutoRoute<void>(
      path: 'edit',
      page: EditUserDefinedButtonScreen,
    ),
  ],
);
