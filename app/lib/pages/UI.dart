import 'package:flutter/material.dart';
import 'package:app/pages/login.dart';
import 'package:app/todo_pages/show.dart';
import 'package:app/event_register/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UIPage extends StatefulWidget {
  const UIPage({super.key});

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  int _selectedIndex = 0;

  void _onItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String fullname = '';
  @override
  void initState() {
    checkFullname();
  }

  @override
  Widget build(BuildContext context) {
    var pagename = [];
    List<Widget> widgetBottom = [];
    /* Each role has a different scope of use. */
    pagename = ["ระบบลงทะเบียน โดย WHES"];  // we have exams on sunday
    widgetBottom = [HomeRegisterPage()];

    /* This section of code handles Tab in each pages. We will configure the navbar to be the same on every page to make it easier to use and edit. */
    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        drawer: buildDrawer(),
        appBar: AppBar(
          title: Text(pagename[_selectedIndex]),
          actions: [
            IconButton(
                onPressed: () {
                  print("Refresh");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UIPage()));
                },
                icon: Icon(Icons.refresh),
                color: Colors.white)
          ],
        ),
        body: TabBarView(children: [
          Center(child: widgetBottom.elementAt(_selectedIndex)),
        ]),
      ),
    );
  }

  /* build a side drawer */
  Widget buildDrawer() {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(fullname),
            accountEmail: null,
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('About'),
          onTap: () {
            aboutURL();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.lock_open),
          title: Text('Logout'),
          onTap: () {
            logout(context);
          },
        ),
      ],
    ));
  }


  /* Requesting the current username through the API to display the greeting message. */
  Future<void> checkFullname() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final checkvalue = pref.get('token') ?? 0; // เช็คจาก token ดีกว่า เพราะตอน logout ลบออกแค่ token
    if (checkvalue != 0) {
      // get username
      setState(() {
        var fname = pref.getString('first_name');
        var lname = pref.getString('last_name');
        var gender = pref.getString('gender');
        fullname = 'Hello, $fname $lname';
      });
    }
  }

  /* Open about page link */
  Future<void> aboutURL() async {
    final Uri url = Uri.parse('https://github.com/Panichito/Mr.fox-devhack');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Cannot launch $url";
    }
  }

  /* Log out of the system and clear all saved data. */
  logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    //prefs.remove('token');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
