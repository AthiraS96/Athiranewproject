import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culinary_snap/Login/loginPage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool showSpinner = false;
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background_image3.jpg'),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Text(
                    'Register',
                    style: GoogleFonts.acme(
                      color: Colors.white,
                      textStyle: const TextStyle(fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: _nameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white.withOpacity(.5),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 198, 196, 195)
                            .withOpacity(0.2),
                        // icon: const Icon(Icons.mail),
                        // label: const Text('Email'),
                        hintText: 'Name',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Colors.transparent))),
                  ),
                  SizedBox(
                    height: screensize.height * 0.02,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Email';
                      }
                      if (!RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(value!)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white.withOpacity(.5),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 198, 196, 195)
                            .withOpacity(0.2),
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Colors.transparent))),
                  ),
                  SizedBox(
                    height: screensize.height * 0.02,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: _passwordController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white.withOpacity(.6),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          child: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white.withOpacity(.2),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 198, 196, 195)
                            .withOpacity(0.2),
                        // icon: const Icon(Icons.mail),
                        // label: const Text('Email'),
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Colors.transparent))),
                    obscureText: _isObscured,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: screensize.height * 0.02,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: _repeatPasswordController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white.withOpacity(.5),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          child: Icon(
                            _isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white.withOpacity(.2),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 198, 196, 195)
                            .withOpacity(0.2),
                        // icon: const Icon(Icons.mail),
                        // label: const Text('Email'),
                        hintText: 'Repeat Password',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Colors.transparent))),
                    obscureText: _isObscured,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.black),
                    onPressed: _isLoading ? null : _registerUser,
                    child: Text(_isLoading ? 'Registering...' : 'Register',
                        style: GoogleFonts.aDLaMDisplay(
                            textStyle: const TextStyle(color: Colors.white))),
                  ),
                  SizedBox(
                    height: screensize.height * 0.14,
                  ),
                  const Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.black),
                      onPressed: () {
                        // setState(() {
                        //   showSpinner = true;
                        // });
                        // //Create new Account
                        // try {
                        //   await _auth
                        //       .createUserWithEmailAndPassword(
                        //           email: email, password: password)
                        //       .then((value) {
                        //     setState(() {
                        //       showSpinner = false;
                        //     });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                        // print('Successfully Created');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      )
                      //   } catch (e) {
                      //     print(e);
                      //   }
                      // },

                      )
                ]),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          //  name: _nameController.text
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'name': _nameController.text.trim(),
          // 'name': _nameController
        });
        print("Registration successful!");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      } on FirebaseAuthException catch (e) {
        print(e.message ?? "An error occurred");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }
}
