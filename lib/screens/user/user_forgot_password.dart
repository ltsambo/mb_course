import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/route/route_constants.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

/// Screen for the user to request a password reset PIN.
class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  Future<void> _sendPin() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter your email')));
      return;
    }
    setState(() {
      _loading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.forgotPassword(context, email);

    setState(() {
      _loading = false;
    });

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text('PIN sent to email')));
    // Navigate to ResetPasswordScreen and pass the email
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,   
        elevation: 0,     
        leading: IconButton(
          icon: Icon(Icons.close, color: blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DefaultTextWg(text: 'Forgot Password', 
            fontColor: primaryColor, 
            fontSize: 24,),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration:
                  InputDecoration(labelText: "Email", hintText: "your email here",
                   border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),),             
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : CustomElevatedButton(
                    onPressed: _sendPin, text: "Send PIN"),
          ],
        ),
      ),
    );
  }
}

/// Screen for the user to reset their password by entering the received PIN and a new password.
class ResetPasswordScreen extends StatefulWidget {
  final String email;
  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _loading = false;

  Future<void> _resetPassword() async {
    final pin = _pinController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (pin.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both PIN and new password'))
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.resetPassword(context, widget.email, pin, newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful'))
      );      
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resetting password: $error'))
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: DefaultTextWg(text: 'Reset Password', fontColor: whiteColor, fontSize: 24,), 
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DefaultTextWg(text: "Reset password for ${widget.email}",),
            SizedBox(height: 20),
            TextField(
              controller: _pinController,
              decoration:
                  InputDecoration(labelText: "PIN", hintText: "Enter the PIN", border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                  labelText: "New Password", hintText: "Enter new password", border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : CustomElevatedButton(
                    onPressed: _resetPassword,
                    text: "Reset Password",
                  ),
          ],
        ),
      ),
    );
  }
}
