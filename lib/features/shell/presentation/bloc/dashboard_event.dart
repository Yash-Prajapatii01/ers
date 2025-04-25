part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}

final class DashboardTabChangeRequested extends DashboardEvent {
  final int tabIndex;

  const DashboardTabChangeRequested(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
