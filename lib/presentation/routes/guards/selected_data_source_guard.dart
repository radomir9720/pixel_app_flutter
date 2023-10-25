part of '../main_router.dart';

final class SelectedDataSourceGuard extends AutoRouteGuard {
  const SelectedDataSourceGuard({required this.dataSourceStorage});

  @protected
  final DataSourceStorage dataSourceStorage;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    dataSourceStorage.read();
    if (dataSourceStorage.data.isPresent) return resolver.next();
    unawaited(resolver.redirect(const SelectDataSourceFlow()));
    unawaited(
      dataSourceStorage
          .firstWhere((element) => element.isPresent)
          .then((value) {
        resolver.next();
      }),
    );
  }
}
