import 'package:civitas_activity_app/api.dart';
import 'package:civitas_activity_app/custom_theme.dart';
import 'package:civitas_activity_app/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              picture == null
                  ? CircleAvatar(
                      backgroundColor: Colour.red,
                      radius: 40,
                      child: const Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(picture!),
                    ),
              const SizedBox(
                height: 10,
              ),
              CustomText(
                userName!,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                userJob!,
                fontSize: 13,
              ),
              CustomText(
                company.toUpperCase(),
                fontSize: 13,
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colour.black,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  child: const Center(
                    child: CustomText(
                      'Log Out',
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
