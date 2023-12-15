import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flashlist/constants/app_sizes.dart';
import 'package:flashlist/utils/context_retriever.dart';
import 'package:flashlist/widgets/custom_inputs/avatar_picker.dart';
import 'package:flashlist/widgets/custom_inputs/password_input.dart';
import 'package:flashlist/widgets/svg/logo_branding_vertical.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TODO: Add a link to the privacy policy and terms of service
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

    void useSnackbar(message) {
      showContextSnackBar(message: message, context: context);
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
        useSnackbar(error.message!);
      }
    }

    return Scaffold(
      backgroundColor: colorSchemeOf(context).background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LogoBrandingVertical(
                width: 180,
                height: 180,
              ),
              Card(
                margin: const EdgeInsets.all(Sizes.p8),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p16),
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
                              labelText: appLocalizationsOf(context).email,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return appLocalizationsOf(context)
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
                                labelText: appLocalizationsOf(context).username,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return appLocalizationsOf(context)
                                      .pleaseEnterValidUsername;
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredUsername = newValue!;
                              },
                            ),
                          PasswordInput(
                            labelText: appLocalizationsOf(context).password,
                            textInputAction: TextInputAction.done,
                            onSaved: (newValue) {
                              enteredPassword = newValue!;
                            },
                          ),
                          gapH12,
                          if (isAuthenticating.value == true)
                            CircularProgressIndicator(
                              color: colorSchemeOf(context).primary,
                            ),
                          if (!isAuthenticating.value)
                            ElevatedButton(
                              onPressed: submit,
                              child: isLogin.value
                                  ? Text(appLocalizationsOf(context).signIn)
                                  : Text(appLocalizationsOf(context).signUp),
                            ),
                          if (!isAuthenticating.value)
                            TextButton(
                              onPressed: () {
                                isLogin.value = !isLogin.value;
                              },
                              child: isLogin.value
                                  ? Text(
                                      appLocalizationsOf(context)
                                          .createNewAccount,
                                    )
                                  : Text(
                                      appLocalizationsOf(context)
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
