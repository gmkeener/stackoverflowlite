import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genopets/Modules/auth/auth_repository.dart';
import 'package:genopets/Modules/auth/pages/Login/login_screen.dart';
import 'package:genopets/Modules/auth/pages/Register/register_screen.dart';
import 'package:genopets/Modules/auth/user_store.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

abstract class RegisterScreenViewModel extends State<RegisterScreen> {
  AuthRepository authRepository = Modular.get<AuthRepository>();
  UserStore _userStore = Modular.get<UserStore>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  String? forcedEmailErrorMessage;

  bool isPasswordVisible = false;
  bool showModalMessage = false;
  bool showErrorStatus = false;

  final formKey = GlobalKey<FormState>();

  String removeWhiteSpacesFromString(String stringToRemove) {
    return stringToRemove.replaceAll(' ', '');
  }

  @override
  void initState() {
    super.initState();
  }

  goToLoginPage() {
    Modular.to.navigate("/auth");  
  }

  Future register() async {
    try {
      if (passwordController.text == confirmPasswordController.text &&
          GetUtils.isEmail(emailController.text)) {
        await authRepository
            .register(emailController.text, passwordController.text)
            .then((value) async {
          await authRepository.createUserDocument(
              emailController.text, nameController.text, value.user?.uid);
          await _userStore
              .doLogin(emailController.text, passwordController.text)
              .then((value) {
            Modular.to.navigate("/question");
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong data.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credentials alreary exists.'),
        ),
      );
    }
  }
}
