import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


typedef LoginProviderNotifier =
AutoDisposeAsyncNotifierProvider<LoginProvider, void>;

final loginProvider = LoginProviderNotifier(LoginProvider.new);

class LoginProvider extends AutoDisposeAsyncNotifier<void> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  FutureOr build()  {
    //throw UnimplementedError();
  }

  Future<void> authRegister() async {
    try{
     log("trying to register");

    }catch(e) {

    }
  }

}
