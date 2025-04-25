import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardTabChanged(tabIndex: 0)) {
    on<DashboardTabChangeRequested>((event, emit) {
      emit(DashboardTabChanged(tabIndex: event.tabIndex));
    });
  }
}
