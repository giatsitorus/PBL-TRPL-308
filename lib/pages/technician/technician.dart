import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl/pages/technician/technician_add.dart';
import 'package:pbl/pages/technician/technician_detail.dart';
import 'package:pbl/widgets/popup.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dio/dio.dart';
import 'dart:io';

final dio = Dio();
final _formKey = GlobalKey<FormState>();

class TechnicianPage extends StatefulWidget {
  const TechnicianPage({super.key});

  @override
  State<TechnicianPage> createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> {
  int _selectedIndex = 0;

  Timer? _debounceTeams;
  Timer? _debounce;

  final _teamNameController = TextEditingController();
  final _teamNameUpdateController = TextEditingController();

  List<Map<dynamic, dynamic>> _users = [];
  List<Map<dynamic, dynamic>> _technicianTeams = [];
  String _querySearch = '';
  String _querySearchTeam = '';
  bool _isLoading = false;
  bool _isLoadingTeam = false;
  bool hasMore = true;
  bool hasMoreTeam = true;
  int _limit = 10;
  int _limitTeam = 10; 
  int _offset = 0;
  int _offsetTeam = 0;
  final controller = ScrollController();
  final controllerTeam = ScrollController();

  File? _imageTeam;
  File? _imageTeamUpdate;

  Future<File?> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    return await showDialog<File?>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return Container(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          Navigator.pop(context, File(pickedFile.path)); // Kembalikan file
                        } else {
                          Navigator.pop(context); // Tutup dialog jika batal
                        }
                      },
                      child: Container(
                        height: 120,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, size: 50, color: Color(0xFF4C53A5)),
                            Text('Pilih dari Galeri', style: TextStyle(color: Color(0xFF4C53A5), fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          Navigator.pop(context, File(pickedFile.path)); // Kembalikan file
                        } else {
                          Navigator.pop(context); // Tutup dialog jika batal
                        }
                      },
                      child: Container(
                        height: 120,
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Color(0xFF4C53A5)),
                            Text('Ambil dari Kamera', style: TextStyle(color: Color(0xFF4C53A5), fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    controller.addListener(() {
      if(controller.position.maxScrollExtent == controller.offset){
        fetchDataUser();
      }
    });
    controllerTeam.addListener(() {
      if(controllerTeam.position.maxScrollExtent == controllerTeam.offset){
        fetchDataTeam();
      }
    });
    setState(() {
      _isLoading = true;
      _isLoadingTeam = true;
      getInitialUser();
      getInitialTeam();
    });
  }

  void onSearchTechnicians(String search) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    setState(() {
      _isLoading = true;
    });

    _debounce = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _querySearch = search;
        _isLoading = false;
      });
      getInitialUser();
    });
  }
  void onSearchTeams(String search) {
    if (_debounceTeams?.isActive ?? false) _debounceTeams?.cancel();

    setState(() {
      _isLoadingTeam = true;
    });

    _debounceTeams = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _querySearchTeam = search;
        _isLoadingTeam = false;
      });
      getInitialTeam();
    });
  }

  Future<void> addTeam() async {
    var teamData = FormData.fromMap({
      "name": _teamNameController.text,
      if (_imageTeam != null) 'imageTechnicianTeam': await MultipartFile.fromFile(
        _imageTeam!.path,
        filename: _imageTeam!.path.split('/').last,
      ),
    });
    try {
      final dio = Dio();
      final res = await dio.post(
        'http://192.168.6.64:3000/api/add-technician-team',
        data: teamData,
      );

      if (res.statusCode == 200) {
        popUpMessage(true, 'Berhasil menambahkan data tim baru!');
        getInitialTeam();
        setState(() {
          _teamNameController.clear();
          _imageTeam = null;
        });
      } else {
        popUpMessage(false, '');
      }
    } catch (e) {
      popUpMessage(false, '');
      debugPrint(e.toString());
    }
  }

  Future<void> updateTeam(int team_id) async {
    var teamData = FormData.fromMap({
      "team_id": team_id,
      "name": _teamNameUpdateController.text,
      if (_imageTeamUpdate != null) 'imageUpdateTechnicianTeam': await MultipartFile.fromFile(
        _imageTeamUpdate!.path,
        filename: _imageTeamUpdate!.path.split('/').last,
      ),
    });
    try {
      final dio = Dio();
      final res = await dio.post(
        'http://192.168.6.64:3000/api/update-technician-team',
        data: teamData,
      );

      if (res.statusCode == 200) {
        popUpMessage(true, 'Berhasil mengubah data Tim!');
        getInitialTeam();
        setState(() {
          _teamNameUpdateController.clear();
          _imageTeamUpdate = null;
        });
      } else {
        popUpMessage(false, '');
      }
    } catch (e) {
      popUpMessage(false, '');
      debugPrint(e.toString());
    }
  }

  deleteUser(int user_id) async{
    try {
      final dio = Dio();
      var url = "http://192.168.6.64:3000/api/delete-user";
      final res = await dio.post(url, data: {'id' : user_id});

      if (res.statusCode == 200) {
        popUpMessage(true, 'Berhasil menghapus data teknisi!');
        getInitialUser();
      }else{
        popUpMessage(false, '');
      }
    } catch (e) {
      popUpMessage(false,'');
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTeam(int team_id) async {
    try {
      final dio = Dio();
      var url = "http://192.168.6.64:3000/api/delete-technician-team";
      final res = await dio.post(url, data: {'id' : team_id});

      if (res.statusCode == 200) {
        popUpMessage(true, 'Berhasil menghapus data tim!');
        getInitialTeam();
      }else{
        popUpMessage(false, '');
      }
    } catch (e) {
      popUpMessage(false, '');
      debugPrint(e.toString());
    }
  }

  String? teamNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  Future getInitialUser() async {
    setState(() {
      _isLoading = true;
      _offset = 0;
    });
    var res = await getUser(_limit, _offset, _querySearch);
    setState(() {
      _offset = 10;
      _isLoading = false;
      _users = List<Map<String, dynamic>>.from(res['data']);
      if (res.length < _limit){
        hasMore = false;
      }
    });
  }

  getUser(int limit, int offset, String search) async {
    try {
      final dio = Dio();
      var url = "http://192.168.6.64:3000/api/get-technician?limit=" + limit.toString() +  "&offset=" + offset.toString() + "&search=" + search;
      final res = await dio.get(url);

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return {'data':[]};
  }

  Future fetchDataUser() async {
    var res = await getUser(_limit, _offset, _querySearch);
    setState(() {
      _offset += 10;
      _users.addAll(List<Map<String, dynamic>>.from(res['data']));
    });
  }

  Future getInitialTeam() async {
    setState(() {
      _isLoadingTeam = true;
      _offsetTeam = 0;
    });
    var res = await getTeam(_limitTeam, _offsetTeam, _querySearchTeam);
    setState(() {
      _offsetTeam = 10;
      _isLoadingTeam = false;
      _technicianTeams = List<Map<String, dynamic>>.from(res['data']);
      if (res.length < _limitTeam){
        hasMoreTeam = false;
      }
    });
  }

  getTeam(int limit, int offset, String search) async {
    try {
      final dio = Dio();
      var url = "http://192.168.6.64:3000/api/get-technician-team?limit=" + limit.toString() +  "&offset=" + offset.toString() + "&search=" + search;
      final res = await dio.get(url);

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return {'data':[]};
  }

  Future fetchDataTeam() async {
    var res = await getTeam(_limitTeam, _offsetTeam, _querySearchTeam);
    setState(() {
      _offsetTeam += 10;
      _technicianTeams.addAll(List<Map<String, dynamic>>.from(res['data']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4C53A5),
          title: const Text('Pekerja Lapangan',
            style: TextStyle(fontSize: 17, color: Colors.white),),
          centerTitle: true,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white,),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200
            ),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      getInitialUser();
                    },
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _selectedIndex == 0 ? Colors.white : Colors.transparent
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.engineering, size: 17, color: _selectedIndex == 0 ? Color(0xFF4C53A5) : Colors.black),
                          SizedBox(width: 8),
                          Text('Teknisi', style: TextStyle(color: _selectedIndex == 0 ? Color(0xFF4C53A5) : Colors.black, fontSize: 12),)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      getInitialTeam();
                    },
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _selectedIndex == 1 ? Colors.white : Colors.transparent
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.group_rounded, size: 18, color: _selectedIndex == 1 ? Color(0xFF4C53A5) : Colors.black),
                          SizedBox(width: 8),
                          Text('Tim', style: TextStyle(color: _selectedIndex == 1 ? Color(0xFF4C53A5) : Colors.black, fontSize: 12),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
          
          Expanded(
            child: _selectedIndex == 0
                ? technicianContainer()
                : teamContainer(),
          ),
        ],
      ),
    );
  }

  technicianContainer(){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade500,
                  )
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: TextField(
                  onChanged: (value) => onSearchTechnicians(value),
                  style: TextStyle(
                      color: Colors.grey.shade500,
                    fontSize: 12
                  ),
                  decoration: InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search_outlined, color: Colors.grey.shade500,),
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none
                      ),
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500
                      ),
                      hintText: 'Cari Teknisi...'
                  ),
                ),
              ),
            ),
            Container(
              width: 85,
              height: 33,
              margin: EdgeInsets.only(
                right: 8,
                top: 6,
                bottom: 6
              ),
              decoration: BoxDecoration(
                color: Color(0xFF388E3C),
                borderRadius: BorderRadius.circular(6)
              ),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => TechnicianAddPage()));
                  getInitialUser();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.person_add, size: 14, color: Colors.white,),
                    ),
                    Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 12),)
                  ],
                ),
              )
              
            )
          ],
        ),
        buildContentTechnician(),
      ],
    );
  }

  Widget buildContentTechnician(){
    if (_isLoading){
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(
            right: 5,
            left: 5
          ),
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index){
              return technicianSkeleton();
            },
          ),
        ),
      );
    }
    else if(!_isLoading && _users.length > 0){
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(
            right: 5,
            left: 5
          ),
          child: ListView.builder(
            controller: controller,
            itemCount: _users.length,
            itemBuilder: (context, index){
              if (index < _users.length){
                return technicianComponent(user: _users[index]);
              }else{
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: hasMore ? CircularProgressIndicator() : Text('No more data to load', style: TextStyle(fontSize: 8, color: Colors.grey.withOpacity(0.8))))
                );
              }
            },
          ),
        ),
      );
    }
    else{
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(
            right: 5,
            left: 5
          ),
          child: Column(
              children: [
                SizedBox(height: 25,),
                Container(
                  height: 180,
                  child: Lottie.asset(
                      'assets/animation/Animation-4.json',
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Tidak ada data teknisi!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                ),
              ],
            ),
        ),
      );
    }
  }

  technicianComponent({required Map user}){
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 4
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          new BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2.0, 2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          ),
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(-2.0, -2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: 6
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: user['image'] != null ? NetworkImage('http://192.168.6.64:3000' + user['image']): NetworkImage('https://photosking.net/wp-content/uploads/2024/05/no-dp_16.webp'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                  Text(user['phone'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54)),
                  user['team'] != null ? Text(user['team'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54)) : Text(''),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: (){
                  popUpDelete(user['id']);
                },
                child: Container(
                  height: 28,
                  width: 28,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                  Radius.circular(4),
                  ),
                  color: Color(0xFFD32F2F)
                  ),
                  child: Icon(Icons.delete_outline, size: 17, color: Colors.white,),
                ),
              ),
              InkWell(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => TechnicianDetailPage(user: user)));
                  getInitialUser();
                },
                child: Container(
                  height: 28,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      color: Color(0xFF4C53A5)
                  ),
                  child: Text('Detail', style: TextStyle(fontSize: 13, color: Colors.white),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  technicianSkeleton(){
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 4
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          new BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2.0, 2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          ),
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(-2.0, -2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          )
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.6),
        period: const Duration(seconds: 3),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.9)
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 80,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 8,
                    width: 140,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 28,
                width: 28,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.withOpacity(0.9)
                ),
              ),
              Container(
                height: 28,
                width: 60,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.withOpacity(0.9)
                ),
              ),
            ],
          )
        ],
      ),
      ),
      
    );
  }

  teamContainer(){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade500,
                  )
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: TextField(
                  onChanged: (value) => onSearchTeams(value),
                  style: TextStyle(
                      color: Colors.grey.shade500,
                    fontSize: 12
                  ),
                  decoration: InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search_outlined, color: Colors.grey.shade500,),
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none
                      ),
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500
                      ),
                      hintText: 'Cari Tim...'
                  ),
                ),
              ),
            ),
            Container(
              width: 85,
              height: 33,
              margin: EdgeInsets.only(
                right: 8,
                top: 6,
                bottom: 6
              ),
              decoration: BoxDecoration(
                color: Color(0xFF388E3C),
                borderRadius: BorderRadius.circular(6)
              ),
              child: InkWell(
                onTap: (){
                  popUpAddTeam();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.group_add, size: 14, color: Colors.white,),
                    ),
                    Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 12),)
                  ],
                ),
              )
              
            )
          ],
        ),
        buildContentTechnicianTeam(),
      ],
    );
  }

  Widget buildContentTechnicianTeam(){
    if (_isLoadingTeam){
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(
            right: 5,
            left: 5
          ),
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index){
              return teamSkeleton();
            },
          ),
        ),
      );
    }
    else if(!_isLoadingTeam && _technicianTeams.length > 0){
      return Expanded(
          child: Container(
          padding: EdgeInsets.only(
            right: 5,
            left: 5
          ),
          child: ListView.builder(
            controller: controllerTeam,
            itemCount: _technicianTeams.length,
            itemBuilder: (context, index){
              if (index < _technicianTeams.length){
              return teamComponent(technicianTeam: _technicianTeams[index]);
              }else{
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: hasMoreTeam ? CircularProgressIndicator() : Text('No more data to load', style: TextStyle(fontSize: 8, color: Colors.grey.withOpacity(0.8))))
                );
              }
            },
          ),
        ),
      );
    }
    else{
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(
            right: 5,
            left: 5
          ),
          child: Column(
              children: [
                SizedBox(height: 25,),
                Container(
                  height: 180,
                  child: Lottie.asset(
                      'assets/animation/Animation-4.json',
                    fit: BoxFit.cover
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child:Text('Tidak ada data Tim!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                ),
              ],
            ),
        ),
      );
    }
  }
  
  teamComponent({required Map technicianTeam}){
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 4
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          new BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2.0, 2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          ),
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(-2.0, -2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: 6
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: technicianTeam['image'] != null ? NetworkImage('http://192.168.6.64:3000' + technicianTeam['image']) : NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpuLk0N3iXJhRLJpJ9vyDe4RwNjgpvPYB3Ww&s'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(technicianTeam['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: (){
                  popUpEditTeam(technicianTeam);
                },
                child: Container(
                  height: 26,
                  width: 26,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                  Radius.circular(4),
                  ),
                  color: Color(0xFF4C53A5)
                  ),
                  child: Icon(Icons.edit, size: 17, color: Colors.white,),
                ),
              ),
              InkWell(
                onTap: (){
                  popUpDeleteTeam(technicianTeam);
                },
                child: Container(
                  height: 26,
                  width: 26,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                  Radius.circular(4),
                  ),
                  color: Color(0xFFD32F2F)
                  ),
                  child: Icon(Icons.delete_outline, size: 17, color: Colors.white,),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  teamSkeleton(){
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 4
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          new BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2.0, 2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          ),
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(-2.0, -2.0),
              blurRadius: 4.0,
              spreadRadius: 1.0
          )
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.6),
        period: const Duration(seconds: 3),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 56,
                width: 56,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.9)
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 28,
                width: 28,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.withOpacity(0.9)
                ),
              ),
              Container(
                height: 28,
                width: 28,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.withOpacity(0.9)
                ),
              ),
            ],
          )
        ],
      ),
      ),
      
    );
  }

  void popUpMessage(bool is_success, String message){
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
                  child:Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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

  void popUpAddTeam() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 32),
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
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.black26,
                                backgroundImage: _imageTeam == null ? NetworkImage('https://photosking.net/wp-content/uploads/2024/05/no-dp_16.webp') : FileImage(_imageTeam!),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: () async {
                                    final resImage = await _pickImage();
                                    if(resImage != null){
                                      setState(() {
                                        _imageTeam = resImage;
                                      });
                                      setStateDialog(() {
                                        _imageTeam = resImage;
                                      });
                                    }
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
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: SizedBox(
                              child: TextFormField(
                                controller: _teamNameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF4C53A5),
                                  hintText: 'Masukkan nama tim',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(9),
                                  isDense: true,
                                ),
                                validator: teamNameValidator,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF388E3C),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0,
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    addTeam();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                              ),
                            ),
                          ],
                        )
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

  void popUpEditTeam(Map team){
    setState(() {
      _teamNameUpdateController.text = team['name'];
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 32),
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
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.black26,
                                backgroundImage: _imageTeamUpdate == null ? team['image'] != null ?
                                  NetworkImage('http://192.168.6.64:3000' + team['image']) : 
                                  NetworkImage('https://photosking.net/wp-content/uploads/2024/05/no-dp_16.webp') : 
                                  FileImage(_imageTeamUpdate!),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: () async {
                                    final resImage = await _pickImage();
                                    if(resImage != null){
                                      setState(() {
                                        _imageTeamUpdate = resImage;
                                      });
                                      setStateDialog(() {
                                        _imageTeamUpdate = resImage;
                                      });
                                    }
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
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: SizedBox(
                              child: TextFormField(
                                controller: _teamNameUpdateController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF4C53A5),
                                  hintText: 'Masukkan nama tim',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(9),
                                  isDense: true,
                                ),
                                validator: teamNameValidator,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF388E3C),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0,
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    updateTeam(team['id']);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                              ),
                            ),
                          ],
                        )
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

  void popUpDeleteTeam(Map team){
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
                  child:Text('Anda yakin ingin menghapus data Tim?', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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
                        deleteTeam(team['id']);
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