import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserProvider() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        log('user not logged in');
      } else {
        log('user signed in');
      }
      notifyListeners();
    });
  }

  User? get getCurrentUser => _firebaseAuth.currentUser;

  void createNewUser(String email, String password) async {
    try {
      UserCredential _cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      log('user created---  ${_cred.toString()}');

      _firebaseFirestore.collection('users').doc(_cred.user!.uid).set({
        'uid': _cred.user!.uid,
        'username': _cred.user!.displayName,
        'email': email,
        'bio': '',
        'last_upload': '',
        'photo_url': '',
        'following': [],
        'follower': []
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('weak password');
      } else if (e.code == 'email-already-in-use') {
        log('email already in use');
      }
    } catch (e) {
      log('create new user error--- $e');
    }
    notifyListeners();
  }

  void loginUser(String email, String password) async {
    try {
      UserCredential _cred = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      log('login user---  ${_cred.toString()}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
    notifyListeners();
  }

  void logoutUser() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log('$e');
    }
    notifyListeners();
  }

  void forgotPassword(email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log('$e');
    }
    notifyListeners();
  }
}
