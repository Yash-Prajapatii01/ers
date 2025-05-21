import 'package:ers_linux/features/scheduling/data/models/resource_model.dart';

class BookingEntity{
  final String bookingId;
  final String requirement;
  final Resource resource;
  final String project;
  final String task;
  final DateTime fromDate;
  final DateTime toDate;
  final String repeat;
  final String endrepeat;

  BookingEntity(this.requirement, this.resource, this.project, this.task, this.fromDate, this.toDate, this.repeat, this.endrepeat, {required this.bookingId});
}