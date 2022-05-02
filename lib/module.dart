import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Core/Services/ApiService.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/auth/module.dart';
import 'package:genopets/Modules/auth/user_store.dart';
import 'package:genopets/Modules/question/module.dart';

class MainModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => UserStore()),
        Bind.singleton((i) => ApiService(url: dotenv.env['BASE_URL'])),
        Bind.singleton((i) => AuthRepository()),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Routes.main, module: AuthModule()),
        ModuleRoute(Routes.question, module: QuestionModule()),
      ];
}

class Routes {
  static const main = "/";
  static const question = "/question";
}
