import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class AuthService{
  final auth = FirebaseAuth.instance;
  
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try{
      final credential = await auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    }
    catch(e){
      log("something went wrong $e");
      print(auth);
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try{
      final credential = await auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return credential.user;
    }
    catch(e){
      log("$e");
    }
    return null;
  }

}