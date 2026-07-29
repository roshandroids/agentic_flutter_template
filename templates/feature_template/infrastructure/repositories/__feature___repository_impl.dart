import 'package:core/core.dart';

import '../../domain/entities/__feature__.dart';
import '../../domain/repositories/__feature___repository.dart';
import '../dtos/__feature___dto.dart';

/// The only concrete [__Feature__Repository]. Constructed at
/// `apps/app/lib/composition_root.dart`, never directly by
/// `application/` code. TODO: replace the endpoint path.
class __Feature__RepositoryImpl implements __Feature__Repository {
  __Feature__RepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<__Feature__, Failure>> fetch() => _apiClient.get<__Feature__>(
    '/__feature__',
    decode: (json) =>
        __Feature__Dto.fromJson(json as Map<String, dynamic>).toDomain(),
  );
}
