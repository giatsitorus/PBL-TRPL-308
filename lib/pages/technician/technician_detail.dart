import 'package:flutter/material.dart';
import 'package:pbl/models/user.dart';
import 'package:lottie/lottie.dart';
import 'package:pbl/pages/user/user_edit.dart';
import 'package:pbl/widgets/custom_text_field.dart';
import 'package:dio/dio.dart';
import 'dart:io';

final dio = Dio();
final _formKey = GlobalKey<FormState>();

class TechnicianDetailPage extends StatefulWidget {
  final Map user;

  const TechnicianDetailPage({super.key, required this.user});

  @override
  State<TechnicianDetailPage> createState() => _TechnicianDetailPageState();
}

class _TechnicianDetailPageState extends State<TechnicianDetailPage> {
  late Map _user;
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  bool passPassword = true;
  bool passPasswordConfirmation = true;

  void initState() {
    super.initState();
    _user = widget.user;
  }
  Future<void> getDetailUser() async {
  try {
    final dio = Dio();
    var url = "http://192.168.6.64:3000/api/get-user?user_id=" + widget.user['id'].toString();
    final res = await dio.get(url);

    if (res.statusCode == 200 && res.data['data'] != null) {
      setState(() {
        _user = Map<String, dynamic>.from(res.data['data'][0]);
      });
    } else {
      debugPrint("Data tidak ditemukan atau statusCode tidak 200");
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}



  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    return null;
  }
  String? confirmPasswordValidator(String? value, TextEditingController passwordController) {
    if (value == null || value.isEmpty) {
      return 'kata sandi tidak boleh kosong';
    }
    if (value != passwordController.text) {
      return 'kata sandi tidak cocok';
    }
    return null;
  }

  Future<void> changePassword() async {
    var userData = {
      "password": _passwordController.text,
      "confirmation_password": _passwordConfirmationController.text,
      "user_id" : widget.user['id']
    };

    try {
      final dio = Dio();
      final res = await dio.post(
        'http://192.168.6.64:3000/api/change-password',
        data: userData,
      );
      if (res.statusCode == 200) {
        popUpMessage(true);
        setState(() {
          _passwordController.clear();
          _passwordConfirmationController.clear();
        });
      } else {
        popUpMessage(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

  }

  deleteUser(int user_id) async{
    try {
      final dio = Dio();
      var url = "http://192.168.6.64:3000/api/delete-user";
      final res = await dio.post(url, data: {'id' : user_id});

      if (res.statusCode == 200) {
        popUpMessageDelete(true);
      }else{
        popUpMessageDelete(false);
      }
    } catch (e) {
      popUpMessageDelete(false);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4C53A5),
        title: const Text('Detail Teknisi', style: TextStyle(fontSize: 17, color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () { Navigator.pop(context); },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white,),
        ),
        actions: [
          IconButton(
            onPressed: () {
              popUpCredential();
            },
            icon: Icon(Icons.settings, size: 18, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _user['image'] != null
                        ? NetworkImage('http://192.168.6.64:3000' + _user['image'])
                        : NetworkImage('https://photosking.net/wp-content/uploads/2024/05/no-dp_16.webp'),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Peran', style: TextStyle(fontSize: 12, color: Colors.black54),),
                  SizedBox(height: 2,),
                  Row(
                    children: [
                      Icon(Icons.security, size: 17,),
                      SizedBox(width: 4,),
                      Text(_getRole(_user['role']), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 6,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama', style: TextStyle(fontSize: 12, color: Colors.black54),),
                  SizedBox(height: 2,),
                  Row(
                    children: [
                      Icon(Icons.person, size: 17,),
                      SizedBox(width: 4,),
                      Text(_user['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 6,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email', style: TextStyle(fontSize: 12, color: Colors.black54),),
                  SizedBox(height: 2,),
                  Row(
                    children: [
                      Icon(Icons.email, size: 17,),
                      SizedBox(width: 4,),
                      Text(_user['email'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 6,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Telepon', style: TextStyle(fontSize: 12, color: Colors.black54),),
                  SizedBox(height: 2,),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 17,),
                      SizedBox(width: 4,),
                      Text(_user['phone'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
                  final isSuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserEditPage(user: _user)));
                  if(isSuccess){
                    getDetailUser();
                  }
                },
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xFF4C53A5)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(Icons.edit, size: 15, color: Colors.white),
                      ),
                      Text('Ubah', style: TextStyle(color: Colors.white, fontSize: 14))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: (){
                  popUpDelete(_user['id']);
                },
                child: Container(
                  height: 36,
                  width: MediaQuery.of(context).size.width / 3 * 2 - 6,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xFFD32F2F)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(Icons.delete_outline, size: 17, color: Colors.white),
                      ),
                      Text('Hapus Pengguna', style: TextStyle(color: Colors.white, fontSize: 14))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRole(String role){
    switch (role) {
      case 'public':
        return 'Publik';
      case 'internal':
        return 'Admin';
      case 'technician':
        return 'Teknisi';
      default:
        return '';
    }
  }

  void popUpCredential() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kata Sandi', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: passPassword,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF4C53A5),
                                  hintText: 'Masukkan kata sandi',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setStateDialog(() {
                                        passPassword = !passPassword;
                                      });
                                    },
                                    child: Icon(passPassword ? Icons.visibility : Icons.visibility_off),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(6),
                                  isDense: true,
                                ),
                                validator: passwordValidator,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Konfirmasi Kata Sandi', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _passwordConfirmationController,
                                obscureText: passPasswordConfirmation,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF4C53A5),
                                  hintText: 'Masukkan kata sandi',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setStateDialog(() {
                                        passPasswordConfirmation = !passPasswordConfirmation;
                                      });
                                    },
                                    child: Icon(passPasswordConfirmation ? Icons.visibility : Icons.visibility_off),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(6),
                                  isDense: true,
                                ),
                                validator:  (value) => confirmPasswordValidator(value, _passwordController),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4C53A5),
                                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Color(0xFF4C53A5)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.of(context).pop();
                                    changePassword();
                                  }
                                },
                                child: Text('Konfirmasi', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  void popUpMessage(bool is_success){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return Dialog(
          child: is_success? 
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 32
            ),
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6)
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Lottie.asset(
                      'assets/animation/Animation-3.json',
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Berhasil mengganti password!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4C53A5),
                          padding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 20
                          ),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Color(0xFF4C53A5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Set the border radius here
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ) : 
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 32
            ),
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6)
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Lottie.asset(
                      'assets/animation/Animation-2.json',
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Terjadi kesalahan internal di server, silahkan coba lagi!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4C53A5),
                          padding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 20
                          ),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Color(0xFF4C53A5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Set the border radius here
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        );
      }
    );
  }

  void popUpMessageDelete(bool is_success) async {
    await showDialog(
      context: context, 
      builder: (BuildContext context){
        return Dialog(
          child: is_success? 
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 32
            ),
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6)
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Lottie.asset(
                      'assets/animation/Animation-3.json',
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Berhasil menghapus data pengguna!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4C53A5),
                          padding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 20
                          ),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Color(0xFF4C53A5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Set the border radius here
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ) : 
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 32
            ),
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6)
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Lottie.asset(
                      'assets/animation/Animation-2.json',
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Terjadi kesalahan internal di server, silahkan coba lagi!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4C53A5),
                          padding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 20
                          ),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Color(0xFF4C53A5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Set the border radius here
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        );
      }
    );
    if (is_success){
      Navigator.pop(context, true);
    }
  }

  void popUpDelete(int user_id){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 32
            ),
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6)
            ),
            child: Column(
              children: [
                Container(
                  height: 90,
                  child: Lottie.asset(
                      'assets/animation/Animation-delete_user.json',
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Anda yakin ingin menghapus data pengguna?', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 20
                        ),
                        foregroundColor: Color(0xffEC5B5B),
                        side: BorderSide(
                          color: Color(0xffEC5B5B),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Set the border radius here
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text('Batalkan', style: TextStyle(fontSize: 12),),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF388E3C),
                        padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 20
                        ),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Color(0xFF388E3C),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Set the border radius here
                        ),
                      ),
                      onPressed: (){
                        deleteUser(user_id);
                        Navigator.of(context).pop();
                      },
                      child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }
    );

  }


}
