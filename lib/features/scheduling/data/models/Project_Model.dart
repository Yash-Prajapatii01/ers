class ProjectModel {
  final int id;
  final String title;
  final String? image_uuid;
  final int project_type_id;
  final String project_start_date;
  final String? end_date;
  final String? email;
  final bool is_archive;
  final List<int> tags;
  final String udf_color;
  final bool is_billable;
  final String? disable_parallel_booking;
  final String? timezone;
  final int project_calendar;
  final int udf_team;
  final int udf_location;
  final int udf_client;
  final String udf_project_code;
  final int udf_project_manager;
  final int udf_priority;
  final int udf_status;

  ProjectModel({
    required this.id,
    required this.title,
    required this.image_uuid,
    required this.project_type_id,
    required this.project_start_date,
    required this.end_date,
    required this.email,
    required this.is_archive,
    required this.tags,
    required this.udf_color,
    required this.is_billable,
    required this.disable_parallel_booking,
    required this.timezone,
    required this.project_calendar,
    required this.udf_team,
    required this.udf_location,
    required this.udf_client,
    required this.udf_project_code,
    required this.udf_project_manager,
    required this.udf_priority,
    required this.udf_status,
  });

  /// Factory constructor to create a Project from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'] ?? '',
      image_uuid: json['image_uuid'] ?? '',
      project_type_id: json['project_type_id'] ?? '',
      project_start_date: json['project_start_date'] ?? '',
      end_date: json['end_date'] ?? '',
      email: json['email'] ?? '',
      is_archive: json['is_archive'] ?? false,
      tags: List<int>.from(json['tags']),
      udf_color: json['udf_color'],
      is_billable: json['is_billable'],
      disable_parallel_booking: json['disable_parallel_booking'],
      timezone: json['timezone'],
      project_calendar: json['project_calendar'],
      udf_team: json['udf_team'],
      udf_location: json['udf_location'],
      udf_client: json['udf_client'],
      udf_project_code: json['udf_project_code'],
      udf_project_manager: json['udf_project_manager'],
      udf_priority: json['udf_priority'],
      udf_status: json['udf_status'],
    );
  }
}
