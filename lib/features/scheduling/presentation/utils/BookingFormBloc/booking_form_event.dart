part of 'booking_form_bloc.dart';

@immutable
sealed class BookingFormEvent {}

class LoadBookingFormEvent implements BookingFormEvent {
  final String token;

  LoadBookingFormEvent({required this.token});
}

class SearchOptionEvent implements BookingFormEvent {
  final String fieldType;
  final String? query;

  SearchOptionEvent({required this.fieldType, this.query});
}

class LoadStaticOptionsEvent implements BookingFormEvent {
  final List<UdfOptionsModel> options;

  LoadStaticOptionsEvent({required this.options});
}

class BookingFormLoadedEvent implements BookingFormEvent {
  final List<SectionModel> sections;

  BookingFormLoadedEvent({required this.sections});
}

class SelectOptionEvent implements BookingFormEvent {
  final String name;
  final int id;
  final String? fieldType;
  // final String? taskName;
  // final int? taskID;
  // final int? roleID;
  // final String? roleName;
  // final int? projectID;
  // final String? projectName;

  SelectOptionEvent({
    required this.name,
    required this.id,
    this.fieldType,
    // this.taskName,
    // this.taskID,
    // this.roleID,
    // this.roleName,
    // this.projectID,
    // this.projectName,
  });
}

// class SelectRequirementEvent implements BookingFormEvent {
//   final String requirementName;
//   final int id;
//   final String? taskName;
//   final int? taskID;
//   final int? roleID;
//   final String? roleName;
//   final int? projectID;
//   final String? projectName;
//   final bool? syncToBooking;
//
//   SelectRequirementEvent({
//     required this.requirementName,
//     required this.id,
//     required this.syncToBooking,
//     this.taskName,
//     this.taskID,
//     this.roleID,
//     this.roleName,
//     this.projectID,
//     this.projectName,
//   });
// }
