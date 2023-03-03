import 'package:flutter/material.dart';
// http method package
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class UpdatePage extends StatefulWidget {
  final v1, v2, v3;
  const UpdatePage(this.v1, this.v2, this.v3);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var _v1, _v2, _v3;
  TextEditingController todo_title=TextEditingController();
  TextEditingController todo_detail=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _v1=widget.v1;  // id 
    _v2=widget.v2;  // title
    _v3=widget.v3;  // detail
    todo_title.text=_v2;
    todo_detail.text=_v3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล'),
        actions: [
          IconButton(onPressed: () {
            print("Delete ID: $_v1");
            deleteTodo();
            Navigator.pop(context, 'delete');  // ลบเสร็จแล้ว pop ออกมา
          }, icon: Icon(Icons.delete), color: Colors.grey[300])
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ช่องกรอก todolist
            TextField(
              controller: todo_title,
              decoration: InputDecoration(labelText: 'รายการที่ต้องทำ', border: OutlineInputBorder()),
            ),
            SizedBox(height: 30),
            TextField(
              minLines: 4,
              maxLines: 8,
              controller: todo_detail,
              decoration: InputDecoration(labelText: 'รายละเอียด', border: OutlineInputBorder()),
            ),
            SizedBox(height: 30),
            // ปุ่มเพิ่มข้อมูล
            Padding(
              padding: const EdgeInsets.all(80),

              child: ElevatedButton(
                onPressed: () {
                  print('----update $_v1----');
                  print('title: ${todo_title.text}');
                  print('detail: ${todo_detail.text}');
                  updateTodo();
                  final snackBar = SnackBar(content: const Text('อัพเดทรายการแล้ว'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }, 
                child: Text("แก้ไข"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(50, 20, 50, 20)),
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20)),
                ),),),
          ],
        ),
      ),
    );
  }

  Future updateTodo() async {
    //var url=Uri.https('b00a-2001-fb1-b1-4547-5bd-8033-34d0-2a30.ngrok.io', '/api/update-todolist/$_v1');
    var url=Uri.http('192.168.1.52:8000', '/api/update-todolist/$_v1');
    Map<String, String> header={"Content-type":"application/json"};
    String jsondata='{"title":"${todo_title.text}", "detail":"${todo_detail.text}"}';
    var response=await http.put(url, headers: header, body: jsondata);
    print('----result----');
    print(response.body);
  }

  Future deleteTodo() async {
    var url=Uri.http('192.168.1.52:8000', '/api/delete-todolist/$_v1');
    Map<String, String> header={"Content-type":"application/json"};
    var response=await http.delete(url, headers: header);
    print('----result----');
    print(response.body);
  }
}