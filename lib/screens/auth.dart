import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/custom_inputs/avatar_picker.dart';
import 'package:flashlist/widgets/custom_inputs/password_input.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TOOD: Add a link to the privacy policy and terms of service
// TODO: add logic to send verification email

final _firebase = FirebaseAuth.instance;

class AuthScreen extends HookWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

    var isLogin = useState(true);
    var isAuthenticating = useState(false);

    var enteredEmail = '';
    var enteredUsername = '';
    var enteredPassword = '';
    File? selectedImage;

    void showSnackBar(FirebaseAuthException error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ??
              '${retrieveAppLocalizations(context).encounteredError}!'),
          backgroundColor: retrieveColorScheme(context).error,
        ),
      );
    }

    void submit() async {
      final isValid = formkey.currentState!.validate();

      if (!isValid) {
        return;
      }

      formkey.currentState!.save();

      try {
        isAuthenticating.value = true;

        if (isLogin.value) {
          await _firebase.signInWithEmailAndPassword(
            email: enteredEmail,
            password: enteredPassword,
          );
        } else {
          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
            email: enteredEmail,
            password: enteredPassword,
          );

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putFile(selectedImage!);
          final imageUrl = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredentials.user!.uid)
              .set({
            'username': enteredUsername,
            'email': enteredEmail,
            'image_url': imageUrl,
            'uid': userCredentials.user!.uid,
            'notifications': [],
          });
        }
      } on FirebaseAuthException catch (error) {
        isAuthenticating.value = false;
        showSnackBar(error);
      }
    }

    return Scaffold(
      backgroundColor: retrieveColorScheme(context).background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                AdaptiveTheme.of(context).mode.isDark
                    ? 'assets/favicon/logo_white_no_background.png'
                    : 'assets/favicon/logo_black_no_background.png',
                width: 120,
                height: 120,
              ),
              Card(
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isLogin.value)
                            AvatarPicker(
                              onPickImage: (pickedImage) {
                                selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              labelText:
                                  retrieveAppLocalizations(context).email,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return retrieveAppLocalizations(context)
                                    .pleaseEnterValidEmail;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredEmail = newValue!;
                            },
                          ),
                          if (!isLogin.value)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText:
                                    retrieveAppLocalizations(context).username,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return retrieveAppLocalizations(context)
                                      .pleaseEnterValidUsername;
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredUsername = newValue!;
                              },
                            ),
                          PasswordInput(
                            labelText:
                                retrieveAppLocalizations(context).password,
                            textInputAction: TextInputAction.done,
                            onSaved: (newValue) {
                              enteredPassword = newValue!;
                            },
                          ),
                          gapH12,
                          if (isAuthenticating.value == true)
                            CircularProgressIndicator(
                              color: retrieveColorScheme(context).primary,
                            ),
                          if (!isAuthenticating.value)
                            ElevatedButton(
                              onPressed: submit,
                              child: isLogin.value
                                  ? Text(
                                      retrieveAppLocalizations(context).signIn)
                                  : Text(
                                      retrieveAppLocalizations(context).signUp),
                            ),
                          if (!isAuthenticating.value)
                            TextButton(
                              onPressed: () {
                                isLogin.value = !isLogin.value;
                              },
                              child: isLogin.value
                                  ? Text(
                                      retrieveAppLocalizations(context)
                                          .createNewAccount,
                                    )
                                  : Text(
                                      retrieveAppLocalizations(context)
                                          .alreadyHaveAccount,
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
