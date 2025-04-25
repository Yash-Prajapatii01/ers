part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardTabChanged extends DashboardState {
  final int tabIndex;

  const DashboardTabChanged({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}
