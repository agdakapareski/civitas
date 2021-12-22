import 'dart:convert';

import 'package:civitas_activity_app/api.dart';
import 'package:civitas_activity_app/custom_text.dart';
import 'package:civitas_activity_app/tab_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isVisible = false;

  login(String _username, String password) async {
    var uri = Uri.parse('$url/login');
    var response = await post(uri, body: {
      'username': _username,
      'password': password,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      show(message: jsonResponse['message']);
      setState(() {
        token = jsonResponse['token'];
        userId = jsonResponse['user']['id'];
        userName = jsonResponse['user']['name'];
        username = jsonResponse['user']['username'];
        userJob = jsonResponse['user']['job'];
        userEmail = jsonResponse['user']['email'];
        nik = jsonResponse['user']['nik'];
        if (jsonResponse['user']['picture'] != null) {
          picture = picUrl + jsonResponse['user']['picture'];
        }
      });
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const TabScreen(),
        ),
      );
    } else if (response.statusCode == 401) {
      var jsonResponse = json.decode(response.body);

      show(message: jsonResponse['message']);
    } else {
      var jsonResponse = json.decode(response.body);
      if (_username == '' && password == '') {
        show(message: jsonResponse['message']['username'][0]);
        show(message: jsonResponse['message']['password'][0]);
      } else if (_username == '') {
        show(message: jsonResponse['message']['username'][0]);
      } else {
        show(message: jsonResponse['message']['password'][0]);
      }
    }
  }

  show({required String message}) {
    return Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.grey[900],
      gravity: ToastGravity.SNACKBAR,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CustomText(
                    'Civitas',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomText('username'),
                TextFormField(
                  controller: usernameController,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomText('password'),
                TextFormField(
                  obscureText: isVisible ? false : true,
                  controller: passwordController,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: isVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onTap: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[900],
                    ),
                    child: const Center(
                      child: CustomText(
                        'Login',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    login(usernameController.text, passwordController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
