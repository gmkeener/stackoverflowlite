import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Core/Extensions/color_to_hex.dart';
import 'package:genopets/Core/Helpers/DateHelper.dart';
import 'package:genopets/Core/Helpers/ScreenHelper.dart';
import 'package:genopets/Core/Services/ResponseModel.dart';
import 'package:genopets/Modules/auth/user_store.dart';
import 'package:genopets/Modules/question/pages/QuestionDetail/questionDetail_view_model.dart';
import 'package:genopets/Modules/question/pages/QuestionDetail/widgets/AnswerCard.dart';
import 'package:genopets/models.dart';

class QuestionDetailView extends QuestionDetailViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Question Detail'),
          centerTitle: true,
          backgroundColor: Color(0xFF00A8B5),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            "New Answer",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: ScreenHelper.screenWidthPercentage(
                                    context, 5),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: answerController,
                            decoration: InputDecoration(
                                labelText: 'Answer',
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(height: 10),
                          RaisedButton(
                            child: Text('Submit'),
                            onPressed: () async => answerQuestion(),
                          )
                        ],
                      ),
                    ));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF00A8B5),
        ),
        backgroundColor: Colors.white,
        body: Container(
            margin: EdgeInsets.only(top: 5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                      child: FutureBuilder(
                        future: questionRepository.getQuestionById(widget.questionId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    top: 10,
                                  ),
                                  child: Text(
                                    (snapshot.data as ResponseModel).content["fields"]['Title']['stringValue'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenHelper.screenHeightPercentage(context, 2.4)),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          color: HexColor.fromHex("#D0E3F1"),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "python",
                                          style: TextStyle(
                                            color: HexColor.fromHex("#2C5877")
                                          ),
                                        )
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                            color: HexColor.fromHex("#D0E3F1"),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "c++",
                                            style: TextStyle(
                                              color: HexColor.fromHex("#2C5877")
                                            ),
                                          )
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: HexColor.fromHex("#D0E3F1"),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "javascript",
                                            style: TextStyle(
                                              color: HexColor.fromHex("#2C5877")
                                            ),
                                          )
                                        )
                                    ]
                                  )
                                ),
                                Container(
                                    width: ScreenHelper.screenWidthPercentage(
                                        context, 50),
                                    padding:
                                        EdgeInsets.only(left: 10, top: 15),
                                    child: Text(
                                        "Posted at: ${DateHelper.formatFromDateString((snapshot.data as ResponseModel).content["fields"]['Created_at']['timestampValue'])}"))
                              ],
                            ); 
                          }
                          else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      )
                      
                      // StreamBuilder<List<FirestoreDocument>>(
                      //   stream: questionRepository.getQuestionById(widget.questionId),
                      //   builder: (context, AsyncSnapshot<List<FirestoreDocument>> snapshot) {
                      //     if (snapshot.hasError) {
                      //       return Text('Error: ${snapshot.error}');
                      //     } else if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return Text('Waiting...');
                      //     } else {
                      //       final data = snapshot.requireData[0];
                      //       questionAuthorId = (data as Map)['Author'];
                            
                      //     }
                      //   })
                  ),
                  Container(
                    height: 0.5,
                    color: HexColor.fromHex("#BABFC4"),
                    margin: EdgeInsets.only(right: 7, left: 7),
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(top: 25, left: 10, bottom: 5),
                    child: Text(
                      "Answers",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenHelper.screenHeightPercentage(context, 2.3)
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenHelper.screenHeightPercentage(context, 62),
                    child: StreamBuilder<List<FirestoreDocument>>(
                        stream: questionStore.getAnswersByQuestionId(widget.questionId),
                        builder:
                            (context, AsyncSnapshot<List<FirestoreDocument>> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Waiting...');
                          } else {
                            final data = snapshot.requireData;
                            return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  var dataParsed = data[index];
                                  var loggedUserId = userStore.currentUser?.userId;
                                  return AnswerCard(
                                    parentId: (dataParsed.fields as Map).containsKey("ParentAnswer") ?
                                      dataParsed.fields!['ParentAnswer']["stringValue"] :
                                      null,
                                    questionId: widget.questionId,
                                    answerId: data[index].name!.split("/").last,
                                    text: dataParsed.fields?['Text']["stringValue"],
                                    votes: int.parse(dataParsed.fields?['VotesNumber']["integerValue"]),
                                    favorite: dataParsed.fields?['Accepted']["booleanValue"],
                                    author: dataParsed.fields?["AuthorId"]["stringValue"],
                                    canAccept: loggedUserId == questionAuthorId,
                                    onTapUpvote: () async => upvoteAnswer(dataParsed, data[index].name!.split("/").last),
                                    onTapDownvote: () async => downvoteAnswer(dataParsed, data[index].name!.split("/").last),
                                  );
                                });
                          }
                        }),
                  ),
                ],
              ),
            )));
  }
}
