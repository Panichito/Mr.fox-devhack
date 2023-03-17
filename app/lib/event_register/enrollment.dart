import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

var userid;

Future<void> getUserId() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  userid = pref.getInt('id');
}

Future<void> confirmEnroll(int eid) async {
  await getUserId();
  var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/post-enroll');
  Map<String, String> header = {"Content-type": "application/json"};
  String jsondata='{"user":"$userid", "event":"$eid"}';
  var response = await http.post(url, headers: header, body: jsondata);
  print('-----result-----');
  print(response.body);
}

Future<void> cancelEnroll(int eid) async {
  await getUserId();
  var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/delete-enroll/$userid/$eid');
  Map<String, String> header={"Content-type":"application/json"};
  var response=await http.delete(url, headers: header);
  print('----result----');
  print(response.body);
}