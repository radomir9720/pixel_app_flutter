part of '../main_router.dart';

final _userDefinedButtonsRoute = AutoRoute(
  page: UserDefinedButtonsFlow.page,
  path: 'user-defined-buttons',
  children: [
    AutoRoute(
      path: '',
      page: SelectButtonTypeRoute.page,
    ),
    AutoRoute(
      path: 'add',
      page: AddUserDefinedButtonRoute.page,
    ),
    AutoRoute(
      path: 'edit',
      page: EditUserDefinedButtonRoute.page,
    ),
  ],
);

@RoutePage(name: 'UserDefinedButtonsFlow')
class UserDefinedButtonsScope extends AutoRouter {
  const UserDefinedButtonsScope({super.key});
}
