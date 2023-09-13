import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool Loginpage = false;

  Startauthentication() {
    final validity = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (validity!) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (Loginpage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
          'password': password,
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        dismissDirection: DismissDirection.horizontal,
        elevation: 2,
      ));
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(children: [
        Container(
          padding: EdgeInsets.all(20),
          height: 200,
          child: Image.asset(
            "assests/todo.png",
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!Loginpage)
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Incorrect username';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _username = newValue!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          borderSide: new BorderSide(),
                        ),
                        labelText: "Enter Username",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Incorrect email';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _email = newValue!;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Incorrect password';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _password = newValue!;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.roboto()),
                ),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Startauthentication();
                      },
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                      ),
                      child: Loginpage
                          ? Text('Login',
                              style: GoogleFonts.roboto(fontSize: 16))
                          : Text('SignUp',
                              style: GoogleFonts.roboto(fontSize: 16)),
                    )),
                SizedBox(height: 10),
                Container(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          Loginpage = !Loginpage;
                        });
                      },
                      child: Loginpage
                          ? Text(
                              'Not a member?',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.white),
                            )
                          : Text('Already a Member?',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.white))),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
