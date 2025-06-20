// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ers_linux/core/config/injection.dart' as _i641;
import 'package:ers_linux/features/auth/presentation/bloc/auth_bloc.dart'
    as _i450;
import 'package:ers_linux/features/scheduling/data/data_source/network.dart'
    as _i480;
import 'package:ers_linux/features/scheduling/presentation/utils/BookingFormBloc/booking_form_bloc.dart'
    as _i55;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.factoryParam<
      _i450.AuthenticationBloc,
      _i450.AuthenticationState?,
      dynamic
    >(
      (initialState, _) => _i450.AuthenticationBloc(
        supabaseClient: gh<_i454.SupabaseClient>(),
        initialState: initialState,
      ),
    );
    gh.lazySingleton<_i480.BookingFormRemoteSource>(
      () => _i480.BookingFormRemoteSourceImpl(client: gh<_i519.Client>()),
    );
    gh.factory<_i55.BookingFormBloc>(
      () => _i55.BookingFormBloc(
        remoteSource: gh<_i480.BookingFormRemoteSource>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i641.RegisterModule {}
