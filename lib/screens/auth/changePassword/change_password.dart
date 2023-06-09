import 'package:chat/resources/widget.dart';
import 'package:chat/utils/CustomValidators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String newPass = "";
  String confirmPass = "";
  TextEditingController currentPassTextEditingController =
      TextEditingController();
  TextEditingController newPassTextEditingController = TextEditingController();
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  final _resetKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#FFFFFF'),
      appBar: appBar(
        titleText: "Reset Password",
        context: context,
        isBack: true,
        color: Colors.transparent,
        textStyleColor: Colors.black,
      ),
      body: Form(
        key: _resetKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                sizeBoxH45(),
                // IMAGE
                imageBuild(path: "assets/images/reset.jpg", size: 220),
                // RESET TEXT
                sizeBoxH25(),
                boldText(text: "Reset Password",size: 30),
                sizeBoxH25(),
                // CURRENT PASSWORD TEXT FIELD
                _buildCurrentPasswordTextField(context),
                sizeBoxH15(),
                // NEW  PASSWORD TEXT FIELD
                _buildNewPasswordTextField(context),
                sizeBoxH25(),
                // UPDATE BUTTON
                _buildUpdateButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
  // CURRENT PASSWORD EXTRACT AS A METHOD
  ReusableTextField _buildCurrentPasswordTextField(BuildContext context) {
    return ReusableTextField(
        obSecureText: !_currentPasswordVisible,
        width: MediaQuery.of(context).size.width * 0.85,
        textEditingController: currentPassTextEditingController,
        labelText: "Current Password",
        prefixIcon: const Icon(Icons.security),
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              _currentPasswordVisible = !_currentPasswordVisible;
            });
          },
          child: Icon(
            _currentPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        onChanged: (val) {
          setState(() {
            newPass = val;
          });
        },
        validator: (val) => CustomValidators.validatePassword(val));
  }
  // NEW  PASSWORD EXTRACT AS A METHOD
  ReusableTextField _buildNewPasswordTextField(BuildContext context) {
    return ReusableTextField(
        obSecureText: !_newPasswordVisible,
        width: MediaQuery.of(context).size.width * 0.85,
        textEditingController: newPassTextEditingController,
        labelText: "New Password",
        prefixIcon: const Icon(Icons.security),
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              _newPasswordVisible = !_newPasswordVisible;
            });
          },
          child: Icon(
            _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
        onChanged: (val) {
          setState(() {
            confirmPass = val;
          });
        },
        validator: (val) => CustomValidators.password(val));
  }
  // UPDATE PASSWORD BUTTON EXTRACT AS A METHOD
  _buildUpdateButton(BuildContext context) {
    return reusableButton(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.85,
      onTap: () {
        if(_resetKey.currentState!.validate()) {
          _changePassword();
        }
      },
      text: "Update Password",
    );
  }

  void _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    final currentPassword = currentPassTextEditingController.text;
    final newPassword = newPassTextEditingController.text;

    try {
      // Prompt the user to reauthenticate
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the user's password
      await user.updatePassword(newPassword);
      currentPassTextEditingController.clear();
      newPassTextEditingController.clear();

      // Show a success message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Password Update Successfully',
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors
      if (e.code == 'wrong-password') {
        _resetKey.currentState!.validate() ?  QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error...',
          text: 'The current password is incorrect',
        ) :  Container();
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error...',
          text: 'Error changing password: ${e.message}',
        );
      }
    } catch (e) {
      // Handle other errors
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error...',
        text: 'Error changing password: $e',
      );
    }
  }
}
