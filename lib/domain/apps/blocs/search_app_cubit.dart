import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';

@immutable
class SearchAppState {
  const SearchAppState({
    required this.all,
    required this.filtered,
    required this.searchString,
  });

  const SearchAppState.initial(this.all)
      : filtered = all,
        searchString = '';

  final ApplicationsEntity all;
  final ApplicationsEntity filtered;
  final String searchString;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAppState &&
        listEquals(other.all, all) &&
        listEquals(other.filtered, filtered) &&
        other.searchString == searchString;
  }

  @override
  int get hashCode => all.hashCode ^ filtered.hashCode ^ searchString.hashCode;

  SearchAppState copyWith({
    ApplicationsEntity? all,
    ApplicationsEntity? filtered,
    String? searchString,
  }) {
    return SearchAppState(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      searchString: searchString ?? this.searchString,
    );
  }
}

class SearchAppCubit extends Cubit<SearchAppState> {
  SearchAppCubit({required ApplicationsEntity apps})
      : super(SearchAppState.initial(ApplicationsEntity(apps).sorted));

  void update({
    ApplicationsEntity? all,
    ApplicationsEntity? filtered,
  }) {
    emit(
      state.copyWith(
        all: all,
        filtered: filtered,
      ),
    );
  }

  void search(String name) {
    if (name.isEmpty) return emit(SearchAppState.initial(state.all));
    emit(
      state.copyWith(
        searchString: name,
        filtered: state.all.filterByName(name),
      ),
    );
  }
}
