import 'package:agro_millets/core/admin/application/admin_apis.dart';
import 'package:agro_millets/core/admin/presentation/user_details.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/user.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Users")),
      body: FutureBuilder(
        future: AdminAPIs.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (snapshot.hasData) {
            // List<User> list = snapshot.data ?? [];
            List<User> list = (snapshot.data as List<User>?)
                ?.where((user) => user.userType.toLowerCase() != 'admin')
                .toList() ?? [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Adjust padding here
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                      return UserListItem(user: list[index]);
                  },
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (user.userType.toLowerCase() != 'admin')
    //   {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 15, // Adjust avatar size here
                child: Text(
                  user.userType[0].toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle user tap
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>UserDetails(user:user)));
                },
                child: Text("View Details"),
              ),
            ],
          ),
        );

    //   } else {
    //   return SizedBox.shrink();
    // }

  }
}

// Usage:
// UsersPage()
