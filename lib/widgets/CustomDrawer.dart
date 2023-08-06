import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/conversation_model.dart';
import '../database/database_service.dart';
import '../providers/messages_provider.dart';
import '../providers/conversation_provider.dart';
import '../services/assets_manager.dart';
import '../auth/login_page.dart';
import '../database/user_model.dart';
import 'CustomTextField.dart';

// 自定义抽屉组件
class CustomDrawer extends StatelessWidget {
  final User user;

  const CustomDrawer({Key? key, required this.user}) : super(key: key);
  // 创建对话
  Future<void> createConversation(BuildContext context, int type, List<String>? parameters) async {
    Provider.of<MessageProvider>(context, listen: false).clearChat();
    var conversation = Conversation(
      userId: await DatabaseService.instance.getCurrentUserId(),
      type: type,
      date: DateTime.now().toString(),
      parameters: parameters,
    );

    // 捕获insertConversation返回的id
    int id = await DatabaseService.instance.insertConversation(conversation);

    // 获取ConversationProvider并设置当前对话
    var conversationProvider = Provider.of<ConversationProvider>(context, listen: false);
    conversationProvider.setCurrentConversation(conversation,id);
  }

  // 显示角色扮演对话框表单
  Future<Map<String, String>?> showRoleplayDialogueForm(BuildContext context) {
    TextEditingController userRoleController = TextEditingController();
    TextEditingController aiRoleController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController otherInfoController = TextEditingController();
    // 创建AlertDialog供用户输入各类信息
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
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: userRoleController,
                    labelText: 'User Role',
                    hintText: 'Please enter user role',
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: aiRoleController,
                    labelText: 'AI Role',
                    hintText: 'Please enter AI role',
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: locationController,
                    labelText: 'Location of Dialogue',
                    hintText: 'Please enter location of dialogue',
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: timeController,
                    labelText: 'Time of Dialogue',
                    hintText: 'Please enter time of dialogue',
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: otherInfoController,
                    labelText: 'Other Information',
                    hintText: 'Please enter other information',
                  ),
                ],
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
                  // All fields are empty, show an error message.
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
              user.email, // Change this line with your variable
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(AssetsManager
                  .openaiLogo), // Change this line with your variable
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 243, 246, 1),
            ),
          ),
          ListTile(
            title: Text('Free Talk'),
            onTap: () {
              Navigator.of(context).pop();  // close drawer
              handleListTileTap(context, 1, null, null);
            },
          ),

          ListTile(
            title: Text('Roleplay Dialogue'),
            onTap: () async {
              BuildContext currentContext = context; // Save the context before showing the dialog
              Map<String, String>? data = await showRoleplayDialogueForm(context);
              if (data != null) {
                List<String> parameters = [
                  data['userRole']!,
                  data['aiRole']!,
                  data['location']!,
                  data['time']!,
                  data['otherInfo']!
                ];
                await handleListTileTap(currentContext!, 2, data, parameters); // Use the saved context
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