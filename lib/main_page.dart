import 'dart:convert';

import 'package:civitas_activity_app/api.dart';
import 'package:civitas_activity_app/custom_text.dart';
import 'package:civitas_activity_app/input_activity_page.dart';
import 'package:civitas_activity_app/model/activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'custom_theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isEmpty = false;
  Future<List<ActivityModel>>? _activity;

  Future<List<ActivityModel>> getActiveActivity(String token) async {
    var uri = Uri.parse('$url/one-activity/$userId');
    var response = await get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var map = json.decode(response.body);
    var data = map['data'];

    List<ActivityModel> _activities = [];

    if (response.statusCode == 200) {
      for (var activity in data) {
        _activities.add(ActivityModel.fromJson(activity));
      }
    }

    return _activities;
  }

  refreshList() {
    setState(() {
      _activity = getActiveActivity(token!);
    });
  }

  goToInputPage(String activity) {
    if (isEmpty) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => InputActivity(
            activity: activity,
          ),
        ),
      );
    } else {
      show(message: 'Selesaikan aktivitas terlebih dahulu!');
    }
  }

  show({required String message}) {
    return Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.grey[900],
      gravity: ToastGravity.SNACKBAR,
    );
  }

  done(String token, int id) async {
    var uri = Uri.parse('$url/done-activity/$id');
    var response = await put(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    var data = json.decode(response.body);
    var message = data['message'];

    show(message: message);

    refreshList();
  }

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            refreshList();
            return Future.delayed(
              const Duration(seconds: 1),
            );
          },
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 13,
              horizontal: 18,
            ),
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  picture == null
                      ? CircleAvatar(
                          backgroundColor: Colour.red,
                          radius: 30,
                          child: const Icon(
                            CupertinoIcons.person,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colour.red,
                          radius: 30,
                          backgroundImage: NetworkImage(picture!),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        userName ?? 'Nama User',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      CustomText(
                        userJob ?? 'Jabatan User',
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<ActivityModel>>(
                future: _activity,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: Center(
                        child: CustomText('Memuat . . .'),
                      ),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    isEmpty = true;
                    return Container(
                      height: 120,
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Colors.grey,
                        ),
                      ),
                      child: const Center(
                        child: CustomText(
                          'Tidak ada aktivitas aktif',
                          color: Colors.grey,
                        ),
                      ),
                    );
                  } else {
                    isEmpty = false;
                    return Container(
                      height: 120,
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorChanges(snapshot.data![0].activity!),
                      ),
                      child: Row(
                        children: [
                          snapshot.data![0].activity! == 'Di Kantor'
                              ? Center(
                                  child: Image.asset(
                                    'assets/office-building.png',
                                    width: 67,
                                  ),
                                )
                              : (snapshot.data![0].activity! == 'Visit Customer'
                                  ? Center(
                                      child: Image.asset(
                                        'assets/customer.png',
                                        width: 67,
                                      ),
                                    )
                                  : (snapshot.data![0].activity! ==
                                          "Di Workshop"
                                      ? Center(
                                          child: Image.asset(
                                            'assets/mechanics.png',
                                            width: 67,
                                          ),
                                        )
                                      : (snapshot.data![0].activity! ==
                                              'Istirahat'
                                          ? Center(
                                              child: Image.asset(
                                                'assets/coffee-break.png',
                                                width: 67,
                                              ),
                                            )
                                          : (snapshot.data![0].activity! ==
                                                  'Izin'
                                              ? Center(
                                                  child: Image.asset(
                                                    'assets/mail.png',
                                                    width: 67,
                                                  ),
                                                )
                                              : (snapshot.data![0].activity! ==
                                                      'Dinas di Luar'
                                                  ? Center(
                                                      child: Image.asset(
                                                        'assets/skyline.png',
                                                        width: 67,
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Image.asset(
                                                        'assets/other.png',
                                                        width: 67,
                                                      ),
                                                    )))))),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  snapshot.data![0].activity!,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  snapshot.data![0].place!,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.clock,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    CustomText(
                                      DateFormat('HH:mm').format(
                                            DateTime.parse(
                                                snapshot.data![0].createdAt!),
                                          ) +
                                          ' WIB',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: done(token!, snapshot.data![0].id!),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  CustomText(
                                    'Selesai',
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomText(
                'List Pilihan Aktivitas',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActivityButton(
                    child: Center(
                      child: Image.asset(
                        'assets/office-building.png',
                        width: 50,
                      ),
                    ),
                    color: Colour.green,
                    onTap: goToInputPage('Di kantor'),
                  ),
                  ActivityButton(
                    child: Center(
                      child: Image.asset(
                        'assets/customer.png',
                        width: 50,
                      ),
                    ),
                    color: Colour.blue,
                    onTap: goToInputPage('Visit Customer'),
                  ),
                  ActivityButton(
                    child: Center(
                      child: Image.asset(
                        'assets/mechanics.png',
                        width: 50,
                      ),
                    ),
                    color: Colour.purple,
                    onTap: goToInputPage('Di Workshop'),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 108,
                    child: const CustomText(
                      'Di Kantor',
                      fontSize: 11,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 108,
                    child: const CustomText(
                      'Visit Customer',
                      textAlign: TextAlign.center,
                      fontSize: 11,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 108,
                    child: const CustomText(
                      'Di Workshop',
                      textAlign: TextAlign.center,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActivityButton(
                    child: Center(
                      child: Image.asset(
                        'assets/coffee-break.png',
                        width: 50,
                      ),
                    ),
                    color: Colour.yellow,
                    onTap: goToInputPage('Istirahat'),
                  ),
                  ActivityButton(
                    child: Center(
                      child: Image.asset(
                        'assets/mail.png',
                        width: 50,
                      ),
                    ),
                    color: Colour.red,
                    onTap: goToInputPage('Izin'),
                  ),
                  ActivityButton(
                    child: Center(
                      child: Image.asset(
                        'assets/skyline.png',
                        width: 50,
                      ),
                    ),
                    color: Colour.black,
                    onTap: goToInputPage('Dinas di Luar'),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 108,
                    child: const CustomText(
                      'Istirahat',
                      fontSize: 11,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 108,
                    child: const CustomText(
                      'Izin',
                      textAlign: TextAlign.center,
                      fontSize: 11,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 108,
                    child: const CustomText(
                      'Dinas di Luar',
                      textAlign: TextAlign.center,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActivityButton(
                    child: Center(
                      child: Image.asset(
                        'assets/other.png',
                        width: 50,
                      ),
                    ),
                    color: Colors.green[900],
                    onTap: goToInputPage('Lain - Lain'),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 108,
                    child: const CustomText(
                      'Lain - Lain',
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
