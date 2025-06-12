import 'dart:convert';

import 'package:ers_linux/features/scheduling/data/models/udfModel.dart';

class BookingResponse {
  final List<Booking> bookings;

  BookingResponse({required this.bookings});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      bookings: (json['bookings'] as List)
          .map((item) => Booking.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'bookings': bookings.map((b) => b.toJson()).toList(),
  };
}

class Booking {
  final double calculatedHrs;
  final int timezone;
  final int taskId;
  final int effort;
  final int rateFrom;
  final String resName;
  final bool udfTravelRequired;
  final int projectId;
  final int roleId;
  final int billingStatus;
  final int id;
  final String bookingTimezone;
  final DateTime originalStartTime;
  final DateTime endTime;
  final String createdBy;
  final bool udfConfirmed;
  final List<String> tags;
  final DateTime startTime;
  final int unit;
  final DateTime originalEndTime;
  final DateTime createdOn;
  final String bookingTimezoneAbbr;
  final int resourceId;
  final int progress;
  final Map<String, dynamic> bookingfields;

  Booking({
    required this.calculatedHrs,
    required this.timezone,
    required this.taskId,
    required this.effort,
    required this.rateFrom,
    required this.resName,
    required this.udfTravelRequired,
    required this.projectId,
    required this.roleId,
    required this.billingStatus,
    required this.id,
    required this.bookingTimezone,
    required this.originalStartTime,
    required this.endTime,
    required this.createdBy,
    required this.udfConfirmed,
    required this.tags,
    required this.startTime,
    required this.unit,
    required this.originalEndTime,
    required this.createdOn,
    required this.bookingTimezoneAbbr,
    required this.resourceId,
    required this.progress,
    required this.bookingfields,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      calculatedHrs: (json['calculated_hrs'] as num).toDouble(),
      timezone: json['timezone'],
      taskId: json['task_id'],
      effort: json['effort'],
      rateFrom: json['rate_from'],
      resName: json['res_name'],
      udfTravelRequired: json['udf_travel_required'],
      projectId: json['project_id'],
      roleId: json['role_id'],
      billingStatus: json['billing_status'],
      id: json['id'],
      bookingTimezone: json[r'$booking_timezone'],
      originalStartTime: DateTime.parse(json[r'$original_start_time']),
      endTime: DateTime.parse(json['end_time']),
      createdBy: json['created_by'],
      udfConfirmed: json['udf_confirmed'],
      tags: List<String>.from(json['tags']),
      startTime: DateTime.parse(json['start_time']),
      unit: json['unit'],
      originalEndTime: DateTime.parse(json[r'$original_end_time']),
      createdOn: DateTime.parse(json['created_on']),
      bookingTimezoneAbbr: json[r'$booking_timezone_abbr'],
      resourceId: json['resource_id'],
      progress: json['progress'],
      bookingfields: json,
    );
  }

  Map<String, dynamic> toJson() => {
    'calculated_hrs': calculatedHrs,
    'timezone': timezone,
    'task_id': taskId,
    'effort': effort,
    'rate_from': rateFrom,
    'res_name': resName,
    'udf_travel_required': udfTravelRequired,
    'project_id': projectId,
    'role_id': roleId,
    'billing_status': billingStatus,
    'id': id,
    r'$booking_timezone': bookingTimezone,
    r'$original_start_time': originalStartTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
    'created_by': createdBy,
    'udf_confirmed': udfConfirmed,
    'tags': tags,
    'start_time': startTime.toIso8601String(),
    'unit': unit,
    r'$original_end_time': originalEndTime.toIso8601String(),
    'created_on': createdOn.toIso8601String(),
    r'$booking_timezone_abbr': bookingTimezoneAbbr,
    'resource_id': resourceId,
    'progress': progress,
    'other Booking fields' : bookingfields,
  };
  Map<String, dynamic> udfValuesToBookingFields(List<UdfModel> udfModels) {
    return {
      for (final udf in udfModels)
        if (udf.userValue != null) udf.code: udf.userValue,
    };
  }
}
