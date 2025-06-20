import 'Project_Model.dart';

class RequirementModel {
  final String name;
  final int id;
  final String startDate;
  final String endDate;
  final int flexi_range_unit;
  final String flexi_range_duration;
  final int task_id;
  final String task_name;
  final String sync_to_booking;
  final int role_id;
  final String role_name;
  final int project_id;
  final String title;
  final List<int> tags;
  final ProjectModel project;

  RequirementModel({
    required this.name,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.flexi_range_unit,
    required this.flexi_range_duration,
    required this.task_id,
    required this.task_name,
    required this.sync_to_booking,
    required this.project_id,
    required this.title,
    required this.role_id,
    required this.role_name,
    required this.tags,
    required this.project,
  });

  factory RequirementModel.fromJson(Map<String, dynamic> json) {
    return RequirementModel(
      name: json['name'],
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      flexi_range_unit: json['flexi_range_unit'],
      flexi_range_duration: json['flexi_range_duration'],
      task_id: json['task_id'],
      task_name: json['task_name'],
      sync_to_booking: json['sync_to_booking'],
      project_id: json['project_id'],
      title: json['title'],
      role_id: json['role_id'],
      role_name: json['role_name'],
      tags: List<int>.from(json['tags']),
      project: ProjectModel.fromJson(json['project']),
    );
  }
}
