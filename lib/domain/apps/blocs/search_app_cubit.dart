import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';

@immutable
class SearchAppState {
  const SearchAppState({required this.apps, required this.searchString});

  const SearchAppState.initial(this.apps) : searchString = '';

  final List<ApplicationInfo> apps;
  final String searchString;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAppState &&
        listEquals(other.apps, apps) &&
        other.searchString == searchString;
  }

  @override
  int get hashCode => apps.hashCode ^ searchString.hashCode;

  SearchAppState copyWith({
    List<ApplicationInfo>? apps,
    String? searchString,
  }) {
    return SearchAppState(
      apps: apps ?? this.apps,
      searchString: searchString ?? this.searchString,
    );
  }
}

class SearchAppCubit extends Cubit<SearchAppState> {
  SearchAppCubit({required this.apps}) : super(SearchAppState.initial(apps));

  final List<ApplicationInfo> apps;

  void reset() => emit(SearchAppState.initial(apps));

  void search(String name) {
    if (name.isEmpty) return emit(SearchAppState.initial(apps));
    emit(
      state.copyWith(
        searchString: name,
        apps: [
          ...apps.where(
            (element) =>
                (element.name ?? '').toLowerCase().contains(name.toLowerCase()),
          )
        ],
      ),
    );
  }
}
