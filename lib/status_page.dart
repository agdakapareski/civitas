import 'dart:async';
import 'dart:convert';

import 'package:civitas_activity_app/api.dart';
import 'package:civitas_activity_app/custom_theme.dart';
import 'package:civitas_activity_app/model/activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'custom_text.dart';
import 'package:intl/intl.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Future<List<ActivityModel>>? activities;

  Future<List<ActivityModel>> getActivities(token) async {
    var uri = Uri.parse('$url/activities');
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
    initializeDateFormatting();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: MediaQuery.of(context).size.height * 0.17,
        title: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 18,
                  child: Icon(
                    CupertinoIcons.calendar,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomText(
                  DateFormat('EEEE, dd MMMM yyyy', 'id').format(
                    DateTime.parse(DateTime.now().toString()),
                  ),
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'search',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.search,
                    color: Colors.grey[900],
                  ),
                ],
              ),
            ),
          ],
        ),
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
            return ListView(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: const Center(
                    child: CustomText('tidak ada aktivitas'),
                  ),
                ),
              ],
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(
              bottom: 15,
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Container(
                  color: colorChanges(activities[i].activity),
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      activities[i].userPicture == null
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
                              backgroundImage: NetworkImage(
                                picUrl + activities[i].userPicture,
                              ),
                            ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  activities[i].userName,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  DateFormat('HH:mm').format(
                                    DateTime.parse(activities[i].createdAt),
                                  ),
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            CustomText(
                              activities[i].userJob,
                              fontSize: 10,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.search_circle,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  activities[i].activity,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.placemark_fill,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  activities[i].place,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
