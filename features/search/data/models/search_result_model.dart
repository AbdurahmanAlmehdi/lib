import 'package:buzzy_bee/features/search/domain/entities/search_result.dart';
import 'package:buzzy_bee/features/services/data/models/service_model.dart';
import 'package:buzzy_bee/features/home/data/models/cleaner_model.dart';

class SearchResultModel extends SearchResult {
  const SearchResultModel({
    required super.type,
    super.service,
    super.cleaner,
  });

  const SearchResultModel.service(ServiceModel super.service)
      : super.service();

  const SearchResultModel.cleaner(CleanerModel super.cleaner)
      : super.cleaner();

  SearchResult toEntity() {
    switch (type) {
      case SearchResultType.service:
        return SearchResult.service(service!);
      case SearchResultType.cleaner:
        return SearchResult.cleaner(cleaner!);
    }
  }
}

