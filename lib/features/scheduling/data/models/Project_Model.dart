// class ProjectModel {
//   final int id;
//   final String name;
//   final String startDate;
//
//   ProjectModel({
//     required this.id,
//     required this.name,
//     required this.startDate
//   });
//
//   /// Factory constructor to create a Project from JSON
//   factory ProjectModel.fromJson(Map<String, dynamic> json) {
//     return ProjectModel(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? 'Project',
//       startDate: json['start_date'] ?? DateTime.now(),
//     );
//   }
// }
