import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Modules/auth/user_store.dart';
import 'package:genopets/Modules/question/pages/QuestionDetail/questionDetail_screen.dart';
import 'package:genopets/Modules/question/question_repository.dart';
import 'package:genopets/Modules/question/question_store.dart';

abstract class QuestionDetailViewModel extends State<QuestionDetail> {
  TextEditingController answerController = TextEditingController();
  String? questionAuthorId;

  final QuestionStore questionStore = Modular.get<QuestionStore>();
  final UserStore userStore = Modular.get<UserStore>();
  final QuestionRepository questionRepository =
      Modular.get<QuestionRepository>();

  @override
  void initState() {
    super.initState();
  }

  ListQuestions() async {
    var questions = FirebaseFirestore.instance
        .collection('Answer')
        .where('QuestionId', isEqualTo: widget.questionId);

    return questions;
  }

  upvoteAnswer(dynamic answer, String id) async {
    bool add = false;
    if((answer.fields['Upvotes']["arrayValue"] as Map).containsKey("values")) {
      if (answer.fields['Upvotes']["arrayValue"]["values"].where((x) => x["stringValue"] == userStore.currentUser?.userId).isEmpty) {
        (answer.fields['Upvotes']["arrayValue"]["values"] as List).add({ "stringValue": userStore.currentUser?.userId });
        (answer.fields['Downvotes']["arrayValue"]["values"] as List).removeWhere((x) => x["stringValue"] == userStore.currentUser?.userId);
        add = true;
      }
    }
    else {
      if((answer.fields['Downvotes']["arrayValue"] as Map).containsKey("values"))
        (answer.fields['Downvotes']["arrayValue"]["values"] as List).removeWhere((x) => x["stringValue"] == userStore.currentUser?.userId);
      
      answer.fields['Upvotes']["arrayValue"]["values"] = [{ "stringValue": userStore.currentUser?.userId }];
      add = true;
    }

    if(add) {
      if (int.parse(answer.fields['VotesNumber']['integerValue']) + 1 == 0) {
        answer.fields['VotesNumber']['integerValue'] = 1;
      } else {
        answer.fields['VotesNumber']['integerValue'] = int.parse(answer.fields['VotesNumber']['integerValue']) + 1;
      }
    }

    await questionRepository.updateAnswer(answer.toJson(), id);
  }

  downvoteAnswer(dynamic answer, String id) async {
    bool subtract = false;
    if((answer.fields['Downvotes']["arrayValue"] as Map).containsKey("values")) {
      if (
        answer.fields['Downvotes']["arrayValue"]["values"].where((x) => x["stringValue"] == (userStore.currentUser?.userId)).isEmpty
      ) {
        (answer.fields['Upvotes']["arrayValue"]["values"] as List).removeWhere((x) => x["stringValue"] == userStore.currentUser?.userId);
        (answer.fields['Downvotes']["arrayValue"]["values"] as List).add({ "stringValue": userStore.currentUser?.userId });
        subtract = true;
      }
    }
    else {
      if((answer.fields['Upvotes']["arrayValue"] as Map).containsKey("values"))
        (answer.fields['Upvotes']["arrayValue"]["values"] as List).removeWhere((x) => x["stringValue"] == userStore.currentUser?.userId);
      
      subtract = true;
      answer.fields['Downvotes']["arrayValue"]["values"] = [{ "stringValue": userStore.currentUser?.userId }];
    }

    if(subtract) {
      if (int.parse(answer.fields['VotesNumber']['integerValue']) - 1 == 0) {
        answer.fields['VotesNumber']['integerValue'] = -1;
      } else {
        answer.fields['VotesNumber']['integerValue'] = int.parse(answer.fields['VotesNumber']['integerValue']) - 1;
      }
    }
    await questionRepository.updateAnswer(answer.toJson(), id);
  }

  Map<dynamic, List> formatListAnsers(List<dynamic> answers) {
    Map<dynamic, List> formattedList = {};
    answers.forEach((element) {
      if(!(element.fields as Map).containsKey("ParentAnswer")) {
        formattedList[element.name!.split("/").last] = [];
      }
      else {
        formattedList[element.fields?['ParentAnswer']['stringValue']]?.add(element);
      }
    });
    return formattedList;
  }

  answerQuestion() async {
    await questionStore.answerQuestion({
      'Text': answerController.text,
      'Upvotes': [],
      'Downvotes': [],
      'Accepted': false,
      'VotesNumber': 0,
      'AuthorId': userStore.currentUser?.userId,
      'QuestionId': widget.questionId,
      'Created_at': Timestamp.now()
    }).then((value) {
      answerController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      Modular.to.pop();
    });
  }
}
