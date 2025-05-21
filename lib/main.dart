import 'package:ers_linux/features/auth/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/router.dart';
import 'shared/theme/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jyqqaymjgytkralrxcey.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp5cXFheW1qZ3l0a3JhbHJ4Y2V5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MjEyNTgsImV4cCI6MjA2MDE5NzI1OH0.nOX7d3aJY_zLiuNkIAi3YKjNboAFIVSrHJtzRWHEc2s',
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await configureDependencies();
  // setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create:
                  (_) => AuthenticationBloc(
                    supabaseClient: getIt<SupabaseClient>(),
                  ),
              // why we were using the getIt<AuthenticationBloc>(),
            ),
          ],
          child: MaterialApp.router(
            title: 'eResource Scheduler',
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: getAppTheme(context),
          ),
        );
      },
    );
  }
}
