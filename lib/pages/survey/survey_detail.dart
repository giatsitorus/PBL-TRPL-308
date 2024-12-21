import 'package:flutter/material.dart';
import 'package:pbl/config/config.dart';
import 'package:pbl/models/survey.dart';
import 'package:dio/dio.dart';
import 'package:lottie/lottie.dart';
import 'package:pbl/pages/survey/survey_edit.dart';

final dio = Dio();


class SurveyDetailPage extends StatefulWidget {
  final Map survey;

  const SurveyDetailPage({super.key, required this.survey});

  @override
  State<SurveyDetailPage> createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  List<Map<dynamic, dynamic>> _SurveyImages = [];
  late Map _survey;

  @override
  void initState(){
    super.initState();
    setState(() {

    });
    _survey = widget.survey;
    getSurveyImages(widget.survey['id']);
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

  deleteSurvey(int survey_id) async{
    try {
      final dio = Dio();
      var url = baseUrl + "/api/delete-survey";
      final res = await dio.post(url, data: {'id' : survey_id});

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

  Future<void> getDetailSurvey() async {
    try {
      final dio = Dio();
      var url = baseUrl + "/api/get-survey?survey_id=" + widget.survey['id'].toString();
      final res = await dio.get(url);

      if (res.statusCode == 200 && res.data['data'] != null) {
        setState(() {
          _survey = Map<String, dynamic>.from(res.data['data'][0]);
        });
      } else {
        debugPrint("Data tidak ditemukan atau statusCode tidak 200");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4C53A5),
          title: const Text('Detail',
            style: TextStyle(fontSize: 17, color: Colors.white),),
          centerTitle: true,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white,),
        ),
      ),
      body: Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 8
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(_survey['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(
                      color: Color(0xFF4C53A5),
                      borderRadius: BorderRadius.circular(500)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundImage: NetworkImage("https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                      ),
                      SizedBox(width: 3),
                      Text(
                        "Irvan Bakkara",
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6,),
                Row(
                  children:[
                    Icon(Icons.recycling, size: 18, color: _getColorForState("Waiting")),
                    SizedBox(width: 4,),
                    Text("Waiting", style: TextStyle(fontSize: 13, color: _getColorForState("Waiting")),)
                  ],
                ),
                SizedBox(height: 6,),
                Row(
                  children:[
                    Icon(Icons.dashboard, size: 18,),
                    SizedBox(width: 4,),
                    Text(_survey['project'], style: TextStyle(fontSize: 13),)
                  ],
                ),
                SizedBox(height: 6,),
                Row(
                  children:[
                    Icon(Icons.date_range, size: 18,),
                    SizedBox(width: 4,),
                    Text(_survey['survey_date'], style: TextStyle(fontSize: 13),)
                  ],
                ),
                SizedBox(height: 10,),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Expanded(
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                width: 2,
                                color: Colors.brown.shade200
                            )
                        ),
                        child: Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal, 
                            child: Row(
                              children: List.generate(_SurveyImages.length, (index) {
                                final imagePath = _SurveyImages[index]['image']; 
                                return Container(
                                  width: 100,
                                  height: 100,
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  child: imagePath != null
                                      ? Image.network(
                                        baseUrl + imagePath,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      )
                                      : Container()
                                );
                              }),
                            )
                          ),
                        )
                      ),
                    ),
                    Positioned(
                      top: -10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              color: Colors.white
                          ),
                          child: Text('Gambar Pendukung', style: TextStyle(color: Colors.brown.shade200)),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 2,
                            color: Colors.brown.shade200
                          )
                        ),
                        child: Expanded(
                          child: Text(_survey['description']),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          child: Text('Ringkasan', style: TextStyle(color: Colors.brown.shade200)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
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
              child: InkWell(
                onTap: () async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyEditPage(survey: _survey)));
                  getDetailSurvey();
                  getSurveyImages(widget.survey['id']);
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
                  popUpDelete(widget.survey['id']);
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
                      Text('Hapus Survei', style: TextStyle(color: Colors.white, fontSize: 14))
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

  void popUpDelete(int survey_id){
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
                  child:Text('Anda yakin ingin menghapus data survei?', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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
                        deleteSurvey(survey_id);
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
                  child:Text('Berhasil menghapus data survey!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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

  Color _getColorForState(String state) {
      switch (state) {
        case 'Completed':
          return Color(0xFF388E3C);
        case 'Waiting':
          return Colors.orange;
        case 'In Progress':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }
}