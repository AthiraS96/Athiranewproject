import 'package:culinary_snap/Login/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
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
                    'Register',
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
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person))),
                  SizedBox(
                    height: screensize.height * 0.02,
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail))),
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
                          labelText: 'Repeat Password',
                          prefixIcon: Icon(Icons.lock))),
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
                          onPressed: () {},
                          child: Text(
                            'SIGN UP',
                            style: GoogleFonts.aDLaMDisplay(
                                textStyle: TextStyle(color: Colors.black)),
                          ))),
                  SizedBox(
                    height: screensize.height * 0.05,
                  ),
                  Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 10),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        'Login',
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
