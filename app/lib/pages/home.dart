import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:app/pages/notification.dart';
import 'package:timezone/data/latest.dart' as tz;

// patient constructor
class Todo{
  int todoId;
  int userId;
  String task;
  String detail;
  String dueDate;
  bool isDone;

  Todo(this.todoId, this.userId, this.task, this.detail, this.dueDate, this.isDone);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "",
      profilepic =
          "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.jpg";

  int? myid;
  bool? cstatus;

  // todos list
  List getAlert = [];
  List<Todo> allTodo = [];
  List<Todo> todoList = [
    Todo(1,1, 'cleaning', 'do it quick', '2023-02-23', false),
  ];
  var _role;
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUsername();
    checkAlertState();
    getMyAlerts();
  }

  /* create a schedule card for user to communicate with the database when taking medicine */
  Widget todoCard(Todo todo) {
    DateTime dt = DateTime.parse(todo.dueDate);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dt);
    // String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Card(
      color: todo.isDone ? Colors.green[100] : Colors.red[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.task,
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold),
                  ),
                  Text('${todo.detail}',
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.grey[700])),
                  const SizedBox(height: 20),
                  Text('Due date: $formattedDate',
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // set isTaken to false
                    setState(() {
                      if (todo.isDone == false) {
                        setAlertStatus(todo.todoId, "True");
                        // // create new history
                        // createHistory(todo.todoId);
                      } else {
                        setAlertStatus(todo.todoId, "False");
                        // delete existing history
                        // clearHistory(schedule.alertId);
                      }
                      todo.isDone = !todo.isDone;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    backgroundColor: Colors.grey[700],
                  ),
                  child: !todo.isDone
                      ? const Text(
                          'Done',
                          style: TextStyle(fontSize: 20),
                        )
                      : const Text(
                          'Not yet',
                          style: TextStyle(fontSize: 20),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                Column(
                  children: [
                    ...todoList
                        .map((todo) => todoCard(todo))
                        .toList(),
                    const SizedBox(height: 16,)
                  ],
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  /* check if username exists and query user information from database */
  Future<void> checkUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final checkvalue = pref.get('token') ?? 0;
    if (checkvalue != 0) {
      // get username
      setState(() {
        var usr_name = pref.getString('username');
        var profile_url = pref.getString('profilepic');
        _role = pref.getString('role');
        username = "$usr_name";
        print(profile_url);
        if (profile_url != "no image") {
          profilepic = "$profile_url";
        }
      });
    }
  }

  /* get user's userid */
  Future<void> getMyId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    myid = pref.getInt('id');
    if(_role == "CARETAKER") {
      print('go to check caretaking');
      getCaretakingStatus(myid!);
    }
  }

  /* get user's alerts from database
     if there's an alert of this user in the database, then do daily notification */
  Future<void> getMyAlerts() async {
    await getMyId();
    var url = Uri.https(
        'weatherreporto.pythonanywhere.com', '/api/user-alerts/$myid');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    print('RECEIVE ALL OF MY ALERT');
    setState(() {
      getAlert = jsonDecode(result);
      allTodo = [];
      for (int i = 0; i < getAlert.length; ++i) {
        allTodo.add(Todo(
            getAlert[i]['todoId'],
            getAlert[i]['userId'],
            getAlert[i]['task'],
            getAlert[i]['detail'],
            getAlert[i]['dueDate'],
            getAlert[i]['isDone']));
      }
      todoList =
          List.from(allTodo); // map all schedule into the display list
      tz.initializeTimeZones();
      notificationService.initNotification();
      if (allTodo.isNotEmpty) {
        notificationService.showNotification(
            'Daily reminder', "Don't forget to take your medicine today!");
      }
    });
  }

  /* set the medication status */
  Future<void> setAlertStatus(int aid, String status) async {
    var url = Uri.https(
        'weatherreporto.pythonanywhere.com', '/api/update-alert/$aid');
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata = '{"Alert_isTake":"$status"}';
    var response = await http.put(url, headers: header, body: jsondata);
    print('Change alert status');
    print(response.body);
  }

  /* create a history of medication */
  Future<void> createHistory(int aid) async {
    var url =
        Uri.https('weatherreporto.pythonanywhere.com', '/api/add-history');
    Map<String, String> header = {"Content-type": "application/json"};
    DateTime internetTime = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(internetTime);
    String formattedTime = DateFormat.Hms().format(internetTime);
    String v1 = '"alert":$aid';
    String v2 = '"History_takeDate":"$formattedDate"';
    String v3 = '"History_takeTime":"$formattedTime"';
    String jsondata = '{$v1, $v2, $v3}';
    print(jsondata);
    var response = await http.post(url, headers: header, body: jsondata);
    var uft8result = utf8.decode(response.bodyBytes);
    print(uft8result);
  }

  /* clear a history of medication */
  Future<void> clearHistory(int aid) async {
    var url = Uri.https(
        'weatherreporto.pythonanywhere.com', '/api/delete-history/$aid');
    Map<String, String> header = {"Content-type": "application/json"};
    var response = await http.delete(url, headers: header);
    print('CLEAR TAKEN HISTORY');
    print(response.body);
  }

  /* check the status of medication */
  Future<void> checkAlertState() async {
    var url =
        Uri.https('weatherreporto.pythonanywhere.com', '/api/latest-history');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    setState(() {
      Map<String, dynamic> date = jsonDecode(result);
      print('latest date is ' + date['History_takeDate']);
      DateTime internetTime = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(internetTime);
      if (date['History_takeDate'] != formattedDate) {
        print('RESET ALERT STATUS DAILY!');
        refreshAlertStatus("False");
      }
    });
  }

  /* refresh the status of medication */
  Future<void> refreshAlertStatus(String setTo) async {
    var url =
        Uri.https('weatherreporto.pythonanywhere.com', '/api/refresh-alerts');
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata = '{"Alert_isTake":"$setTo"}';
    var response = await http.put(url, headers: header, body: jsondata);
    var uft8result = utf8.decode(response.bodyBytes);
    print(uft8result);
    setState(() {
      getMyAlerts();
    });
  }

  /* Let's first check what the caretaking status is now. */
  Future<void> getCaretakingStatus(int myid) async {
    var url = Uri.https(
        'weatherreporto.pythonanywhere.com', '/api/get-care-status/$myid');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    setState(() {
      Map<String, dynamic> currentstatus = jsonDecode(result);
      cstatus = currentstatus['Caretaker_status'];
    });
  }

  /* Toggle caretaker's status. If which one is open, close and which one is closed, open. */
  Future<void> switchCaretakingStatus(String setTo) async {
    var url = Uri.https(
        'weatherreporto.pythonanywhere.com', '/api/switch-care-status/$myid');
    Map<String, String> header = {"Content-type": "application/json"};
    String v1 = '"member":$myid';
    String v2 = '"Caretaker_status":"$setTo"';
    String jsondata = '{$v1, $v2}';
    var response = await http.put(url, headers: header, body: jsondata);
    var uft8result = utf8.decode(response.bodyBytes);
    print(uft8result);
  }
}
