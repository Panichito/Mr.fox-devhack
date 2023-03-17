import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<void> confirmEnroll(int eid) async {
  var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/post-enroll');
}

Future<void> cancelEnroll(int eid, String status) async {
  var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/delete-enroll/$eid');
}
