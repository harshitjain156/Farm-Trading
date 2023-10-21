import 'package:flutter/material.dart';

import '../../../models/user.dart';
import 'package:geocoding/geocoding.dart';

class UserDetails extends StatefulWidget {
  final User user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

var locationName;

class _UserDetailsState extends State<UserDetails> {
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    String name = await this.widget.user.getLocationName();
    setState(() {
      locationName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'User Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CloseButton()
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                      offset: Offset(0, 5),
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Make the content stretch horizontally
                  children: <Widget>[
                    ListTile(
                      title: Text('User Name'),
                      trailing: Text('${this.widget.user.name}'),
                    ),
                    ListTile(
                      title: Text('Email'),
                      trailing: Text('${this.widget.user.email}'),
                    ),
                    ListTile(
                      title: Text('Phone'),
                      trailing: Text('${this.widget.user.phone}'),
                    ),
                    // ListTile(
                    //   title: Text('Address')
                    //   // trailing: Text('${locationName}'),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
