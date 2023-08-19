import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../constants/theme_constants.dart';
import '../database/models/conversation_model.dart';
import '../database/database_service.dart';
import '../providers/messages_provider.dart';
import '../providers/conversation_provider.dart';
import '../screens/wordbook_screen.dart';
import '../services/assets_manager.dart';
import 'package:chatgpt_course/screens/auth/login_screen.dart';
import '../database/models/user_model.dart';
import 'CustomTextField.dart';

   
class CustomDrawer extends StatelessWidget {
  final User user;

  const CustomDrawer({Key? key, required this.user}) : super(key: key);
   
  Future<void> createConversation(BuildContext context, int type, List<String>? parameters) async {
    Provider.of<MessageProvider>(context, listen: false).clearChat();
    var conversation = Conversation(
      userId: await DatabaseService.instance.getCurrentUserId(),
      type: type,
      date: DateTime.now().toString(),
      parameters: parameters,
    );

   
    int id = await DatabaseService.instance.insertConversation(conversation);

   
    var conversationProvider = Provider.of<ConversationProvider>(context, listen: false);
    conversationProvider.setCurrentConversation(conversation,id);
  }

   
  Future<Map<String, String>?> showRoleplayDialogueForm(BuildContext context) {
    TextEditingController userRoleController = TextEditingController();
    TextEditingController aiRoleController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController otherInfoController = TextEditingController();
   
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Create a New Roleplay Dialogue',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: FormBuilder(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    CustomTextField(
                      name: 'userRole',
                      labelText: 'User Role',
                      hintText: 'Please enter user role',
                      controller: userRoleController,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      name: 'aiRole',
                      labelText: 'AI Role',
                      hintText: 'Please enter AI role',
                      controller: aiRoleController,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      name: 'location',
                      labelText: 'Location of Dialogue',
                      hintText: 'Please enter location of dialogue',
                      controller: locationController,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      name: 'time',
                      labelText: 'Time of Dialogue',
                      hintText: 'Please enter time of dialogue',
                      controller: timeController,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      name: 'otherInfo',
                      labelText: 'Other Information',
                      hintText: 'Please enter other information',
                      controller: otherInfoController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit', style: TextStyle(color: Colors.green)),
              onPressed: () {
                if (userRoleController.text.isEmpty &&
                    aiRoleController.text.isEmpty &&
                    locationController.text.isEmpty &&
                    timeController.text.isEmpty &&
                    otherInfoController.text.isEmpty) {

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill in at least one field'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  Navigator.of(context).pop({
                    'userRole': userRoleController.text.isEmpty ? 'Not specified' : userRoleController.text,
                    'aiRole': aiRoleController.text.isEmpty ? 'Not specified' : aiRoleController.text,
                    'location': locationController.text.isEmpty ? 'Not specified' : locationController.text,
                    'time': timeController.text.isEmpty ? 'Not specified' : timeController.text,
                    'otherInfo': otherInfoController.text.isEmpty ? 'Not specified' : otherInfoController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

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
              user.email,   
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(AssetsManager
                  .openaiLogo),   
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 243, 246, 1),
            ),
          ),
          ListTile(
            title: Text('Free Talk'),
            onTap: () {
              Navigator.of(context).pop();   
              handleListTileTap(context, 1, null, null);
            },
          ),

          ListTile(
            title: Text('Roleplay Dialogue'),
            onTap: () async {
              BuildContext currentContext = context;   
              Map<String, String>? data = await showRoleplayDialogueForm(context);
              if (data != null) {
                List<String> parameters = [
                  data['userRole']!,
                  data['aiRole']!,
                  data['location']!,
                  data['time']!,
                  data['otherInfo']!
                ];
                await handleListTileTap(currentContext!, 2, data, parameters);   
              }
            },
          ),

          ListTile(
            title: Text('Review Prompts'),
            onTap: () async {
              Navigator.of(context).pop();
              DatabaseService dbService = DatabaseService.instance;
              List<String> parameters = await dbService.getWordsFromDaysAgo([0, 1, 3, 6, 14, 29]);
              Map<String, String> data = {};
              for (int i = 0; i < parameters.length; i++) {
                data[i.toString()] = parameters[i];
              }
              await handleListTileTap(context, 3, data, parameters);
            },
          ),

          ListTile(
            title: Text('Word book'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordBookPage()),
              );
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
                          int id = await DatabaseService.instance
                              .getCurrentUserId();
                          await DatabaseService.instance.updateUser(user, id);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false,
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

  Future<void> handleListTileTap(
      BuildContext context,
      int id,
      Map<String, String>? data,
      List<String>? parameters) async {
    await createConversation(context, id, parameters);
    try {
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      await messageProvider.handleConversationBasedOnMode(id, data);
    } catch (e) {
      print(e);
    }
  }
}