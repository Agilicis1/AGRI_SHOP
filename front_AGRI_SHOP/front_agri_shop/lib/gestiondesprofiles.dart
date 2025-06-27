import 'package:flutter/material.dart';
import 'homePage.dart';
import 'admin/adminHome.dart';

class GestionDesProfiles extends StatefulWidget {
  final String role;
  final String? userName;

  const GestionDesProfiles({Key? key, required this.role, this.userName}) : super(key: key);

  @override
  _GestionDesProfilesState createState() => _GestionDesProfilesState();
}

class _GestionDesProfilesState extends State<GestionDesProfiles> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _opacity = 0.0;
      });
      // Navigate after the opacity animation (optional)
      Future.delayed(const Duration(milliseconds: 400), () {
        if (widget.role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClientHomePage(userName: widget.userName ?? 'Client')),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 400),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

