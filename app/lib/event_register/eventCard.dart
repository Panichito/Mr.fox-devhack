import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String event;
  const EventCard(this.event);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  // Widget eventCard(index, eventlist) {
  bool pressed = false;
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.event,
                style: const TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pressed = !pressed;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                backgroundColor: pressed
                    ? Colors.redAccent : Colors.blueAccent,
              ),
              child: pressed
                ? const Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 20
                ))
                : const Text(
                  'Enroll',
                  style: TextStyle(
                      fontSize: 20
                  ))
            ),
          ]
        ),
      ),
    );
  }
}
