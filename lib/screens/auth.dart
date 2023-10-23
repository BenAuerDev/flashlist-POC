import 'dart:io';

import 'package:brainstorm_array/utils/context_retriever.dart';
import 'package:brainstorm_array/widgets/custom_inputs/avatar_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
          content: Text(error.message ?? 'An error occurred!'),
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
          });
        }
      } on FirebaseAuthException catch (error) {
        isAuthenticating.value = false;
        showSnackBar(error);
      }
    }

    return Scaffold(
      backgroundColor: retrieveColorScheme(context).primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Text(
                  'Logo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: retrieveColorScheme(context).primaryContainer,
                  ),
                ),
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
                            textCapitalization: TextCapitalization.none,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredEmail = newValue!;
                            },
                          ),
                          if (!isLogin.value)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid username';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredUsername = newValue!;
                              },
                            ),
                          TextFormField(
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length <= 6) {
                                return 'Please enter a valid password, at least 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              enteredPassword = newValue!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (isAuthenticating.value == true)
                            CircularProgressIndicator(
                              color: retrieveColorScheme(context).primary,
                            ),
                          if (!isAuthenticating.value)
                            ElevatedButton(
                              onPressed: submit,
                              child: isLogin.value
                                  ? const Text('Sign In')
                                  : const Text('Sign Up'),
                            ),
                          if (!isAuthenticating.value)
                            TextButton(
                              onPressed: () {
                                isLogin.value = !isLogin.value;
                              },
                              child: isLogin.value
                                  ? const Text('Create new account')
                                  : const Text('I already have an account'),
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
