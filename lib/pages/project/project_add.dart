import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pbl/widgets/custom_text_field.dart';

class ProjectAddPage extends StatefulWidget {
  const ProjectAddPage({super.key});

  @override
  State<ProjectAddPage> createState() => _ProjectAddPageState();
}

class _ProjectAddPageState extends State<ProjectAddPage> {
  final _nameController = TextEditingController();
  final _projectController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4C53A5),
          title: const Text('Projek Baru',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    Text('Perusahaan', style: TextStyle(fontSize: 12, color: Colors.black54),),
                    SizedBox(height: 4,),
                    CustomTextField(
                      controller: _companyNameController,
                      hintText: 'Masukkan nama perusahaan',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.apartment, size: 17,),
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
                    Text('Alamat Perusahaan', style: TextStyle(fontSize: 12, color: Colors.black54),),
                    SizedBox(height: 4,),
                    CustomTextField(
                      controller: _companyAddressController,
                      hintText: 'Masukkan alamat perusahaan',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.pin_drop_outlined, size: 17,),
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
                    Text('Sumber Layanan Jaringan', style: TextStyle(fontSize: 12, color: Colors.black54),),
                    SizedBox(height: 4,),
                    CustomTextField(
                      controller: _projectController,
                      hintText: 'Pilih layanan',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.network_cell, size: 17,),
                      suffixIcon: Icon(Icons.arrow_drop_down, size: 17,),
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
                    Text('Tanggal', style: TextStyle(fontSize: 12, color: Colors.black54),),
                    SizedBox(height: 4,),
                    CustomTextField(
                      controller: _dateController,
                      hintText: 'Pilih tanggal',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.date_range, size: 17,),
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
                    Text('Deskripsi', style: TextStyle(fontSize: 12, color: Colors.black54),),
                    SizedBox(height: 4,),
                    TextFormField(
                      controller: _descriptionController,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      fillColor: Color(0xFF4C53A5),
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500
                      ),
                      hintText: 'Masukkan Deskripsi',
                      // suffixIcon: suffixIcon,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF4C53A5),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF4C53A5),
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                    ),
                  ),
                  ],
                ),
              ),
            ],
          ),
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
                    showDialog(
                      context: context,
                      builder: (context) => const PopUpAddProject(),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ajukan Projek', style: TextStyle(color: Colors.white, fontSize: 14))
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
}

class PopUpAddProject extends StatelessWidget {
  const PopUpAddProject({super.key});

  @override
  Widget build(BuildContext context) {
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
                      borderRadius: BorderRadius.circular(12), // Set the border radius here
                    ),
                  ),
                  onPressed: (){},
                  child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}