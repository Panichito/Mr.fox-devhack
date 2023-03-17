import 'package:flutter/material.dart';
// http method package
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'eventCard.dart';

class HomeRegisterPage extends StatefulWidget {
  const HomeRegisterPage({super.key});

  @override
  State<HomeRegisterPage> createState() => _HomeRegisterPageState();
}

class _HomeRegisterPageState extends State<HomeRegisterPage> {
  List eventlist=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allEvent(),
    );
  }

  Widget allEvent() {
    return ListView.builder(
      itemCount: eventlist.length,
      itemBuilder: (context, index) {
        return EventCard(eventlist[index]['name'], eventlist[index]['start'], eventlist[index]['end']);
      }
    );
  }

  Future<void> getEvent() async {
    List alltodo=[];
    var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/all-event');
    var response=await http.get(url);
    //var result=json.decode(response.body);
    var result=utf8.decode(response.bodyBytes);
    print(result);
    setState(() {
      eventlist=jsonDecode(result);
    });
  }
}