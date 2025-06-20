
import 'package:ers_linux/core/config/service_locator.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> setupAllLocators() async {
  await getIt.init();
}
