import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/route/screen_export.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false).fetchUsers());
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);        
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24, color: whiteColor,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),  
        title: DefaultTextWg(text: "User List", fontSize: 24, fontColor: whiteColor,),               
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt, color: whiteColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUserScreen(),
                ),
              );
            },
          ),
        ],
        centerTitle: false,
      ),      
      body: userProvider.isLoading
          ? Center(child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              CircularProgressIndicator(),
              DefaultTextWg(text: 'Loading')
            ],)
          ) //  CircularProgressIndicator()
          : ListView.builder(            
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final UserListModel user = userProvider.users[index];    
                print('user image ${user.image}');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: user.image != null && user.image!.isNotEmpty
                        ? NetworkImage(user.image!)
                        : AssetImage(noUserImagePath) as ImageProvider,                        
                      ),
                      title: DefaultTextWg(text: user.username, fontColor: Colors.deepPurple, fontSize: 16,) ,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextWg(text: user.role, fontWeight: FontWeight.normal,),
                          DefaultTextWg(text: user.email, fontWeight: FontWeight.normal, fontColor: Colors.grey,),
                        ],
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, color: whiteColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(userId: user.id,),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
