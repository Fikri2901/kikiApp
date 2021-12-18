import 'package:flutter/material.dart';
import 'package:kikiapp/database/database.dart';
import 'package:kikiapp/models/user.dart';
import 'package:kikiapp/navbarButtom.dart';
// ignore: unused_import
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController passController = TextEditingController();
  // ignore: unused_field
  bool _validasi = false;

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Admin'),
        centerTitle: true,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorNama,
                      controller: namaController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      validator: validatorPass,
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50.0,
              width: 160.0,
              child: ElevatedButton(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  setState(() {
                    if (namaController.text.isEmpty ||
                        passController.text.isEmpty) {
                      _validasi = true;
                    } else {
                      login();
                    }
                  });
                },
              ),
            ),
          ),
        )
      ]),
    );
  }

  String validatorNama(String value) {
    if (value.length < 1)
      return 'Nama tidak boleh kosong !!!';
    else
      return null;
  }

  String validatorPass(String value) {
    if (value.length < 6)
      return 'Password minimal 6 digit';
    else
      return null;
  }

  login() async {
    final ll = User(nama: namaController.text, password: passController.text);
    var validasi = await MongoDatabase.loginAdmin(ll);
    if (validasi != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('admin', validasi['nama']);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return NavbarButtom();
        },
      ), (route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Admin Berhasil'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('LOGIN GAGAL !!'),
        ),
      );
    }
  }
}
