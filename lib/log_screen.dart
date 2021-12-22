import 'dart:convert';

import 'package:civitas_activity_app/api.dart';
import 'package:civitas_activity_app/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'custom_theme.dart';
import 'model/activity_model.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  Future<List<ActivityModel>>? activities;

  Future<List<ActivityModel>> getActivities(token) async {
    var uri = Uri.parse('$url/log/$userId');
    final response = await get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    var map = json.decode(response.body);
    var data = (map as Map<String, dynamic>)['data'];

    List<ActivityModel> activities = [];

    if (response.statusCode == 200) {
      for (var activity in data) {
        activities.add(ActivityModel.fromJson(activity));
      }
    }

    return activities;
  }

  refresh() {
    setState(() {
      activities = getActivities(token);
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'Riwayat Aktivitas',
              color: Colors.grey[900],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              '$userName',
              color: Colors.grey[900],
              fontSize: 13,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ActivityModel>>(
        future: activities,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Container(
              width: double.infinity,
              color: Colors.grey[100],
              child: const Center(
                child: CustomText('tidak ada riwayat'),
              ),
            );
          } else {
            return activityList(snapshot.data);
          }
        },
      ),
    );
  }

  activityList(activities) {
    return RefreshIndicator(
      onRefresh: () async {
        refresh();
        return Future.delayed(
          const Duration(seconds: 1),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: activities.length,
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              color: colorChanges(activities[i].activity),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 15,
            ),
            margin: const EdgeInsets.only(
              bottom: 15,
            ),
            child: Row(
              children: [
                activities[i].activity! == 'Di Kantor'
                    ? Center(
                        child: Image.asset(
                          'assets/office-building.png',
                          width: 60,
                        ),
                      )
                    : (activities[i].activity! == 'Visit Customer'
                        ? Center(
                            child: Image.asset(
                              'assets/customer.png',
                              width: 60,
                            ),
                          )
                        : (activities[i].activity! == "Di Workshop"
                            ? Center(
                                child: Image.asset(
                                  'assets/mechanics.png',
                                  width: 60,
                                ),
                              )
                            : (activities[i].activity! == 'Istirahat'
                                ? Center(
                                    child: Image.asset(
                                      'assets/coffee-break.png',
                                      width: 60,
                                    ),
                                  )
                                : (activities[i].activity! == 'Izin'
                                    ? Center(
                                        child: Image.asset(
                                          'assets/mail.png',
                                          width: 60,
                                        ),
                                      )
                                    : (activities[i].activity! ==
                                            'Dinas di Luar'
                                        ? Center(
                                            child: Image.asset(
                                              'assets/skyline.png',
                                              width: 60,
                                            ),
                                          )
                                        : Center(
                                            child: Image.asset(
                                              'assets/other.png',
                                              width: 60,
                                            ),
                                          )))))),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.search_circle,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            activities[i].activity,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.placemark_fill,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            activities[i].place,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.clock,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            DateFormat('HH:mm').format(
                              DateTime.parse(activities[i].createdAt),
                            ),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      DateFormat('dd / MM / yyyy').format(
                        DateTime.parse(activities[i].createdAt),
                      ),
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    CustomText(
                      activities[i].isActive == '1' ? 'Aktif' : 'Tidak Aktif',
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
