import 'package:culinary_snap/Home/HomePage.dart';
import 'package:culinary_snap/Login/Registerpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/loginpage.png'),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.acme(
                      textStyle: TextStyle(fontSize: 30),
                    ),
                    // style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screensize.height * 0.04,
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person))),
                  SizedBox(
                    height: screensize.height * 0.02,
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock))),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: screensize.height * 0.01,
                  ),
                  Container(
                      height: screensize.height * 0.05,
                      width: screensize.width * 0.40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.black,
                      ),
                      // color: Colors.white),
                      // gradient: LinearGradient(colors: [
                      //   const Color.fromARGB(255, 169, 205, 233),
                      //   const Color.fromARGB(255, 214, 198, 203)
                      // ])),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => home()));
                          },
                          child: Text(
                            'LOGIN',
                            style: GoogleFonts.aDLaMDisplay(
                                textStyle: TextStyle(color: Colors.black)),
                          ))),
                  SizedBox(
                    height: 30,
                  ),
                  Text('Or Signup using'),
                  SizedBox(
                    height: screensize.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/facebook_logo.png',
                        scale: 70,
                      ),
                      SizedBox(
                        width: screensize.width * 0.02,
                      ),
                      ImageIcon(AssetImage('assets/twitter_logo.png')),
                      SizedBox(
                        width: screensize.width * 0.02,
                      ),
                      ImageIcon(AssetImage('assets/google_logo.png'))
                    ],
                  ),
                  SizedBox(
                    height: screensize.height * 0.05,
                  ),
                  Text(
                    'New here?',
                    style: TextStyle(fontSize: 10),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => register()));
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
