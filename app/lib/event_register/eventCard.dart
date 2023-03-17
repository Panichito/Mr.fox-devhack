import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'enrollment.dart';

class EventCard extends StatefulWidget {
  final int id;
  final String event;
  final String startDate;
  final String endDate;
  const EventCard(
    this.id,
    this.event,
    this.startDate,
    this.endDate
  );

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  int? myid;
  bool pressed=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Card(
        color: Colors.amber[200],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event,
                      style: const TextStyle(
                        fontSize: 26,
                          fontFamily: 'Quicksand'
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Row(
                      children: [
                        Text(
                          'From ${widget.startDate} to ${widget.endDate}',
                          style: const TextStyle(
                              fontSize: 14.0,
                              // color: Colors.grey[700],
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                )
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if(pressed==false) {
                      confirmEnroll(widget.id);
                    }
                    else {
                      cancelEnroll(widget.id);
                    }
                    pressed = !pressed;  // set ไปเลยเพื่อความรวดเร็ว จะได้ไม่ต้อง reload
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  backgroundColor: pressed ? Colors.redAccent : Colors.greenAccent,
                ),
                child: pressed
                  ? const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ))
                  : const Text(
                    'Enroll',
                    style: TextStyle(
                      fontSize: 20,
                    ))
              ),
            ]
          ),
        ),
      ),
    );
  }

  Future<void> getMyId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    myid = pref.getInt('id');
  }

  Future<void> getMyState() async {
    await getMyId();
    var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/ask-enroll/$myid/${widget.id}');
    var response=await http.get(url);
    var result=utf8.decode(response.bodyBytes);
    setState(() {
        pressed=jsonDecode(result) > 0 ? true : false;
    });
  }
}
