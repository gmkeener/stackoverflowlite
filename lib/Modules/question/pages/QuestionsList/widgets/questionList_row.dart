import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Core/Extensions/color_to_hex.dart';
import 'package:genopets/Core/Helpers/DateHelper.dart';
import 'package:genopets/Core/Helpers/ScreenHelper.dart';
import 'package:genopets/Core/Services/ResponseModel.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/question/question_repository.dart';
import 'package:genopets/models.dart';

class QuestionListRow extends StatelessWidget {
  QuestionRepository questionRepository = Modular.get<QuestionRepository>();
  AuthRepository authRepository = Modular.get<AuthRepository>();

  final Function(String) onDetailQuestion;
  final Function(String) onCheckLoggedUser;
  final Function(String) onConfirmDeleteQuestion;
  final Map data;
  final String id;

  QuestionListRow(
      {Key? key,
      required this.onDetailQuestion,
      required this.data,
      required this.onCheckLoggedUser,
      required this.onConfirmDeleteQuestion, 
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onDetailQuestion(id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: HexColor.fromHex("#FDF7E2"),
          border: Border.all(
            color: HexColor.fromHex("#E3E6E8"),
            width: 0.4
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    "${data['NumAnswers']['integerValue']} answers",
                    style: TextStyle(
                      fontFamily: 'Acumin Pro',
                      color: Colors.grey[700]
                    )
                  )
                ],
              ),
            ),
            Container(
              child: Text(
                data['Title']['stringValue'],
                style: TextStyle(
                  fontFamily: 'Acumin Pro',
                  color: HexColor.fromHex("#2995FF"),
                  fontWeight: FontWeight.w600
                )
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 2),
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
                    margin: EdgeInsets.only(right: 2),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder(
                    future: authRepository.getUserById(data['Author']['stringValue']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            Container(
                              child: Text(
                                (snapshot.data as ResponseModel).content.first["document"]["fields"]['Name']['stringValue'],
                                style: TextStyle(
                                  fontFamily: 'Acumin Pro',
                                  color: HexColor.fromHex("#2995FF"),
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenHelper.screenWidthPercentage(context, 3.2),
                                )
                              ),
                            ),
                            if((snapshot.data as ResponseModel).content.first["document"]["fields"]['uid']['stringValue'] == FirebaseAuth.instance.currentUser?.uid)
                            GestureDetector(
                              onTap: () async {
                                await questionRepository.deleteQuestion(id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.delete_outline),
                              )
                            )       
                          ],
                        );
                      }
                      else {
                        return Container();
                      }
                    }
                  ), 
                  // StreamBuilder<List<FirestoreDocument>>(
                  //   stream: authRepository.getUserById(data['Author']['stringValue']),
                  //   builder: ((context, AsyncSnapshot<List<FirestoreDocument>> snapshotUser) {
                  //     return Text(
                  //       snapshotUser.hasData ? "${(snapshotUser.requireData).first.fields?['Name']['stringValue']}" : "",
                  //       style: TextStyle(
                  //         fontFamily: 'Acumin Pro',
                  //         color: HexColor.fromHex("#2995FF"),
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: ScreenHelper.screenWidthPercentage(context, 3.2),
                  //       )
                  //     );
                  //   })
                  // ),           
                ],
              )
            )
          ]
        )
      ),
    );
  }
}
