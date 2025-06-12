abstract class UdfEntity {
  final int id;
  final String code;
  final int order;
  final String displayName;
  final String fieldType;
  final bool isRequired;
  final bool isUnique;
  final int availability;
  final bool isFilterable;
  final List<String> options;
  final int visibility;
  final int module;
  final int defaultValue;
  final int sectionID;
  final int udfDescID;
  final DateTime createdOn;
  final int disabledActions;
  final bool isEditable;
  final bool isSystemDefined;
  final int prefillFrom;
  final Map<String, dynamic> extra;

  UdfEntity(
    this.prefillFrom,
    this.code,
    this.isUnique,
    this.availability,
    this.isFilterable,
    this.visibility,
    this.module,
    this.defaultValue,
    this.sectionID,
    this.udfDescID,
    this.createdOn,
    this.disabledActions,
    this.isEditable,
    this.extra, {
    required this.id,
    required this.fieldType,
    required this.displayName,
    required this.isRequired,
    required this.isSystemDefined,
    required this.order,
    required this.options,
  });
}
