import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pbl/config/config.dart';
import 'package:pbl/models/user.dart';
import 'package:pbl/pages/user/user_add.dart';
import 'package:pbl/pages/user/user_detail.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dio/dio.dart';
import 'dart:io';

final dio = Dio();

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Map<dynamic, dynamic>> _users = [];
  Timer? _debounce;
  String _querySearch = '';
  bool _isLoading = false;
  bool hasMore = true;
  int _limit = 10; 
  int _offset = 0;

  final controller = ScrollController();

  @override
  void initState(){
    super.initState();
    controller.addListener(() {
      if(controller.position.maxScrollExtent == controller.offset){
        fetchData();
      }
    });
    setState(() {
      _isLoading = true;
      getInitialUser();
    });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  Future fetchData() async {
    var res = await getUser(_limit, _offset, _querySearch);
    setState(() {
      _offset += 10;
      _users.addAll(List<Map<String, dynamic>>.from(res['data']));
    });
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
      var url = baseUrl + "/api/get-user?limit=" + limit.toString() +  "&offset=" + offset.toString() + "&search=" + search;
      final res = await dio.get(url);

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return {'data':[]};
  }

  deleteUser(int user_id) async{
    try {
      final dio = Dio();
      var url = baseUrl + "/api/delete-user";
      final res = await dio.post(url, data: {'id' : user_id});

      if (res.statusCode == 200) {
        popUpMessage(true);
        getInitialUser();
      }else{
        popUpMessage(false);
      }
    } catch (e) {
      popUpMessage(false);
      debugPrint(e.toString());
    }
  }

  void onSearch(String search) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4C53A5),
          title: const Text('Daftar Pengguna',
            style: TextStyle(fontSize: 17, color: Colors.white),),
          centerTitle: true,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white,),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getInitialUser,
        child: Column(
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
                      onChanged: (value) => onSearch(value),
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
                          hintText: 'Cari Pengguna...'
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
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => UserAddPage()));
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
            buildContent()
          ],
        ),
      ),
    );

  }
  Widget buildContent(){
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
              return userSkeleton();
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
                return userComponent(user: _users[index]);
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
                  child:Text('Tidak ada data pengguna!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                ),
              ],
            ),
        ),
      );
    }
  }
  userComponent({required Map user}){
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
                  backgroundImage: user['image'] != null ? NetworkImage(baseUrl + user['image']): NetworkImage('https://photosking.net/wp-content/uploads/2024/05/no-dp_16.webp'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                  Text(user['email'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54)),
                  Text(user['phone'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54)),
                  Text(user['role'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54))
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
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailPage(user: user)));
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

  userSkeleton(){
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
  }
}
