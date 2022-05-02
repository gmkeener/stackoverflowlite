import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Core/Services/ApiService.dart';
import 'package:genopets/Modules/auth/user_store.dart';
import 'package:genopets/models.dart';

class QuestionRepository {
  ApiService _service = Modular.get<ApiService>();
  UserStore _store = Modular.get<UserStore>();

  Future<dynamic> createQuestion(String title) async {
    try {
      return _service.fetch(
        "post",
        "/Question",
        body: {
          "fields": {
            "Title": {
                "stringValue": title
            },
            "NumAnswers": {
                "integerValue": 0
            },
            "Created_at": {
                "timestampValue": "${DateTime.now().toIso8601String()}Z"
            },
            "Author": {
                "stringValue": _store.currentUser!.userId
            }
          },
          "createTime": "${DateTime.now().toIso8601String()}Z",
          "updateTime": "${DateTime.now().toIso8601String()}Z"
        }
      );
      // await FirebaseFirestore.instance.collection('Question').add({
      //   'Created_at': Timestamp.now(),
      //   'Author': FirebaseAuth.instance.currentUser!.uid,
      //   'Title': title,
      //   'NumAnswers': 0,
      // });
    } catch (e) {
      throw e;
    }
  }

  Future deleteQuestion(String id) async {
    try {
      return _service.fetch(
        "delete",
        "/Question/${id.split("/").last}",
      );
      // await FirebaseFirestore.instance.collection('Question').doc(id).delete();
    } catch (e) {
      throw e;
    }
  }

  Future increaseQuestionAnswers(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Question')
          .doc(id)
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('Question')
            .doc(id)
            .update({'NumAnswers': (value.data() as Map)['NumAnswers'] + 1});
      });
    } catch (e) {
      throw e;
    }
  }

  Future answerQuestion(dynamic answer) async {
    try {
      await FirebaseFirestore.instance.collection('Answer').add(answer);
    } catch (e) {
      throw e;
    }
  }

  Future updateAnswer(dynamic answer, String id) async {
    try {
      return _service.fetch(
        "patch",
        "/Answer/$id",
        body: answer
      );
      // await FirebaseFirestore.instance
      //     .collection('Answer')
      //     .doc(id)
      //     .update(answer);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> acceptAnswer(String answerId, bool setValue) async {
    try {
      return await FirebaseFirestore.instance
          .collection('Answer')
          .where('Accepted', isEqualTo: true)
          .get()
          .then((value) async {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('Answer')
              .doc(element.id)
              .update({'Accepted': false});
        });
        await FirebaseFirestore.instance
            .collection('Answer')
            .doc(answerId)
            .update({'Accepted': setValue});
      });
    } catch (e) {
      throw e;
    }
  }

  Future getQuestionById(String id) async {
    try {
      return await _service.fetch("get", "/Question/$id");
    } catch (e) {
      throw e;
    }
  }

  getAnswersByQuestionId(String id) {
    try {
      return _service.streamFetch("post", ":runQuery", body: {
        "structuredQuery": {
          "from": [
            {"collectionId": "Answer", "allDescendants": true}
          ],
          "where": {
            "fieldFilter": {
              "field": {"fieldPath": "QuestionId"},
              "op": "EQUAL",
              "value": {
                "stringValue": id,
              }
            }
          }
        }
      });
      // return FirebaseFirestore.instance
      //     .collection('Answer')
      //     .where('QuestionId', isEqualTo: id)
      //     .snapshots();
    } catch (e) {
      throw e;
    }
  }

  listMyQuestions() {
    try {
      return _service.streamFetch("post", ":runQuery", body: {
        "structuredQuery": {
          "from": [
            {"collectionId": "Question", "allDescendants": true}
          ],
          "where": {
            "fieldFilter": {
              "field": {"fieldPath": "Author"},
              "op": "EQUAL",
              "value": {
                "stringValue": _store.currentUser?.userId,
              }
            }
          }
        }
      });
      // return FirebaseFirestore.instance
      //     .collection('Question')
      //     .where("Author", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .snapshots();
    } catch (e) {
      throw e;
    }
  }

  listMyQuestionsByDescending() {
    try {
      return _service.streamFetch("post", ":runQuery", body: {
        "structuredQuery": {
          "from": [
            {"collectionId": "Question", "allDescendants": true}
          ],
          "where": {
            "fieldFilter": {
              "field": {"fieldPath": "Author"},
              "op": "EQUAL",
              "value": {
                "stringValue": _store.currentUser?.userId,
              }
            }
          },
          "orderBy": [
            {"field": "NumAnswers", "direction": "DESCENDING"}
          ]
        }
      });
    } catch (e) {
      throw e;
    }
  }

  orderQuestionsByDescending() {
    try {
      return _service.streamFetch("post", ":runQuery", body: {
        "structuredQuery": {
          "from": [
            {"collectionId": "Question", "allDescendants": true}
          ],
          "orderBy": [
            {
              "field": {"fieldPath": "NumAnswers"}, 
              "direction": "DESCENDING"
            }
          ]
        }
      });
    } catch (e) {
      throw e;
    }
  }

  listQuestions() {
    try {
      // return FirebaseFirestore.instance.collection('Question').snapshots();
      return _service.streamFetch(
        "get",
        "/Question",
      );
      // .then((resp) {
      //   List documents = resp.content["documents"];
      //   return documents.map((e) => e as FirestoreDocument).toList();
      // });
    } catch (e) {
      throw e;
    }
  }
}
