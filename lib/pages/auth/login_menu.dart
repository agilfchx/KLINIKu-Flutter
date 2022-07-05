import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/components/utils/reuse_widgets.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/pages/auth/forgotPass_menu.dart';

class LoginMenu extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginMenu({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginMenu> createState() => _LoginMenuState();
}

class _LoginMenuState extends State<LoginMenu> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();

  Future signIn() async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim());
      print("Login email as : " + _emailController.text.trim());

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showDialog(
          context: context,
          builder: (context) {
            switch (e.code) {
              case "user-not-found":
                return alertBox(context, "Email tidak ditemukan");
              case "wrong-password":
                return alertBox(context, "Password salah");
              case "too-many-requests":
                return alertBox(context, "Terlalu banyak request saat login");
              default:
                return alertBox(context, "Terdapat kesalahan");
            }
          });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Login Button
    final lButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: primaryColor,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 10),
        minWidth: 200,
        // minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn();
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => MenuPasien()));
        },
        child: Text(
          "MASUK",
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

    // Sudah terdaftar?
    final belumdaftar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Belum punya akun? ", style: TextStyle(fontFamily: 'Roboto')),
        GestureDetector(
          onTap: widget.showRegisterPage,
          child: Text(
            "DAFTAR",
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
                      Text(
                        "LOG IN",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Color.fromARGB(255, 6, 59, 8),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/icons/kliniku-logo.png",
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Selamat datang kembali di\n aplikasi KLINIKu",
                        style: TextStyle(
                            color: Color.fromRGBO(44, 43, 43, 1),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      rTextFF(_emailController, Icons.email_outlined, false),
                      SizedBox(height: 20),
                      rTextFF(_passController, Icons.lock_outline, true),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return ForgotPassword();
                              })));
                            },
                            child: Text(
                              "Lupa Password?",
                              style: TextStyle(
                                color: daftarColor,
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      lButton,
                      SizedBox(height: 20),
                      belumdaftar
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
