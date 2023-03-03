import 'package:flutter/material.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/updateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UIPage extends StatefulWidget {
  const UIPage({super.key});

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  var _role;
  int _selectedIndex = 0;

  void _onItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String fullname = '';
  @override
  void initState() {
    // TODO: implement initState
    checkFullname();
  }

  @override
  Widget build(BuildContext context) {
    var pagename = [];
    List<Widget> widgetBottom = [];
    /* Each role has a different scope of use. */
    pagename = ['Home Page'];
    widgetBottom = [HomePage()];

    /* This section of code handles Tab in each pages. We will configure the navbar to be the same on every page to make it easier to use and edit. */
    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        drawer: buildDrawer(),
        appBar: AppBar(
          title: Text(pagename[_selectedIndex]),
          backgroundColor: Colors.indigo[400],
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
            decoration: BoxDecoration(color: Colors.indigo[400])),
        ListTile(
          leading: Icon(Icons.menu_book),
          title: Text('How to use'),
          onTap: () {
            homeURL();
            Navigator.pop(context);
          },
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
          leading: Icon(Icons.support_agent),
          title: Text('Contact'),
          onTap: () {
            contactURL();
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
        _role = pref.getString('role');
        fullname = 'Hello, $fname $lname' + '\n' + '($gender $_role)';
      });
    }
  }

  /* When users want to edit personal information, we will fetch the current information and put it in a text field to prepare for editing. */
  void push_to_edit_page() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var id = pref.getInt('id');
      var fname = pref.getString('first_name');
      var lname = pref.getString('last_name');
      var bdate = pref.getString('birthdate');
      var gen = pref.getString('gender');
      var pfp = pref.getString('profilepic');
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UpdateProfilePage(id, fname, lname, bdate, gen, pfp)))
          .then((value) {
        setState(() {
          if (value == 'delete') {}
          checkFullname();
        });
      });
    });
  }

  /* Open home page link */
  Future<void> homeURL() async {
    final Uri url = Uri.parse('https://weatherreporto.pythonanywhere.com/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Cannot launch $url";
    }
  }

  /* Open about page link */
  Future<void> aboutURL() async {
    final Uri url = Uri.parse('https://weatherreporto.pythonanywhere.com/about/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Cannot launch $url";
    }
  }

  /* Open contact page link */
  Future<void> contactURL() async {
    final Uri url = Uri.parse('https://weatherreporto.pythonanywhere.com/contact/');
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
