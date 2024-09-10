import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culinary_snap/Lists/CustomAlert.dart';
import 'package:culinary_snap/Pages/HomePage.dart';
import 'package:culinary_snap/colors/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState() {
    super.initState();
    _loadUserData();
  }

  String _userName = '';
  String _userEmail = '';

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Extract user data
      setState(() {
        _userName = userSnapshot['name'];
        _userEmail = userSnapshot['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MyCustomAlertDialog alertDialog = MyCustomAlertDialog();
    return Scaffold(
      backgroundColor: Backgroundcolor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 320,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 117, 40, 52),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       // builder: (context) => Home(),
                            //       // builder: (context) => Dashboard(),
                            //       builder: (context) => BottomAppBar(),
                            //     ));
                          },
                        ),
                        const Center(
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // const Spacer(),
                        IconButton(
                          onPressed: () {
                            alertDialog.showCustomAlertdialog(
                              context: context,
                              title: 'Confirm',
                              subtitle: 'Do you want to log out and exit.',
                              onTapOkButt: () {},
                              button: true,
                              onTapCancelButt: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: const Divider(
                        color: Color.fromARGB(255, 82, 79, 79),
                        thickness: 1,
                        // indent: 26,
                        // endIndent: 26,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ProfileHeader(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            InfoCard(userName: _userName, userEmail: _userEmail),
            const SizedBox(height: 16),
            ActionCard(
              icon: Icons.edit,
              text: 'Edit Profile',
              color: Colors.redAccent,
            ),
            ActionCard(
              icon: Icons.message,
              text: 'Support',
              color: Colors.lightBlue,
            ),
            ActionCard(
              icon: Icons.check_circle,
              text: 'Terms & Conditions',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      CircleAvatar(
        radius: 48,
        backgroundImage: AssetImage(
            'assets/ProfileImage.jpg'), // Replace with the actual image path
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Icon(
          Icons.camera_alt_outlined, // Replace with the desired icon
          color: Colors.white,
          size: 28,
        ),
      ),
    ]);
  }
}

class InfoCard extends StatelessWidget {
  final String userName;
  final String userEmail;

  InfoCard({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          InfoTile(label: 'Name', value: userName),
          InfoTile(label: 'Email', value: userEmail),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(value),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  ActionCard({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(text),
          onTap: () {}, // Placeholder for action
        ),
      ),
    );
  }
}
