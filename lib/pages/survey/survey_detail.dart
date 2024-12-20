import 'package:flutter/material.dart';
import 'package:pbl/models/survey.dart';
import 'package:dio/dio.dart';

final dio = Dio();


class SurveyDetailPage extends StatefulWidget {
  final Map survey;

  const SurveyDetailPage({super.key, required this.survey});

  @override
  State<SurveyDetailPage> createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  List<Map<dynamic, dynamic>> _SurveyImages = [];

  @override
  void initState(){
    super.initState();
    setState(() {
    });
    getSurveyImages(widget.survey['id']);
  }

  getSurveyImages(int survey_id) async {
    try {
      final dio = Dio();
      var url = "http://192.168.6.64:3000/api/get-survey-images?survey_id=" + survey_id.toString();
      final res = await dio.get(url);
      print("====================");
      print(res);

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
                  child: Text(widget.survey['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
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
                    Text(widget.survey['project'], style: TextStyle(fontSize: 13),)
                  ],
                ),
                SizedBox(height: 6,),
                Row(
                  children:[
                    Icon(Icons.date_range, size: 18,),
                    SizedBox(width: 4,),
                    Text(widget.survey['survey_date'], style: TextStyle(fontSize: 13),)
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
                                        "http://192.168.6.64:3000" + imagePath,
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
                          child: Text(widget.survey['description']),
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
            Expanded(
              flex: 2,
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
          ],
        ),
      ),
    );;
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