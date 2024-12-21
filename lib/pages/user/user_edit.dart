import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pbl/config/config.dart';
import 'package:pbl/widgets/custom_text_field.dart';
import 'package:dio/dio.dart';
import 'dart:io';

final dio = Dio();
final _formKey = GlobalKey<FormState>();

class UserEditPage extends StatefulWidget {
  final Map user;

  const UserEditPage({super.key, required this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async{
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 120,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white,
                        width: 1
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library, size: 50, color: Color(0xFF4C53A5),),
                        Text('Pilih dari Galeri', style: TextStyle(color: Color(0xFF4C53A5), fontSize: 12),)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async{
                    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 120,
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white,
                        width: 1
                      )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 50, color: Color(0xFF4C53A5),),
                        Text('Ambil dari Kamera', style: TextStyle(color: Color(0xFF4C53A5), fontSize: 12),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }


  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedRole = 'public';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user['name'];
    _emailController.text = widget.user['email'];
    _phoneController.text = widget.user['phone'];
    _selectedRole = widget.user['role'];
  }

  bool passPassword = true;
  bool passPasswordConfirmation = true;
  final Map<String, String> _roleMap = {
    'Admin': 'internal',
    'Publik': 'public',
    'Teknisi': 'technician',
  };
  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(value)) {
      return 'Masukkan email yang valid';
    }
    return null; // Jika valid
  }
  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    String phonePattern = r'^\+?[0-9]{10,15}$';
    RegExp regExp = RegExp(phonePattern);

    if (!regExp.hasMatch(value)) {
      return 'Masukkan nomor telepon yang valid';
    }
    return null;
  }

   Future<void> editUser() async {
    var userData = FormData.fromMap({
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "role": _selectedRole,
      "user_id": widget.user['id'],
      "team_id": null,
      if (_image != null) 'imageUpdate': await MultipartFile.fromFile(
        _image!.path,
        filename: _image!.path.split('/').last,
      ),
    });
    try {
      final dio = Dio();
      final res = await dio.post(
        baseUrl + '/update-user',
        data: userData,
      );

      if (res.statusCode == 200) {
        popUpMessage(true);
        setState(() {
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _selectedRole = 'public'; 
          _image = null;
        });
      } else {
        popUpMessage(false);
      }
    } catch (e) {
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
          title: const Text('Edit Pengguna',
            style: TextStyle(fontSize: 17, color: Colors.white),),
          centerTitle: true,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white,),
        ),
      ),
      body: Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.black26,
                          backgroundImage: _image == null ? widget.user['image'] != null ?
                            NetworkImage(baseUrl + widget.user['image']) : 
                            NetworkImage('https://photosking.net/wp-content/uploads/2024/05/no-dp_16.webp') : 
                            FileImage(_image!),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: InkWell(
                            onTap: (){
                              _pickImage();
                            },
                            child: Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Color(0xFF4C53A5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                )
                              ),
                              child: Icon(Icons.add_a_photo, color: Colors.white, size: 15,),
                            )
                          ),
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
                        SizedBox(height: 4,),
                        
                        Container(
                          width: MediaQuery.of(context).size.width, 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: Color(0xFF4C53A5),
                              width: 1.0, 
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedRole,
                            style: TextStyle(
                              color: Colors.grey.shade500,  
                              fontSize: 12, 
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue;
                              });
                            },
                            underline: SizedBox(),
                            items: _roleMap.values.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(_roleMap.keys.firstWhere((k) => _roleMap[k] == value)),
                              );
                            }).toList(),
                          ),
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
                        SizedBox(height: 4,),
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'Masukkan nama',
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(Icons.person, size: 20,),
                          validator: nameValidator,
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
                        Text('Email', style: TextStyle(fontSize: 12, color: Colors.black54),),
                        SizedBox(height: 4,),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Masukkan email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.email, size: 17,),
                          validator: emailValidator,
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
                        Text('Telepon', style: TextStyle(fontSize: 12, color: Colors.black54),),
                        SizedBox(height: 4,),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: 'Masukkan nomor telepon',
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icon(Icons.phone, size: 17,),
                          validator: phoneNumberValidator,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          )
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 36,
                width: MediaQuery.of(context).size.width / 3 * 2 - 6,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xFF388E3C)),
                child: InkWell(
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      popUpConfirmation();
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 14))
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

  void popUpMessage(bool is_success) async {
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
                  child:Text('Berhasil mengubah data pengguna!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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

    if(is_success){
      Navigator.pop(context, true);
    }
  }

  void popUpConfirmation(){
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
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                        )
                      ],
                    ),
                    Positioned(
                      top: -40,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,  // Centers the widget horizontally and vertically
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 170,
                              child: Lottie.asset(
                                'assets/animation/Animation-add_user.json',
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Pastikan data yang anda isi sudah sesuai!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                        editUser();
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
