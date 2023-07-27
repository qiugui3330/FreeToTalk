import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../services/assets_manager.dart';
import '../auth/login_page.dart';
import '../database/user_model.dart';

class CustomDrawer extends StatelessWidget {
  final User user;

  const CustomDrawer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user.username,
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              user.email, // Change this line with your variable
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(AssetsManager.openaiLogo), // Change this line with your variable
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 243, 246, 1),
            ),
          ),
          ListTile(
            title: Text('Option 1'),
            onTap: () {
              // Put your onTap function here
            },
          ),
          ListTile(
            title: Text('Option 2'),
            onTap: () {
              // Put your onTap function here
            },
          ),
          ListTile(
            title: Text('To Be Determined'),
            onTap: () {
              // Put your onTap function here
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          user.isLoggedIn = false;
                          await DatabaseService.instance.updateUser(user.toMap());
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

