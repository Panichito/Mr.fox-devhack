import 'package:flutter/material.dart';
import 'package:app/todo_pages/add.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:app/todo_pages/update.dart';

class Todolist extends StatefulWidget {

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List todolistitems=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ปุ่ม + 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Goto AddPage ->"); 
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPage())).then((value) {
            setState(() {
              getTodolist();
            });
          });
        },
        child: Icon(Icons.add),
      ),
      body: todolistCreate(),
    );
  }

  Widget todolistCreate() {
    return ListView.builder(
      itemCount: todolistitems.length,
      itemBuilder: (context, index) {
      return Card(
        child: ListTile(
          title: Text("${index+1} - ${todolistitems[index]['title']}"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context)=>UpdatePage(
                todolistitems[index]['id'], 
                todolistitems[index]['title'],
                todolistitems[index]['detail']))).then((value) {
                  setState(() {
                    print(value);
                    if(value=='delete') {  // ty to https://docs.flutter.dev/cookbook/design/snackbars
                      final snackBar = SnackBar(
                        content: const Text('ลบรายการเรียบร้อยแล้ว'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            print("Dafuq, I didn't implement it yet!");
                          },
                        ),
                      );
                      // Find the ScaffoldMessenger in the widget tree and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    getTodolist();
                  });
                });
          },
        ),
      );
    });
  }

  Future<void> getTodolist() async {
    List alltodo=[];
    var url=Uri.https('weatherreporto.pythonanywhere.com', '/api/all-todolist');
    var response=await http.get(url);
    //var result=json.decode(response.body);
    var result=utf8.decode(response.bodyBytes);
    print(result);
    setState(() {
      todolistitems=jsonDecode(result);
    });
  }
}