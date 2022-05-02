import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Core/Extensions/color_to_hex.dart';
import 'package:genopets/Core/Helpers/ScreenHelper.dart';
import 'package:genopets/Core/Services/ResponseModel.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/auth/user_store.dart';
import 'package:genopets/Modules/question/question_repository.dart';
import 'package:genopets/Modules/question/question_store.dart';

class AnswerCard extends StatefulWidget {
  final String text;
  final String answerId;
  final String? parentId;
  final String questionId;
  final String author;
  final int votes;
  final bool canAccept;
  final List<dynamic>? subAnswers;
  final bool favorite;
  final VoidCallback onTapUpvote;
  final VoidCallback onTapDownvote;
  const AnswerCard({
    Key? key,
    required this.text,
    required this.votes,
    required this.onTapUpvote,
    required this.onTapDownvote,
    required this.favorite,
    required this.author,
    required this.answerId,
    required this.canAccept, 
    required this.questionId, 
    this.parentId, 
    this.subAnswers,
  }) : super(key: key);

  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  final UserStore _userStore = Modular.get<UserStore>();
  final QuestionStore _questionStore = Modular.get<QuestionStore>();
  TextEditingController answerController = TextEditingController();
  final QuestionRepository _questionRepository = Modular.get<QuestionRepository>();
  final AuthRepository _authRepository = Modular.get<AuthRepository>();

  answerQuestionsAnswer() async {
    await _questionRepository.answerQuestion({
      'Text': answerController.text,
      'Upvotes': [],
      'Downvotes': [],
      'Accepted': false,
      'VotesNumber': 0,
      'AuthorId': _userStore.currentUser!.userId,
      'ParentAnswer': widget.answerId,
      'QuestionId': widget.questionId,
      'Created_at': Timestamp.now()
    });
    answerController.clear();
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.6,
          ),
        )),
        margin: EdgeInsets.only(left: widget.parentId == null ? 10 : 30, right: 10, top: 5, bottom: 5),
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 10,
          top: 0,
          bottom: 13,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTapUpvote();
                  },
                  child: Icon(
                    Icons.arrow_drop_up_outlined,
                    size: 23,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  widget.votes.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize:
                          ScreenHelper.screenHeightPercentage(context, 1.7)),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTapDownvote();
                  },
                  child: Icon(
                    Icons.arrow_drop_down_outlined,
                    size: 23,
                    color: Colors.grey[600],
                  ),
                ),
                widget.canAccept
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          onTap: () async => await _questionStore.acceptAnswer(
                              widget.answerId, !widget.favorite),
                          child: Icon(
                            Icons.check_box,
                            size: 18,
                            color: widget.favorite ? Colors.green : Colors.grey,
                          ),
                        ))
                    : Container(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: ScreenHelper.screenHeightPercentage(context, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      widget.text,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenHelper.screenHeightPercentage(
                              context, 2.1)),
                    ),
                  ),
                  SizedBox(
                      height:
                          ScreenHelper.screenHeightPercentage(context, 1.8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FutureBuilder(
                        future: _authRepository.getUserById(widget.author),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              child: Text(
                                (snapshot.data as ResponseModel).content.first["document"]["fields"]['Name']['stringValue'],
                                style: TextStyle(
                                  fontFamily: 'Acumin Pro',
                                  color: HexColor.fromHex("#2995FF"),
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenHelper.screenWidthPercentage(context, 3.2),
                                )
                              ),
                            );
                          }
                          else {
                            return Container();
                          }
                        }
                      ), 
                      // StreamBuilder(
                      //     stream: _userStore.getUserById(widget.author),
                      //     builder: ((context,
                      //         AsyncSnapshot<QuerySnapshot> snapshotUser) {
                      //       if (snapshotUser.hasError) {
                      //         return Text('Error: ${snapshotUser.error}');
                      //       } else if (snapshotUser.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return Text('Waiting...');
                      //       }
                      //       return Text(
                      //         "${(snapshotUser.requireData.docs.first.data() as Map)['Name']}",
                      //         style: TextStyle(
                      //             color: HexColor.fromHex("#2995FF"),
                      //             fontSize: ScreenHelper.screenWidthPercentage(
                      //                 context, 3)),
                      //       );
                      //     })),
                      widget.parentId == null ? Container(
                        margin: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                            onTap: () async {
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
                                            onPressed: () async => answerQuestionsAnswer(),
                                          )
                                        ],
                                      ),
                                    ));
                            },
                            child: Icon(Icons.inbox,
                                color: Colors.grey[600], size: 18)),
                      ) : Container()
                    ],
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
