import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:genopets/Core/Extensions/color_to_hex.dart';
import 'package:genopets/Core/Helpers/ScreenHelper.dart';
import 'package:genopets/Modules/auth/pages/Login/login_screen_view_model.dart';

class LoginScreenView extends LoginScreenViewModel {
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
                      fit: BoxFit.contain, scale: 1.5),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          ScreenHelper.screenWidthPercentage(context, 14)),
                  child: Wrap(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: this.emailController,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(this.senhaFocusNode);
                        },
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          fontFamily: 'Acumin Pro',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.2,
                          letterSpacing: 0.15,
                        ),
                        onChanged: (value) {
                          if (showErrorStatus) {
                            setState(() {
                              showErrorStatus = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintStyle: TextStyle(
                              fontFamily: 'Acumin Pro',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              height: 1.2,
                              letterSpacing: 0.15,
                              color: Colors.grey[600]),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          hintText: 'EMAIL',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: showErrorStatus
                                    ? HexColor.fromHex('#FF0404')
                                    : Colors.black,
                                width: showErrorStatus ? 2 : 0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: HexColor.fromHex('#FF0404'), width: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              ScreenHelper.screenHeightPercentage(context, 6)),
                      TextFormField(
                        controller: this.senhaController,
                        focusNode: this.senhaFocusNode,
                        obscureText: true,
                        style: TextStyle(
                          fontFamily: 'Acumin Pro',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.2,
                          letterSpacing: 0.15,
                        ),
                        onChanged: (value) {
                          if (showErrorStatus) {
                            setState(() {
                              showErrorStatus = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintStyle: TextStyle(
                              fontFamily: 'Acumin Pro',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              height: 1.2,
                              letterSpacing: 0.15,
                              color: Colors.grey[600]),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          hintText: 'PASSWORD',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: showErrorStatus
                                    ? HexColor.fromHex('#FF0404')
                                    : Colors.black,
                                width: showErrorStatus ? 2 : 0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: HexColor.fromHex('#FF0404'), width: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              ScreenHelper.screenHeightPercentage(context, 10)),
                      ElevatedButton(
                        onPressed: () => doLogin(),
                        child: Text("ENTER",
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
                      SizedBox(
                          height:
                              ScreenHelper.screenHeightPercentage(context, 10)),
                      Container(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () => goToRegisterPage(),
                            child: Text(
                              "Register",
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
