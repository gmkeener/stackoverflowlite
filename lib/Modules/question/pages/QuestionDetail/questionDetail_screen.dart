import 'package:flutter/material.dart';
import 'package:genopets/Modules/question/pages/QuestionDetail/questionDetail_screen_view.dart';

class QuestionDetail extends StatefulWidget {
  final dynamic questionId;
  const QuestionDetail({Key? key, this.questionId}) : super(key: key);

  @override
  QuestionDetailView createState() => QuestionDetailView();
}
