import 'dart:convert';

import 'package:civitas_activity_app/api.dart';
import 'package:civitas_activity_app/custom_text.dart';
import 'package:civitas_activity_app/custom_theme.dart';
import 'package:civitas_activity_app/tab_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// import 'model/activity_model.dart';

class InputActivity extends StatefulWidget {
  const InputActivity({Key? key, this.activity}) : super(key: key);

  final String? activity;

  @override
  _InputActivityState createState() => _InputActivityState();
}

class _InputActivityState extends State<InputActivity> {
  // Future<List<ActivityModel>>? _activity;
  TextEditingController placeController = TextEditingController();

  show({required String message}) {
    return Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.grey[900],
      gravity: ToastGravity.SNACKBAR,
    );
  }

  createActivity({
    String? userIds,
    String? activity,
    String? place,
    String? isActive,
    String? token,
  }) async {
    var uri = Uri.parse('$url/activity');
    final response = await post(uri, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      "user_id": userIds,
      "activity": activity,
      "place": place,
      "is_active": isActive,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const TabScreen()),
          (Route<dynamic> route) => false);
      show(message: data['message']);
    } else {
      show(message: data['message']['place'][0]);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: colorChanges(widget.activity!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: widget.activity! == 'Di Kantor'
                            ? Center(
                                child: Image.asset(
                                  'assets/office-building.png',
                                  width: 67,
                                ),
                              )
                            : (widget.activity! == 'Visit Customer'
                                ? Center(
                                    child: Image.asset(
                                      'assets/customer.png',
                                      width: 67,
                                    ),
                                  )
                                : (widget.activity! == "Di Workshop"
                                    ? Center(
                                        child: Image.asset(
                                          'assets/mechanics.png',
                                          width: 67,
                                        ),
                                      )
                                    : (widget.activity! == 'Istirahat'
                                        ? Center(
                                            child: Image.asset(
                                              'assets/coffee-break.png',
                                              width: 67,
                                            ),
                                          )
                                        : (widget.activity! == 'Izin'
                                            ? Center(
                                                child: Image.asset(
                                                  'assets/mail.png',
                                                  width: 67,
                                                ),
                                              )
                                            : (widget.activity! ==
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
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          widget.activity!,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.calendar,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            CustomText(
                              DateFormat('EEEE, dd MMMM yyyy', 'id').format(
                                DateTime.parse(DateTime.now().toString()),
                              ),
                              color: Colors.black,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.clock,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            StreamBuilder(
                              stream:
                                  Stream.periodic(const Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                return Center(
                                  child: CustomText(
                                    DateFormat('hh:mm').format(
                                      DateTime.now(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText('lokasi'),
                    TextFormField(
                      controller: placeController,
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
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorChanges(widget.activity!),
                    ),
                    child: const Center(
                      child: CustomText(
                        'Update',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    createActivity(
                      token: token,
                      userIds: userId.toString(),
                      activity: widget.activity,
                      place: placeController.text,
                      isActive: '1',
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey,
                    ),
                    child: const Center(
                      child: CustomText(
                        'Batal',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
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
