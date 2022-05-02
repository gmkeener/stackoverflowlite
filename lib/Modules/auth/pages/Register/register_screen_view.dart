import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:genopets/Core/Extensions/color_to_hex.dart';
import 'package:genopets/Core/Helpers/ScreenHelper.dart';
import 'package:genopets/Modules/auth/pages/Login/login_screen_view_model.dart';
import 'package:genopets/Modules/auth/pages/Register/register_screen_view_model.dart';
import 'package:genopets/Modules/auth/pages/Register/widgets/custom_text_form_field.dart';

class RegisterScreenView extends RegisterScreenViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            height: ScreenHelper.screenHeight(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 54, vertical: 19),
                  child: Image.asset('assets/images/logo.png',
                      fit: BoxFit.contain, scale: 3),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 20),
                  child: Text(
                    "Register Page",
                    style: TextStyle(
                      fontFamily: 'Acumin Pro',
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenHelper.screenWidthPercentage(context, 6),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          ScreenHelper.screenWidthPercentage(context, 14)),
                  child: Wrap(
                    children: [
                      CustomTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Name",
                        controller: nameController,
                        focusNode: nameFocusNode,
                        nextNode: emailFocusNode,
                        isPassword: false,
                      ),
                      CustomTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        hintText: "E-mail",
                        controller: emailController,
                        focusNode: emailFocusNode,
                        nextNode: passwordFocusNode,
                        isPassword: false,
                      ),
                      CustomTextFormField(
                        hintText: "Password",
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        nextNode: confirmPasswordFocusNode,
                        isPassword: true,
                      ),
                      CustomTextFormField(
                        hintText: "Confirm Password",
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        isPassword: true,
                      ),
                      SizedBox(
                          height:
                              ScreenHelper.screenHeightPercentage(context, 10)),
                      ElevatedButton(
                        onPressed: () => register(),
                        child: Text("REGISTER",
                            style: TextStyle(
                                fontFamily: 'Acumin Pro',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                letterSpacing: 0.15,
                                height: 1)),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 12)),
                            minimumSize: MaterialStateProperty.all(
                                Size(double.maxFinite, 0)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            shadowColor: MaterialStateProperty.all(
                                HexColor.fromHex('#40000000')),
                            backgroundColor: MaterialStateProperty.all(
                                HexColor.fromHex('#E9A339'))),
                      ),
                      Container(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () => goToLoginPage(),
                            child: Text(
                              "back to login",
                              textAlign: TextAlign.center,
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
