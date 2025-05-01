// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ers_linux/core/config/register_module.dart' as _i23;
import 'package:ers_linux/features/auth/presentation/bloc/auth_bloc.dart'
    as _i450;
import 'package:get_it/get_it.dart' as _i174;
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
    return this;
  }
}

class _$RegisterModule extends _i23.RegisterModule {}
