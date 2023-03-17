import 'package:flutter/material.dart';
// http method package
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomeRegisterPage extends StatefulWidget {
  const HomeRegisterPage({super.key});

  @override
  State<HomeRegisterPage> createState() => _HomeRegisterPageState();
}

class _HomeRegisterPageState extends State<HomeRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allEvent(),
    );
  }
}

Widget allEvent() {
  return ListView(
  );
}