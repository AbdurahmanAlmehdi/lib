part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  success,
  error,
}

class SearchState extends Equatable {
  final SearchStatus status;
  final List<SearchResult> results;
  final String query;
  final String? errorMessage;

  const SearchState({
    required this.status,
    this.results = const [],
    this.query = '',
    this.errorMessage,
  });

  const SearchState.initial()
      : status = SearchStatus.initial,
        results = const [],
        query = '',
        errorMessage = null;

  SearchState copyWith({
    SearchStatus? status,
    List<SearchResult>? results,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, query, errorMessage];
}

