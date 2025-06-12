import 'UdfEntity.dart';

class SectionEntity {
  final int id;
  final int disableActions;
  final bool isSystemDefined;
  final bool isVisible;
  final int module;
  final String sectionTitle;
  final List<UdfEntity> udf;

  SectionEntity(
    this.disableActions,
    this.isVisible,
    this.module, {
    required this.id,
    required this.isSystemDefined,
    required this.sectionTitle,
    required this.udf,
  });
}
