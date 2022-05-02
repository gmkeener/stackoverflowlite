import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Modules/auth/user_store.dart';

class RedirectGuard extends RouteGuard {
  RedirectGuard() : super(redirectTo: '/auth');

  @override
  bool canActivate(String path, ModularRoute router) {
    return path == "/";
  }
}
