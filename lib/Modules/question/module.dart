import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Modules/auth/auth_guard.dart';
import 'package:genopets/Modules/question/pages/QuestionDetail/questionDetail_screen.dart';
import 'package:genopets/Modules/question/pages/QuestionsList/questionList_screen.dart';
import 'package:genopets/Modules/question/question_repository.dart';
import 'package:genopets/Modules/question/question_store.dart';

class QuestionModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => QuestionRepository()),
        Bind.singleton((i) => QuestionStore())
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/',
            child: (_, args) => QuestionList(), guards: [AuthGuard()]),
        ChildRoute('/:id',
            child: (_, args) => QuestionDetail(
                  questionId: args.params["id"],
                ),
            guards: [AuthGuard()]),
      ];
}
