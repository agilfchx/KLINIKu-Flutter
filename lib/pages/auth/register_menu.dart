import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/components/utils/reuse_widgets.dart';
import 'package:kliniku/const.dart';

class RegisterMenu extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterMenu({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterMenu> createState() => _RegisterMenuState();
}

class _RegisterMenuState extends State<RegisterMenu> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  String? token = "";

  // Controller
  final _firstNameController = new TextEditingController();
  final _secondNameController = new TextEditingController();
  final _addrController = new TextEditingController();
  final _noHpController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  final _confPassController = new TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _addrController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confPassController.dispose();
    super.dispose();
  }

  Future signUp() async {
    // Auth User
    try {
      // Buat User (Email & Password)
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passController.text.trim());
      }
      // Tambah Detail User
      createUser(
          _firstNameController.text.trim(),
          _secondNameController.text.trim(),
          _addrController.text.trim(),
          _noHpController.text.trim(),
          _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showDialog(
          context: context,
          builder: (context) {
            switch (e.code) {
              case "email-already-in-use":
                return alertBox(context, "Email sudah dipakai");
              case "weak-password":
                return alertBox(context, "Password terlalu lemah");
              default:
                return alertBox(context, "Terdapat kesalahan");
            }
          });
    }
  }

  Future createUser(String fname, String lname, String addr, String phoneNum,
      String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'firstName': fname,
      'lastName': lname,
      'address': addr,
      'phoneNum': phoneNum,
      'email': email,
      'tokenUser': token
    });
  }

  bool passwordConfirmed() {
    if (_passController.text.trim() == _confPassController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    // Button
    final sButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: primaryColor,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 10),
        minWidth: 200,
        onPressed: () {
          signUp();
        },
        child: Text(
          "DAFTAR",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Sudah punya akun?
    final adaAkun = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Sudah punya akun? ", style: TextStyle(fontFamily: 'Roboto')),
        GestureDetector(
          onTap: widget.showLoginPage,
          child: Text(
            "LOGIN",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: daftarColor,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    Text("DAFTAR",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color.fromARGB(255, 6, 59, 8),
                        )),
                    SizedBox(height: 10),
                    Text(
                      "Masukan data diri anda untuk mendaftar pada aplikasi",
                      style: TextStyle(
                          color: Color.fromRGBO(44, 43, 43, 1),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    rrTextFF("Nama Depan", _firstNameController,
                        Icons.person_outline, false),
                    SizedBox(height: 20),
                    rrTextFF("Nama Belakang", _secondNameController,
                        Icons.person_outline, false),
                    SizedBox(height: 20),
                    rrTextFF(
                        "Alamat", _addrController, Icons.home_outlined, false),
                    SizedBox(height: 20),
                    rrTextFF(
                        "No Hp", _noHpController, Icons.phone_outlined, false),
                    SizedBox(height: 20),
                    rrTextFF(
                        "Email", _emailController, Icons.email_outlined, false),
                    SizedBox(height: 20),
                    rrTextFF(
                        "Password", _passController, Icons.lock_outline, true),
                    SizedBox(height: 20),
                    rrTextFF("Ulangi Password", _confPassController,
                        Icons.lock_outline, true),
                    SizedBox(height: 20),
                    sButton,
                    SizedBox(height: 20),
                    adaAkun
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
