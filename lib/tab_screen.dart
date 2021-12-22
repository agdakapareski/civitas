import 'package:civitas_activity_app/log_screen.dart';
import 'package:civitas_activity_app/main_page.dart';
import 'package:civitas_activity_app/profile_page.dart';
import 'package:civitas_activity_app/status_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  // angka untuk menentukan tab mana yang sedang dibuka
  // HelpPage = 1
  // HomePage = 2
  // AboutPage = 3
  int currentTab = 1;

  // Class tampungan halaman untuk keperluan ganti tab
  final PageStorageBucket bucket = PageStorageBucket();

  // Tampilan layar yang sedang dibuka
  // (setiap aplikasi mulai selalu start di HomePage)
  Widget currentScreen = const MainPage();

  // custom padding untuk tiap tab pada tab bar
  EdgeInsets customPadding = const EdgeInsets.only(
    top: 5,
    bottom: 5,
    right: 20,
    left: 17,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentScreen = const MainPage();
                    currentTab = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.home,
                      color: currentTab == 1 ? Colors.grey[900] : Colors.grey,
                    ),
                    CustomText(
                      'Home',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: currentTab == 1 ? Colors.grey[900] : Colors.grey,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentScreen = const LogScreen();
                    currentTab = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.clock,
                      color: currentTab == 2 ? Colors.grey[900] : Colors.grey,
                    ),
                    CustomText(
                      'Riwayat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: currentTab == 2 ? Colors.grey[900] : Colors.grey,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentScreen = const StatusPage();
                    currentTab = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.list_bullet,
                      color: currentTab == 3 ? Colors.grey[900] : Colors.grey,
                    ),
                    CustomText(
                      'Status',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: currentTab == 3 ? Colors.grey[900] : Colors.grey,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentScreen = const ProfilePage();
                    currentTab = 4;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.person,
                      color: currentTab == 4 ? Colors.grey[900] : Colors.grey,
                    ),
                    CustomText(
                      'Akun',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: currentTab == 4 ? Colors.grey[900] : Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // pembungkus halaman - halaman utama.
      // currentScreen merupakan halaman yang sedang dimuat.
      body: SafeArea(
        child: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
      ),
    );
  }
}
