import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../screens/schedule_screen.dart';
import '../screens/timesheet_screen.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/fancy_bottom_bar.dart';

class DashboardScreen extends StatelessWidget {
  static String routePath = '/dashboard';

  const DashboardScreen({super.key});

  final List<Widget> _pages = const [
    ScheduleScreen(),
    TimesheetScreen(),
    SettingsScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final currentIndex =
          state is DashboardTabChanged ? state.tabIndex : 0;

          return Scaffold(
            backgroundColor: Color(0xFFEFF7FF),
            body: IndexedStack(
              index: currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: FancyBottomBar(
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<DashboardBloc>().add(
                  DashboardTabChangeRequested(index),
                );
              },
            ),
          );
        },
      ),
    );
  }
}




