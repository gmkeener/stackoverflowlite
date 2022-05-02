import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Core/Extensions/color_to_hex.dart';
import 'package:genopets/Core/Helpers/DateHelper.dart';
import 'package:genopets/Core/Helpers/ScreenHelper.dart';
import 'package:genopets/Modules/question/pages/QuestionsList/questionList_view_model.dart';
import 'package:genopets/Modules/question/pages/QuestionsList/widgets/questionList_row.dart';
import 'package:genopets/models.dart';

class QuestionListView extends QuestionListViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('stackoverflow'),
          centerTitle: true,
          backgroundColor: HexColor.fromHex("#F48225"),
          leading: IconButton(
              icon: Icon(
                !filterQuery.containsKey("user")
                    ? Icons.account_circle_outlined
                    : Icons.account_circle,
              ),
              onPressed: () async {
                if (!filterQuery.containsKey("user"))
                  setState(() {
                    filterQuery["user"] =
                        FirebaseAuth.instance.currentUser?.uid;
                  });
                else
                  setState(() {
                    filterQuery.remove("user");
                  });
              }),
          actions: [
            IconButton(
                icon: Transform.rotate(
                  angle: 0,
                  child: Icon(Icons.compare_arrows_sharp),
                ),
                onPressed: () async {
                  if (!filterQuery.containsKey("mostLiked"))
                    setState(() {
                      filterQuery["mostLiked"] = true;
                    });
                  else
                    setState(() {
                      filterQuery.remove("mostLiked");
                    });
                }),
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "New Question",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: ScreenHelper.screenWidthPercentage(
                                    context, 5),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: newQuestionController,
                            decoration: InputDecoration(
                                labelText: 'Question',
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(height: 10),
                          RaisedButton(
                            child: Text('Submit'),
                            onPressed: () async => createQuestion(),
                          )
                        ],
                      ),
                    ));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF00A8B5),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 5),
            child: StreamBuilder<List<FirestoreDocument>>(
                stream: getQuestionsByFilter(),
                builder: (context, AsyncSnapshot<List<FirestoreDocument>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text('Waiting...');
                  } else {
                    final data = snapshot.requireData;
                    return ListView(
                      children: data.map((value) => QuestionListRow(
                          id: value.name as String,
                          data: value.fields as Map,
                          onDetailQuestion: (value) => detailQuestion(value),
                          onCheckLoggedUser: (value) => loggedUserIsAnswerAuthor(value),
                          onConfirmDeleteQuestion: (value) => confirmDeleteQuestion(value),
                        )).toList()
                    );
                  }
                })));
  }
}
