import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/question/pages/QuestionsList/questionList_screen.dart';
import 'package:genopets/Modules/question/question_repository.dart';
import 'package:genopets/models.dart';

abstract class QuestionListViewModel extends State<QuestionList> {
  QuestionRepository questionRepository = Modular.get<QuestionRepository>();
  AuthRepository authRepository = Modular.get<AuthRepository>();

  TextEditingController newQuestionController = TextEditingController();
  TextEditingController findQuestionController = TextEditingController();
  bool? filteredByUSerCheckBox = false;
  Map filterQuery = {};
  final formKey = GlobalKey<FormState>();

  String removeWhiteSpacesFromString(String stringToRemove) {
    return stringToRemove.replaceAll(' ', '');
  }

  @override
  void initState() {
    super.initState();
  }

  detailQuestion(String id) {
    Modular.to.pushNamed("/question/${id.split('/').last}", arguments: id);
  }

  loggedUserIsAnswerAuthor(String authorId) {
    return authorId == FirebaseAuth.instance.currentUser!.uid;
  }

  confirmDeleteQuestion(String id) async {
    await questionRepository.deleteQuestion(id);
    Modular.to.pop();
  }

  createQuestion() async {
    await questionRepository.createQuestion(newQuestionController.text);
    Modular.to.pop();
  }

  Stream<List<FirestoreDocument>> getQuestionsByFilter() {
    if (!filterQuery.containsKey("user") && !filterQuery.containsKey("mostLiked")) 
    {
      return questionRepository.listQuestions();
    } 
    else if (filterQuery.containsKey("user") && !filterQuery.containsKey("mostLiked")) 
    {
      return questionRepository.listMyQuestions();
    } 
    else if (!filterQuery.containsKey("user") && filterQuery.containsKey("mostLiked")) 
    {
      return questionRepository.orderQuestionsByDescending();
    } 
    else {
      return questionRepository.listMyQuestionsByDescending();
    }
  }

  

}
