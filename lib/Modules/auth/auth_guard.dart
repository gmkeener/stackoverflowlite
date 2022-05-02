import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Modules/auth/user_store.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth');

  final userStore = Modular.get<UserStore>();

  @override
  bool canActivate(String path, ModularRoute router) {
    return Modular.get<UserStore>().isLoggedIn;
  }
}
