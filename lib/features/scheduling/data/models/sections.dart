import 'package:ers_linux/features/scheduling/data/models/udfModel.dart';

import '../../domain/entities/SectionEntity.dart';

class SectionModel {
  final int id;
  final String title;
  final bool isVisible;
  final bool isSystemDefined;
  final int module;
  final String description;
  final int disabledActions;
  final List<UdfModel> udfs;

  SectionModel({
    required this.id,
    required this.title,
    required this.isVisible,
    required this.isSystemDefined,
    required this.module,
    required this.description,
    required this.disabledActions,
    required this.udfs,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      isVisible: json['is_visible'] as bool,
      isSystemDefined: json['is_system_defined'] as bool,
      module: json['module'] as int,
      description: json['description'] as String? ?? '',
      disabledActions: json['disabled_actions'] as int,
      udfs: (json['udfs'] as List<dynamic>)
          .map((e) => UdfModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  SectionModel copyWith({
    String? title,
    List<UdfModel>? udfs,
}){
    return SectionModel(
      id: id,
      title: title ?? this.title,
      isVisible: isVisible,
      isSystemDefined: isSystemDefined,
      module: module,
      description: description,
      disabledActions: disabledActions,
      udfs: udfs ?? this.udfs
    );
}

  @override
  String toString() {
    return 'SectionModel(id: $id, title: $title, udfs: ${udfs.length} items)';
  }
}
