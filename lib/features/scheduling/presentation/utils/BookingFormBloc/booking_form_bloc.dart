import 'package:bloc/bloc.dart';
import 'package:ers_linux/features/scheduling/data/models/udfOptionsModel.dart';
import 'package:meta/meta.dart';

import '../../../data/data_source/network.dart';
import '../../../data/models/sections.dart';
import '../../../data/services/SectionRetrivalService.dart';
import '../SearchService.dart';

part 'booking_form_event.dart';

part 'booking_form_state.dart';

class BookingFormBloc extends Bloc<BookingFormEvent, BookingFormState> {
  final BookingFormRemoteSource remoteSource;

  BookingFormBloc({required this.remoteSource})
    : super(BookingFormInitialState()) {
    on<LoadBookingFormEvent>((event, emit) async {
      emit(BookingFormLoadingState());
      try {
        final booking = await remoteSource.fetchBookingDetails(event.token);
        emit(BookingFormLoadedState(sections: booking.sections));
      } catch (e) {
        emit(BookingFormErrorState(message: e.toString()));
      }
    });

    on<LoadStaticOptionsEvent>((event, emit) {
      emit(BookingFormOptionLoadedState(options: event.options));
    });

    on<SelectOptionEvent>((event, emit) async{
      try {
        final currentState = state;
        List<UdfOptionsModel> options;
        if(event.fieldType =='PRJSS'){
           options = await SearchService.searchTask(event.id);
           if (currentState is BookingFormLoadedState) {
             final updatedSections =
             currentState.sections.map((section) {
               final updatedUdfs =
               section.udfs.map((udf) {
                 if (udf.fieldType == 'TSKSS') {
                   return udf.copyWith(
                     udfOptionsList: options,
                   ); // update only TSKSS
                 }
                 else {
                   return udf;
                 }
               }).toList();

               return section.copyWith(udfs: updatedUdfs);
             }).toList();
             print("udfOptionModel Updated");
             emit(currentState.copyWith(sections: updatedSections));
           }
        }else{
           options = await SearchService.searchRoles(event.id);
           print("options - $options");
           if (currentState is BookingFormLoadedState) {
             final updatedSections =
             currentState.sections.map((section) {
               final updatedUdfs =
               section.udfs.map((udf) {
                  if(udf.fieldType == 'ROLEPS'){
                   return udf.copyWith(
                     udfOptionsList: options,
                   );
                 }
                 else {
                   return udf;
                 }
               }).toList();

               return section.copyWith(udfs: updatedUdfs);
             }).toList();
             print("udfOptionModel Updated");
             emit(currentState.copyWith(sections: updatedSections));
           }
        }


      } catch (e) {
        emit(BookingFormErrorState(message: e.toString()));
      }
    });

    on<SearchOptionEvent>((event, emit) async {
      List<UdfOptionsModel> options = [];
      if (event.query!.trim().isEmpty) {
        emit(BookingFormInitialState());
        return;
      }
      emit(BookingFormLoadingState());
      try {
        switch (event.fieldType) {
          case 'PRJSS':
            options = await SearchService.searchProject(event.query!);
            emit(BookingFormOptionLoadedState(options: options));
            break;
          case 'RSRSS':
            options = await SearchService.searchResource(event.query!);
            emit(BookingFormOptionLoadedState(options: options));
            break;
          default:
            emit(BookingFormErrorState(message: 'Invalid field type'));
            break;
        }
        emit(BookingFormOptionLoadedState(options: options));
      } catch (e) {
        emit(BookingFormErrorState(message: e.toString()));
      }
    });
  }
}
