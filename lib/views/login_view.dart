import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text("Login")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: "Enter your Email: "),
                  ),
                  TextField(
                    controller: _pass,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: "Enter your Password: "),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final pass = _pass.text;
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: email, password: pass);
                      } on FirebaseAuthException catch (e) {
                        // print("Invalid Email or Password");
                        // print(e.code);
                        if (e.code == "user-not-found") {
                          print("Invalid Email");
                        } else if (e.code == "wrong-password"){
                          print("Invalid Password");
                        }
                      }
                      catch (e) {
                        print("Something Bad Happened");
                        print("The Exception Type is: ${e.runtimeType}", );
                      }

                    },
                    child: const Text("Login"),
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const LoginView(),
  ));
}

void test(int a, int b) {
  print(a + b);
}
