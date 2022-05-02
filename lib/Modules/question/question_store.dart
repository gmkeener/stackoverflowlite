import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/question/question_repository.dart';
import 'package:genopets/module.dart';

class QuestionStore {
  final QuestionRepository _questionRepository = Modular.get<QuestionRepository>();

  Future<dynamic> acceptAnswer(String answerId, bool value) async {
    try {
      await _questionRepository.acceptAnswer(answerId, value);
    } catch (e) {
      throw e;
    }
  }

  getAnswersByQuestionId(String id) {
    try {
      return _questionRepository.getAnswersByQuestionId(id);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> answerQuestion(dynamic answer) async {
    try {
      await _questionRepository.answerQuestion(answer);
      await _questionRepository.increaseQuestionAnswers(answer['QuestionId']);
    } catch (e) {
      throw e;
    }
  }
}
