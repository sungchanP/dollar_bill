import 'dart:async';
//import 'package:email_auth/utils/constants/firebase_constants.dart';
import 'package:dollar_bill/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVer extends StatefulWidget {
  const EmailVer({Key? key}) : super(key: key);

  @override
  State<EmailVer> createState() => _EmailVerState();
}

class _EmailVerState extends State<EmailVer> {

  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    //isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified){
      sendVerification();
    }
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future sendVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified? Home() : Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Check your \n Email',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Text(
                  'We have sent you a Email',// on  ${auth.currentUser?.email}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Text(
                  'Verifying email....',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 57),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                child: const Text('Resend'),
                onPressed: () {
                  try {
                    FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification();
                  } catch (e) {
                    debugPrint('$e');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}