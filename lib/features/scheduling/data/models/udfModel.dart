import 'package:ers_linux/features/scheduling/data/models/udfOptionsModel.dart';

class UdfModel {
  final int id;
  final String code;
  final String displayName;
  final String fieldType;
  final bool isRequired;
  final bool isSystemDefined;
  final int visibility;
  final int module;
  final int order;
  final bool isFilterable;
  final List<UdfOptionsModel> udfOptionsList;
  final int prefillFrom;
  final bool isUnique;
  final dynamic defaultValue;
  final int availability;
  final int disabledActions;
  final int sectionId;
  final int udfDescId;
  final String createdOn;
  final String? modifiedOn;
  final String? maxDate;
  final String? minDate;
  final double? minNum;
  final double? maxNum;
  final double? minLength;
  final double? maxLength;
  final String? addonLeftVal;
  final String? addonRightVal;
  final String? trueValueIcon;
  final int? addonRightType;
  final String? postfix;
  final String? regex;
  final dynamic userValue;

  UdfModel({
    required this.id,
    required this.code,
    required this.displayName,
    required this.fieldType,
    required this.isRequired,
    required this.isSystemDefined,
    required this.visibility,
    required this.module,
    required this.order,
    required this.isFilterable,
    required this.udfOptionsList,
    required this.prefillFrom,
    required this.isUnique,
    required this.defaultValue,
    required this.availability,
    required this.disabledActions,
    required this.sectionId,
    required this.udfDescId,
    required this.createdOn,
    this.modifiedOn,
    this.maxDate,
    this.minDate,
    this.minNum,
    this.maxNum,
    this.minLength,
    this.maxLength,
    this.addonLeftVal,
    this.addonRightVal,
    this.trueValueIcon,
    this.addonRightType,
    this.postfix,
    this.regex,
    this.userValue,
  });

  factory UdfModel.fromJson(Map<String, dynamic> json) {
    return UdfModel(
      id: json['id'] as int,
      code: json['code'] as String,
      displayName: json['display_name'] as String,
      fieldType: json['field_type'] as String,
      isRequired: json['is_required'] as bool,
      isSystemDefined: json['is_system_defined'] as bool,
      visibility: json['visibility'] as int,
      module: json['module'] as int,
      order: json['order'] as int,
      isFilterable: json['is_filterable'] as bool,
      udfOptionsList:
          (json['options'] as List<dynamic>)
              .map((e) => UdfOptionsModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      prefillFrom: json['prefill_from'] as int,
      isUnique: json['is_unique'] as bool,
      defaultValue: json['default_value'],
      availability: json['availability'] as int,
      disabledActions: json['disabled_actions'] as int,
      sectionId: json['section_id'] as int,
      udfDescId: json['udf_desc_id'] as int,
      createdOn: json['created_on'] as String,
      // Nullable fields
      modifiedOn: json['modified_on'] as String?,
      maxDate: json['maxdate'] as String?,
      minDate: json['mindate'] as String?,
      minNum: (json['minnum'] as num?)?.toDouble(),
      maxNum: (json['maxnum'] as num?)?.toDouble(),
      minLength: (json['minlength'] as num?)?.toDouble(),
      maxLength: (json['maxlength'] as num?)?.toDouble(),
      addonLeftVal: json['addon_left_val'] as String?,
      addonRightVal: json['addon_right_val'] as String?,
      trueValueIcon: json['true_value_icon'] as String?,
      addonRightType: json['addon_right_type'] as int?,
      postfix: json['postfix'] as String?,
      regex: json['regex'] as String?,
      userValue: json['userValue'] as String?,
    );
  }

  UdfModel copyWith({
    String? fieldType,
    List<UdfOptionsModel>? udfOptionsList,
  }) {
    return UdfModel(
      id: id,
      code: code,
      displayName: displayName,
      fieldType: fieldType ?? this.fieldType,
      isRequired: isRequired,
      isSystemDefined: isSystemDefined,
      visibility: visibility,
      module: module,
      order: order,
      isFilterable: isFilterable,
      udfOptionsList: udfOptionsList ?? this.udfOptionsList,
      prefillFrom: prefillFrom,
      isUnique: isUnique,
      defaultValue: defaultValue,
      availability: availability,
      disabledActions: disabledActions,
      sectionId: sectionId,
      udfDescId: udfDescId,
      createdOn: createdOn,
    );
  }
}
