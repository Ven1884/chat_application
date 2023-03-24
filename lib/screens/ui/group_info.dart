import 'package:chat/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  String groupName;
  String groupId;
  String adminName;

  GroupInfo(
      {Key? key,
      required this.adminName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    getMembers();
    // TODO: implement initState
    super.initState();
  }

  getMembers() {
    DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
       members= value;
      });
    });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Info"),
        centerTitle: true,
        actions: [
          GestureDetector(onTap: () {}, child: const Icon(Icons.exit_to_app)),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: Colors.blue.withOpacity(0.4),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(widget.groupName.substring(0, 2)),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group : ${widget.groupName}"),
                      Text("Admin : ${getName(widget.adminName)}"),

                    ],
                  ),

                ],
              ),
            ),
            memberList()
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null) {
              if (snapshot.data["members"].length != 0) {
                return ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data["members"].length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(getName(snapshot.data["members"][index])
                                .substring(0, 2),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ),
                          title: Text(getName(snapshot.data["members"][index],),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                          subtitle:
                              Text(getId(snapshot.data["members"][index]),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text("NO MEMBERS"),
                );
              }
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
