import 'package:equatable/equatable.dart';
import 'package:buzzy_bee/features/services/domain/entities/service.dart';
import 'package:buzzy_bee/features/home/domain/entities/cleaner.dart';

enum SearchResultType { service, cleaner }

class SearchResult extends Equatable {
  final SearchResultType type;
  final Service? service;
  final Cleaner? cleaner;

  const SearchResult({required this.type, this.service, this.cleaner})
    : assert(
        (type == SearchResultType.service && service != null) ||
            (type == SearchResultType.cleaner && cleaner != null),
        'Service or Cleaner must be provided based on type',
      );

  const SearchResult.service(Service this.service)
    : type = SearchResultType.service,
      cleaner = null;

  const SearchResult.cleaner(Cleaner this.cleaner)
    : type = SearchResultType.cleaner,
      service = null;

  String getTitle(String locale) {
    switch (type) {
      case SearchResultType.service:
        return service!.getName(locale);
      case SearchResultType.cleaner:
        return cleaner!.name;
    }
  }

  String? getSubtitle(String locale) {
    switch (type) {
      case SearchResultType.service:
        return service!.getDescription(locale);
      case SearchResultType.cleaner:
        return cleaner!.getBio(locale);
    }
  }

  String getImageUrl() {
    switch (type) {
      case SearchResultType.service:
        return service!.iconUrl;
      case SearchResultType.cleaner:
        return cleaner!.avatarUrl;
    }
  }

  @override
  List<Object?> get props => [type, service, cleaner];
}
