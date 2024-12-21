import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:pbl/config/config.dart';
import 'package:pbl/widgets/custom_text_field.dart';
import 'package:dio/dio.dart';
import 'dart:io';

final dio = Dio();
final _formKey = GlobalKey<FormState>();

class SurveyEditPage extends StatefulWidget {
  final Map survey;

  const SurveyEditPage({super.key, required this.survey});

  @override
  State<SurveyEditPage> createState() => _SurveyEditPageState();
}

class _SurveyEditPageState extends State<SurveyEditPage> {
  List<File> _imageFiles = [];
  List<Map<dynamic, dynamic>> _SurveyImages = [];
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _projectController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // Jika user memilih tanggal
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('d MMM yyyy').format(selectedDate);

      });
    }
  }

  getSurveyImages(int survey_id) async {
    try {
      final dio = Dio();
      var url = baseUrl + "/api/get-survey-images?survey_id=" + survey_id.toString();
      final res = await dio.get(url);

      if (res.statusCode == 200) {
        setState(() {
          _SurveyImages = List<Map<String, dynamic>>.from(res.data['data']);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return {'data':[]};
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.survey['title'];
    _dateController.text = widget.survey['survey_date'];
    _projectController.text = widget.survey['project'];
    _descriptionController.text = widget.survey['description'];
    getSurveyImages(widget.survey['id']);
  }

  String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul tidak boleh kosong';
    }
    return null;
  }

  String? projekValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Projek tidak boleh kosong';
    }
    return null;
  }

  String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal tidak boleh kosong';
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    return null;
  }

  Future<void> updateSurvey() async {
    List<MultipartFile> files = [];
    if (_imageFiles.isNotEmpty) {
      for (var image in _imageFiles) {
        files.add(await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ));
      }
    }
    var surveyData = FormData.fromMap({
      "survey_id": widget.survey['id'],
      "title": _titleController.text,
      "project": _projectController.text,
      "survey_date": selectedDate,
      "description": _descriptionController.text,
      "existed_images": _SurveyImages, 
      if (files.isNotEmpty) "surveyUpdateImages": files,
    });
    try {
      final dio = Dio();
      final res = await dio.post(
        baseUrl + '/api/update-survey',
        data: surveyData,
      );

      if (res.statusCode == 200) {
        popUpMessage(true);
        setState(() {
          _titleController.clear();
          _dateController.clear();
          _projectController.clear();
          _descriptionController.clear();
          _imageFiles = [];
        });
      } else {
        popUpMessage(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
                    if (selectedImages != null) {
                      setState(() {
                        _imageFiles.insertAll(0, selectedImages
                          .map((e) => File(e.path))
                          .toList());
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
                          color: Colors.white, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library,
                          size: 50,
                          color: Color(0xFF4C53A5),
                        ),
                        Text(
                          'Pilih dari Galeri',
                          style: TextStyle(
                              color: Color(0xFF4C53A5), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Kamera
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _imageFiles.insertAll(0, [File(pickedFile.path)]);
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
                          color: Colors.white, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Color(0xFF4C53A5),
                        ),
                        Text(
                          'Ambil dari Kamera',
                          style: TextStyle(
                              color: Color(0xFF4C53A5), fontSize: 12),
                        ),
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

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }
  void _removeImageOriginal(int index) {
    setState(() {
      _SurveyImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4C53A5),
        title: const Text('Ubah Survei',
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
                  SizedBox(height: 6,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Judul', style: TextStyle(fontSize: 12, color: Colors.black54),),
                        SizedBox(height: 4,),
                        CustomTextField(
                          controller: _titleController,
                          hintText: 'Masukkan judul',
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(Icons.assignment, size: 20,),
                          validator: titleValidator,
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
                        InkWell(
                          onTap: (){
                            _selectDate(context);
                          },
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black
                            ),
                            keyboardType: TextInputType.text,
                            enabled: false,
                            controller: _dateController,
                            validator: dateValidator,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.date_range, size: 20, color: Colors.black,),
                              fillColor: Color(0xFF4C53A5),
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500
                              ),
                              hintText: 'Pilih tanggal',
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
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.black54,
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(8.0),
                            ),
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
                        Text('Projek', style: TextStyle(fontSize: 12, color: Colors.black54),),
                        SizedBox(height: 4,),
                        CustomTextField(
                          controller: _projectController,
                          hintText: 'Masukkan projek',
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(Icons.dashboard, size: 20,),
                          validator: projekValidator,
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
                        Text('Gambar Pendukung', style: TextStyle(fontSize: 12, color: Colors.black54),),
                        SizedBox(height: 4,),
                        Container(
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: Colors.black54,
                              width: 1
                            ) 
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  _pickImage();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: DottedBorder(
                                    borderType: BorderType.Rect,
                                    strokeWidth: 1,
                                    dashPattern: [3, 3, 3, 3],
                                    color: Colors.grey,
                                    child: Container(
                                      width: 82,
                                      height: 82,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo, color: Colors.grey,),
                                          SizedBox(height: 4,),
                                          Text('Tambah', style: TextStyle(fontSize: 9, color: Colors.grey),)
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal, 
                                  child: Row(
                                    children: [
                                      ...List.generate(_imageFiles.length, (index) {
                                        final imagePath = _imageFiles[index]?.path;
                                        return Container(
                                          width: 82,
                                          height: 82,
                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                          child: Stack(
                                            children: [
                                              imagePath != null
                                              ? Image.file(
                                                  File(imagePath),
                                                  height: 82,
                                                  width: 82,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: (){
                                                    _removeImage(index);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.withOpacity(0.8),
                                                      borderRadius: BorderRadius.circular(50)
                                                    ),
                                                    child: Icon(Icons.remove, color: Colors.white, size: 15,)
                                                  ),
                                                ),
                                              )
                                            ]
                                          ),
                                        );
                                      }),
                                      ...List.generate(_SurveyImages.length, (index) {
                                        final imagePath = _SurveyImages[index]['image']; 
                                        return Container(
                                          width: 82,
                                          height: 82,
                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                          child: Stack(
                                            children: [imagePath != null
                                                ? Image.network(
                                                  baseUrl + imagePath,
                                                  height: 82,
                                                  width: 82,
                                                  fit: BoxFit.cover,
                                                )
                                                : Container(),
                                                Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: (){
                                                    _removeImageOriginal(index);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.withOpacity(0.8),
                                                      borderRadius: BorderRadius.circular(50)
                                                    ),
                                                    child: Icon(Icons.remove, color: Colors.white, size: 15,)
                                                  ),
                                                ),
                                              )
                                            ]
                                          )
                                        );
                                      }),
                                    ]
                                  )
                                ),
                              )
                            ],
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
                        Text('Deskripsi', style: TextStyle(fontSize: 12, color: Colors.black54),),
                        SizedBox(height: 4,),
                        TextFormField(
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black
                          ),
                          maxLines: 7,
                          controller: _descriptionController,
                          validator: descriptionValidator,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            fillColor: Color(0xFF4C53A5),
                            hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500
                            ),
                            hintText: 'Masukkan Deskripsi',
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
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 6,),
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
                  child:Text('Berhasil mengubah data survei!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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
                        updateSurvey();
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
