import 'package:agro_millets/colors.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/globals.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var user = appState.value.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0), // Add preferred height
          child: SizedBox(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        children: [
          _buildProfileCard(
            icon: Icons.person,
            label: 'Username',
            value: user == null ? '' : user!.name,
          ),
          const SizedBox(height: 20),
          _buildProfileCard(
            icon: Icons.email,
            label: 'Email',
            value: user == null ? '' : user!.email,
          ),
          const SizedBox(height: 20),
          _buildProfileCard(
            icon: Icons.phone,
            label: 'Phone Number',
            value: user == null ? '' : user!.phone,
          ),
          const SizedBox(height: 20),
          Container(
            height: 0.065 * getHeight(context),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                "App Access: ${user!.userType}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
      {required IconData icon, required String label, required String value}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
