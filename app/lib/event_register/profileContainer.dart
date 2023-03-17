import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({Key? key}) : super(key: key);

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  String username = "";
  String profilepic = "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.jpg";
  @override
  void initState() {
    super.initState();
    checkUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[300],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Welcome Back,',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown[600],
                    )),
                const SizedBox(height: 5),
                Container(
                  width: 150,
                  child: Text(
                    username,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 28, color: Colors.grey[800], fontFamily: 'Quicksand'),
                  ),
                )
              ],
            ),
            const SizedBox(width: 100),
            CircleAvatar(
              backgroundImage: NetworkImage(profilepic),
              radius: 50,
            ),
          ],
        ),
      ),
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
        username = "$usr_name";
        print(profile_url);
        if (profile_url != "no image") {
          profilepic = "$profile_url";
        }
      });
    }
  }
}

