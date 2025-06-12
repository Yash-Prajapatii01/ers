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

  SelectOptionEvent({required this.name, required this.id, this.fieldType});
}
