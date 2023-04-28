import 'package:chat/resources/Shared_Preferences.dart';
import 'package:chat/resources/profile_Controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MessageTile extends StatefulWidget {
  String message;
  String sender;
  String time;
  bool sendByMe;
  String? userProfile;
  String? type;
  MessageTile({
    Key? key,
    this.type,
    this.userProfile,
    required this.time,
    required this.message,
    required this.sendByMe,
    required this.sender,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  String datetime = DateFormat("hh:mm a").format(DateTime.now());
  String email = '';
  String senderProfile = "";
  bool isLoadingImage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getProfilePic();
    });
  }

/*  getImage() async {
    QuerySnapshot snapshot = await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserEmail(email);
    setState(() {

    });
  }*/
  getProfilePic() async {
    await SharedPref.getEmail().then((value) {
      email = value!;
    });
  }

  static String getDateForChat(String datetime) {
    double time = int.parse(datetime) / 1000;
    // Create a DateTime object from the millisecond timestamp
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time.toInt());
// Format the DateTime object to display only the time in jm format
    String formattedTime = DateFormat.jm().format(date);
// Print the formatted time
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    final double maxWidth = isSmallScreen ? screenWidth * 0.65 : 250;
    return ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: widget.sendByMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.sendByMe
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: isSmallScreen ? 40 : 50,
                        height: isSmallScreen ? 40 : 50,
                        margin: const EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.green[300],
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: (widget.userProfile ?? '').isEmpty
                              ? Center(
                                  child: Text(
                                    "fg",
                                    // widget.sender.substring(0, 2).toUpperCase(),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : Image.network(
                                  height: 50,
                                  width: 50,
                                  widget.userProfile.toString(),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loading) {
                                    if (loading == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                        ),
                      ),
                    ),
              Flexible(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: widget.sendByMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        widget.sendByMe
                            ? Text(
                                getDateForChat(widget.time),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              )
                            : const SizedBox(),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: maxWidth,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          decoration: widget.type.toString() == "text"
                              ? BoxDecoration(
                                  color: widget.sendByMe
                                      ? Colors.purple[300]
                                      : Colors.blue[500],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12.0),
                                    topRight: const Radius.circular(12.0),
                                    bottomLeft: widget.sendByMe
                                        ? const Radius.circular(12.0)
                                        : const Radius.circular(0.0),
                                    bottomRight: widget.sendByMe
                                        ? const Radius.circular(0.0)
                                        : const Radius.circular(12.0),
                                  ),
                                )
                              : widget.sendByMe
                                  ? BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18),
                                        bottomLeft: Radius.circular(18),
                                      ))
                                  : BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18),
                                        bottomRight: Radius.circular(18),
                                      )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.type.toString() == "text")
                                Text(
                                  widget.message,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/gallery.jpg',
                                        placeholderErrorBuilder: (context, url, error) => Image.asset('assets/images/404.jpg', fit: BoxFit.cover),
                                        image: widget.message,
                                        height: 200,
                                        width: 150,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder: (context, url, error) => Image.asset('assets/images/error.jpg', fit: BoxFit.cover),
                                      ),

                                      // Image.network(
                                      //   widget.message,
                                      //   fit: BoxFit.cover,
                                      //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      //     if (loadingProgress == null) {
                                      //       return child;
                                      //     }
                                      //     return Center(
                                      //       child: CircularProgressIndicator(
                                      //         value: loadingProgress.expectedTotalBytes != null
                                      //             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      //             : null,
                                      //       ),
                                      //     );
                                      //   },
                                      //   errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      //     return Image.asset('assets/images/chat.jpg', fit: BoxFit.cover);
                                      //   },
                                      // ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 4.0),
                            ],
                          ),
                        ),
                        widget.sendByMe
                            ? const SizedBox()
                            : Text(
                                getDateForChat(widget.time),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              ),
              widget.sendByMe
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: isSmallScreen ? 40 : 50,
                        height: isSmallScreen ? 40 : 50,
                        margin: const EdgeInsets.only(left: 8.0),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            // ignore: unnecessary_null_comparison
                            child: widget.userProfile != null
                                ? Consumer<ProfileController>(
                                    builder: (context, provider, child) {
                                    return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: provider.image == null
                                            ? (widget.userProfile ?? "").isEmpty
                                                ? Center(
                                                    child: Text(
                                                    widget.sender
                                                        .toUpperCase()
                                                        .substring(0, 2),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                                : Image.network(
                                                    height: 50,
                                                    width: 50,
                                                    widget.userProfile ?? '',
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child, loading) {
                                                      if (loading == null) {
                                                        return child;
                                                      }
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                  )
                                            : Container());
                                  })
                                : Text(
                                    widget.sender.toUpperCase().substring(0, 2),
                                    style: const TextStyle(color: Colors.white),
                                  )),
                      ),
                    )
                  : Container(),
            ],
          );
        }));
  }
}