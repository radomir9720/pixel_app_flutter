import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';

@immutable
class SearchAppState {
  const SearchAppState({
    required this.all,
    required this.filtered,
    required this.searchString,
    this.shouldRebuild = true,
  });

  const SearchAppState.initial(this.all)
      : filtered = all,
        searchString = '',
        shouldRebuild = true;

  final ApplicationsEntity all;
  final ApplicationsEntity filtered;
  final String searchString;
  final bool shouldRebuild;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAppState &&
        other.all == all &&
        other.filtered == filtered &&
        other.searchString == searchString &&
        other.shouldRebuild == shouldRebuild;
  }

  @override
  int get hashCode {
    return all.hashCode ^
        filtered.hashCode ^
        searchString.hashCode ^
        shouldRebuild.hashCode;
  }

  SearchAppState copyWith({
    ApplicationsEntity? all,
    ApplicationsEntity? filtered,
    String? searchString,
    bool? shouldRebuild,
  }) {
    return SearchAppState(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      searchString: searchString ?? this.searchString,
      shouldRebuild: shouldRebuild ?? this.shouldRebuild,
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
        shouldRebuild: false,
      ),
    );
  }

  void search(String name) {
    if (name.isEmpty) return emit(SearchAppState.initial(state.all));
    emit(
      state.copyWith(
        searchString: name,
        filtered: state.all.filterByName(name),
        shouldRebuild: true,
      ),
    );
  }
}
