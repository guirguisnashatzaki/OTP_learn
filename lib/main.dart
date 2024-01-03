import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: email,
                        decoration:
                        const InputDecoration(hintText: "User Email")),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        myauth.setConfig(
                            appEmail: "me@rohitchouhan.com",
                            appName: "Email OTP",
                            userEmail: email.text,
                            otpLength: 6,
                            otpType: OTPType.digitsOnly
                        );
                        if (await myauth.sendOTP() == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("OTP has been sent"),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Oops, OTP send failed"),
                          ));
                        }
                      },
                      child: const Text("Send OTP")),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 20,
                      style: TextStyle(
                          fontSize: 17
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) async {
                        if (await myauth.verifyOTP(otp: pin) == true) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                        content: Text("OTP is verified"),
                        ));
                        } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                        content: Text("Invalid OTP"),
                        ));
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (await myauth.verifyOTP(otp: otp.text) == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("OTP is verified"),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid OTP"),
                          ));
                        }
                      },
                      child: const Text("Verify")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}