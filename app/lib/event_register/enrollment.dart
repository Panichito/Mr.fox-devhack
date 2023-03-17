import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> confirmEnroll(int eid) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var myid = pref.getInt('id');
  var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/post-enroll');
  Map<String, String> header = {"Content-type": "application/json"};
  String jsondata='{"user":"$myid", "event":"$eid"}';
  var response = await http.post(url, headers: header, body: jsondata);
  print('-----result-----');
  print(response.body);
}

var enroll_id;
Future<void> cancelEnroll(int eid) async {
  await getEnrollId(eid);
  var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/delete-enroll/$enroll_id');
}

Future<void> getEnrollId(int eid) async {
}
