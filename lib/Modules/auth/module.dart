import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Modules/auth/auth_guard.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/auth/pages/Login/login_screen.dart';
import 'package:genopets/Modules/auth/pages/Register/register_screen.dart';
import 'package:genopets/Modules/auth/redirect_guard.dart';
import 'package:genopets/Modules/auth/user_store.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(AppRoutes.home,
            child: (_, args) => LoginScreen(), guards: [RedirectGuard()]),
        ChildRoute(
          AppRoutes.auth,
          child: (_, args) => LoginScreen(),
        ),
        ChildRoute(AppRoutes.register, child: (_, args) => RegisterScreen()),
      ];
}

class AppRoutes {
  static const home = "/";
  static const auth = "/auth";
  static const register = "/auth/register";
}
