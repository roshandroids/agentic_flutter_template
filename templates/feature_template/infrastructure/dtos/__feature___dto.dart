import '../../domain/entities/__feature__.dart';

/// The wire shape - never leaks into `domain/` or `presentation/`. Mapping
/// to [__Feature__] happens here, once, at the infrastructure boundary.
/// TODO: replace with __feature__'s real fields.
class __Feature__Dto {
  const __Feature__Dto();

  factory __Feature__Dto.fromJson(Map<String, dynamic> json) =>
      const __Feature__Dto();

  __Feature__ toDomain() => const __Feature__();
}
