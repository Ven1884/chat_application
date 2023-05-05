import 'package:chat/resources/Shared_Preferences.dart';
import 'package:chat/screens/chat/checkOnlineStatus.dart';
import 'package:chat/screens/homeScreen/homeScreen.dart';
import 'package:chat/screens/profile/profile.dart';
import 'package:chat/screens/search/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/database_services/database_services.dart';

class BottomSheetTest extends StatefulWidget {
  final int? screenIndex;
  final  bool? isProfileScreen;
   const BottomSheetTest({
    Key? key, this.screenIndex, this.isProfileScreen
  }) : super(key: key);

  @override
  State<BottomSheetTest> createState() => _BottomSheetTestState();
}

class _BottomSheetTestState extends State<BottomSheetTest> with WidgetsBindingObserver{
  String email = "";
  String phone = "";
  String dob = "";
  String profilePic = "";
  String userName = "";
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus(true);
    if (widget.isProfileScreen != null) {
      currentIndex = widget.screenIndex ?? 2;
    } else {
      currentIndex = 0;
    }
  }

  buildPages() {
    return [
      const HomeScreen(),
      const Search(),
      Profile(),
    ];
  }

  void setStatus(bool status) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(user).update(
        {"onlineStatus": status});
    print(status);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(true);
    } else {
      setStatus(false);
    }
  }




  getImage() async {
    QuerySnapshot snapshot =
        await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingUserEmail(email);
    setState(() {
      profilePic = snapshot.docs[0]["profilePic"];
    });
  }

  getProfile() async {
    await SharedPref.getName().then((value) {
      setState(() {
         userName = value;
      });
    });
    await SharedPref.getEmail().then((value) {
      setState(() {
        email = value;
      });
    });
    await SharedPref.getPhone().then((value) {
      setState(() {
        phone = value;
      });
    });
    await SharedPref.getDob().then((value) {
      setState(() {
        dob = value;
      });
    });
    await getImage();

    buildPages();

  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPages()[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.deepPurple.withOpacity(0.9),
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(CupertinoIcons.chat_bubble),
          ),
          BottomNavigationBarItem(
            label: "Search",
            icon: Icon(CupertinoIcons.search),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),
    );
  }
}
