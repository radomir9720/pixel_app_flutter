import 'dart:collection';

import 'package:pixel_app_flutter/domain/apps/apps.dart';

extension on bool {
  int get toInt => this ? 0 : 1;
}

class ApplicationsEntity extends UnmodifiableListView<ApplicationInfo> {
  ApplicationsEntity(super.source);

  ApplicationsEntity.empty() : super(const []);

  ApplicationsEntity markPinned(List<String> packageNames) {
    return ApplicationsEntity(
      map(
        (element) => element.copyWith(
          pinned: packageNames.contains(element.packageName),
        ),
      ),
    );
  }

  ApplicationsEntity updateApp(ApplicationInfo app) {
    return ApplicationsEntity(
      map((e) => e.packageName == app.packageName ? app : e),
    );
  }

  ApplicationsEntity get sorted {
    return ApplicationsEntity(
      [...this]..sort(
          (a, b) => '${a.pinned.toInt}${a.name}'
              .compareTo('${b.pinned.toInt}${b.name}'),
        ),
    );
  }

  ApplicationsEntity filterByName(String name) {
    if (name.isEmpty) return this;
    return ApplicationsEntity(
      where(
        (element) =>
            (element.name ?? '').toLowerCase().contains(name.toLowerCase()),
      ),
    );
  }
}
