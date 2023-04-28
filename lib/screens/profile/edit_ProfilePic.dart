import 'dart:io';

import 'package:flutter/material.dart';

import '../../../resources/profile_Controller.dart';

class EditProfilePic extends StatelessWidget {
  const EditProfilePic({
    Key? key,
    required this.provider,
    required this.profilePic,
  }) : super(key: key);
  final ProfileController provider;
  final String profilePic;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: provider.image == null
                ? (profilePic).isEmpty
                ? const Icon(
              Icons.person,
              size: 120,
            )
                : Image.network(
              height: 120,
              width: 120,
              profilePic,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            )
                : Stack(children: [
              Image.file(
                File(provider.image!.path).absolute,
                fit: BoxFit.cover,
              ),
            ]),
          ),
        ),
        GestureDetector(
          onTap: () {
            provider.pickImage(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
            child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                child: const Icon(Icons.edit)),
          ),
        )
      ],
    );
  }
}