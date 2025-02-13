import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final v1, v2, v3, v4;
  DetailPage(this.v1, this.v2, this.v3, this.v4);  // this เหมือน self

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var _v1, _v2, _v3, _v4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _v1=widget.v1;
    _v2=widget.v2;
    _v3=widget.v3;
    _v4=widget.v4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_v1), backgroundColor: Colors.indigo[400]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(_v2, style: TextStyle(fontSize: 20, color: Colors.grey[700])),
            Image.network(_v3),
            Text(_v4),
          ],
        ),
      ),
    );
  }
}