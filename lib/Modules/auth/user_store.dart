import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/auth/models/AuthCredentialModel.dart';
import 'package:genopets/module.dart';

class UserStore {
  final AuthRepository authRepository = Modular.get<AuthRepository>();

  bool _isLoggedIn = false;
  AuthCredentialModel? _currentUser;

  doLogin(String email, String password) async {
    try {
      final AuthCredentialModel _authCredentialModel = await authRepository.login(email, password);
      if(_authCredentialModel.idToken != null) {
        setIsLoggedIn(true);
        _currentUser = _authCredentialModel;
        Modular.to.navigate(Routes.question);
      }
    } catch (e) {
      throw e;
    }
  }

  // Stream<QuerySnapshot> getUserById(String userId) {
  //   try {
  //     return authRepository.getUserById(userId);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  bool get isLoggedIn => _isLoggedIn;
  AuthCredentialModel? get currentUser => _currentUser;
  void setIsLoggedIn(bool value) => _isLoggedIn = value;

}
