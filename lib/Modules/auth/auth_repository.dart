import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:genopets/Core/Services/ApiService.dart';
import 'package:genopets/Modules/auth/models/AuthCredentialModel.dart';

class AuthRepository {
  ApiService _service = Modular.get<ApiService>();

  Future<AuthCredentialModel> login(String email, String password) async {
    try {
      // UserCredential userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      String refreshToken = await getRefreshToken(email, password);
      AuthCredentialModel authCredentialModel = await getIdToken(refreshToken);
      return authCredentialModel;
    } catch (e) {
      throw e;
    }
  }

  Future<String> getRefreshToken(String email, String password) async {
    return await _service
        .fetch("post", null,
            absoluteUrl:
                "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${dotenv.env['API_KEY']}",
            body: {
              "email": email,
              "password": password,
              "returnSecureToken": true
            },
            needsCheckToken: false)
        .then((resp) {
      var refreshToken = resp.content["refreshToken"];
      return refreshToken;
    });
  }

  Future<dynamic> getIdToken(String refreshToken) async {
    return await _service.fetch("post", null,
        absoluteUrl:
            "https://securetoken.googleapis.com/v1/token?key=${dotenv.env['API_KEY']}",
        body: {
          "grant_type": "refresh_token",
          "refresh_token": refreshToken,
        }).then((resp) {
      return AuthCredentialModel.fromJson(resp.content);
    });
  }

  Future<UserCredential> register(String email, String password) async {
    try {
      UserCredential userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredentials;
    } catch (e) {
      throw e;
    }
  }

  createUserDocument(String email, String name, String? id) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .add({"Email": email, "Name": name, "uid": id});
    } catch (e) {
      throw e;
    }
  }

  Future getUserById(String userId) async {
    try {
      return await _service.fetch("post", ":runQuery", body: {
        "structuredQuery": {
          "from": [
            {"collectionId": "User", "allDescendants": true}
          ],
          "where": {
            "fieldFilter": {
              "field": {"fieldPath": "uid"},
              "op": "EQUAL",
              "value": {
                "stringValue": userId,
              }
            }
          }
        }
      });
      // return FirebaseFirestore.instance
      //     .collection('User')
      //     .where('uid', isEqualTo: userId)
      //     .snapshots();
    } catch (e) {
      throw e;
    }
  }
}
