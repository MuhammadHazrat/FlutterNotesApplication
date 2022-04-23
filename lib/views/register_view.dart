import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter_app/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("First-Flutter-App")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Enter your Email: "
                    ),
                  ),
                  TextField(
                    controller: _pass,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: "Enter your Password: "
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final pass = _pass.text;
                      try {
                        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email,
                            password: pass
                        );

                      } on FirebaseAuthException catch (e) {
                        if (e.code == "weak-password") {
                          print("You have entered Weak Passsword");
                        } else if (e.code == "email-already-in-use") {
                          print("The User Already Exists");
                        } else if (e.code == "invalid-email") {
                          print("You have entered invalid email");
                        }
                        print(e.code);

                      } catch (e) {
                        print("You cannot login..... Password and Email was correct");
                      }

                    },
                    child: const Text("Register"),
                  ),
                ],
              );
            default:
              return const Text("Loading...");
          }

        },
      ),
    );
  }
}