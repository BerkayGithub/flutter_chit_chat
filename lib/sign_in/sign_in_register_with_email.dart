import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chit_chat/hatalar.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:flutter_chit_chat/widgets/platforma_duyarli_dialog.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

enum FormType { login, register }

class SignInRegisterWithEmail extends StatefulWidget {
  const SignInRegisterWithEmail({super.key});

  @override
  State<SignInRegisterWithEmail> createState() =>
      _SignInRegisterWithEmailState();
}

class _SignInRegisterWithEmailState extends State<SignInRegisterWithEmail> {
  final _formKey = GlobalKey<FormState>();
  var _email = "", _password = "";
  var _formType = FormType.login;

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Giriş / Kayıt")),
      body: userViewModel.viewState == ViewState.idle
          ? SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        initialValue: "email",
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Email",
                          border: OutlineInputBorder(),
                          errorText: userViewModel.emailHataMesaji,
                        ),
                        onSaved: (deger) {
                          _email = deger!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        initialValue: "password",
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          hintText: "Şifre",
                          border: OutlineInputBorder(),
                          errorText: userViewModel.sifreHataMesaji,
                        ),
                        onSaved: (deger) {
                          _password = deger!;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _signInOrRegister,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: _formType == FormType.login
                            ? Text("Giriş yap")
                            : Text("Kayıt ol"),
                      ),
                    ),
                    TextButton(
                      onPressed: _changeFormType,
                      child: _formType == FormType.login
                          ? Text("Hesabınız yok mu? Kayıt olun")
                          : Text("Hesabınız zaten var mı? Giriş yapın"),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void _signInOrRegister() async {
    _formKey.currentState?.save();
    debugPrint("email: $_email şifre: $_password");
    if (_formType == FormType.login) {
      try {
        final user = await Provider.of<UserViewModel>(
          context,
          listen: false,
        ).signInWithEmail(_email, _password);
        afterSignInOrRegister(user);
      } on PlatformException catch (e) {
        PlatformaDuyarliDialog(title: "Giriş Hatası", content: Hatalar.hataGoster(e.code), firstButtonText: 'Tamam', ).goster(context);
      } on FirebaseAuthException catch(e){
        PlatformaDuyarliDialog(title: "Giriş Hatası", content: Hatalar.hataGoster(e.code), firstButtonText: 'Tamam', ).goster(context);
      } on Exception catch(e){
        PlatformaDuyarliDialog(title: "Giriş Hatası", content: Hatalar.hataGoster(e.toString()), firstButtonText: 'Tamam', ).goster(context);
      }
    } else {
      try {
        final user = await Provider.of<UserViewModel>(
          context,
          listen: false,
        ).signUpWithEmail(_email, _password);
        afterSignInOrRegister(user);
      } on PlatformException catch (e) {
        PlatformaDuyarliDialog(title: "Kayıt Hatası", content: Hatalar.hataGoster(e.code), firstButtonText: 'Tamam', ).goster(context);
      } on Exception catch(e){
        PlatformaDuyarliDialog(title: "Kayıt Hatası", content: Hatalar.hataGoster(e.toString()), firstButtonText: 'Tamam', ).goster(context);
      }
    }
  }

  void afterSignInOrRegister(UserModel? user) {
    if (user != null) {
      debugPrint("Oturum açan user ${user.userID}");
      Future.delayed(Duration(milliseconds: 50), () {
        Navigator.of(context).pop();
      });
    }
  }

  void _changeFormType() {
    setState(() {
      _formType = _formType == FormType.login
          ? FormType.register
          : FormType.login;
    });
  }
}
