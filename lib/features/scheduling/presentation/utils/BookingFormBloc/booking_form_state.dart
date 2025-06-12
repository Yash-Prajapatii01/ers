part of 'booking_form_bloc.dart';

@immutable
sealed class BookingFormState {}

final class BookingFormInitialState extends BookingFormState {}

final class BookingFormLoadingState extends BookingFormState {}

final class BookingFormOptionLoadedState extends BookingFormState {
  final List<UdfOptionsModel> options;

  BookingFormOptionLoadedState({required this.options});
}

final class BookingFormLoadedState extends BookingFormState {
  final List<SectionModel> sections;

  BookingFormLoadedState({required this.sections});

  BookingFormLoadedState copyWith({List<SectionModel>? sections}){
    return BookingFormLoadedState(sections: sections ?? this.sections);
  }
}


final class BookingFormErrorState extends BookingFormState {
  final String message;

  BookingFormErrorState({required this.message});
}

final class BookingFormSelectedOptionState extends BookingFormState {
  final String name;
  final int id;

  BookingFormSelectedOptionState({required this.name, required this.id});
}