import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String event;
  final String startDate;
  final String endDate;
  const EventCard(
    this.event,
    this.startDate,
    this.endDate
  );

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Card(
        color: Colors.amberAccent,
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
                    pressed = !pressed;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  backgroundColor: pressed
                    ? Colors.redAccent : Colors.greenAccent,
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
}
