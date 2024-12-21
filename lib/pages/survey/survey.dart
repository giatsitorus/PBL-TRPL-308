import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pbl/models/survey.dart';
import 'package:pbl/pages/survey/survey_add.dart';
import 'package:pbl/pages/survey/survey_detail.dart';
import 'package:pbl/widgets/popup.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pbl/config/config.dart';

final dio = Dio();

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<Survey> _foundedSurveys = [];
  Timer? _debounce;
  List<Map<dynamic, dynamic>> _Surveys = [];
  String _querySearch = '';
  bool _isLoading = false;
  bool hasMore = true;
  bool isApplyFilter = false;
  int _limit = 10; 
  int _offset = 0;

  final controller = ScrollController();
  DateTime selectedDateEnd = DateTime.now();
  DateTime selectedDateStart = DateTime.now();
  final _dateEndController = TextEditingController();
  final _dateStartController = TextEditingController();

  String? _selectedStatus = 'all';
  final Map<String, String> _statusMap = {
    'All': 'all',
    'Open': 'draft',
    'Done': 'completed',
  };


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
      getInitialSurvey();
    });
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateEnd,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // Jika user memilih tanggal
    if (picked != null && picked != selectedDateEnd) {
      setState(() {
        selectedDateEnd = picked;
        _dateEndController.text = DateFormat('d MMM yyyy').format(selectedDateEnd);

      });
    }
  }

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateStart,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // Jika user memilih tanggal
    if (picked != null && picked != selectedDateStart) {
      setState(() {
        selectedDateStart = picked;
        _dateStartController.text = DateFormat('d MMM yyyy').format(selectedDateStart);

      });
    }
  }

  Future fetchData() async {
    var res = await getSurvey(_limit, _offset, _querySearch, selectedDateStart, selectedDateEnd, _selectedStatus);
    setState(() {
      _offset += 10;
      _Surveys.addAll(List<Map<String, dynamic>>.from(res['data']));
    });
  }

  Future getInitialSurvey() async {
    setState(() {
      _isLoading = true;
      _offset = 0;
    });
    var res = await getSurvey(_limit, _offset, _querySearch, selectedDateStart, selectedDateEnd, _selectedStatus);
    setState(() {
      _offset = 10;
      _isLoading = false;
      _Surveys = List<Map<String, dynamic>>.from(res['data']);
      if (res.length < _limit){
        hasMore = false;
      }
    });
  }

  getSurvey(int limit, int offset, String search, DateTime startDate, DateTime endDate, String? status) async {
    var start = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
    var end = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);
    try {
      final dio = Dio();
      var url = baseUrl + "/api/get-survey?limit=" + limit.toString() +  "&offset=" + offset.toString() + "&search=" + search + "&state=" + status.toString() + "&startDate=" + start + "&endDate=" + end + "&applyFilter=" + isApplyFilter.toString();
      final res = await dio.get(url);

      if (res.statusCode == 200) {
        return res.data;
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
        popUpMessage(true);
        getInitialSurvey();
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
      getInitialSurvey();
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF4C53A5),
        title: const Text('Survei',
          style: TextStyle(fontSize: 17, color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white,),
        ),
        actions: [
          IconButton(
            onPressed: () {
              popUpFilter();
            },
            icon: Icon(Icons.filter_list_alt, size: 18, color: Colors.white),
          ),
        ],
      ),
      body: Column(
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
                        hintText: 'Cari Survei...'
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
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyAddPage()));
                    getInitialSurvey();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(Icons.add_chart_rounded, size: 14, color: Colors.white,),
                      ),
                      Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 11),)
                    ],
                  ),
                )
                
              )

            ],
          ),
          buildContent(),
        ],
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
              return surveySkeleton();
            },
          ),
        ),
      );
    }
    else if(!_isLoading && _Surveys.length > 0){
      return Expanded(
        child: Container(
        padding: EdgeInsets.only(
          right: 5,
          left: 5
        ),
        child: ListView.builder(
          itemCount: _Surveys.length,
          itemBuilder: (context, index){
            return surveyComponent(survey: _Surveys[index]);
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
                  child:Text('Tidak ada data Survei!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                ),
              ],
            ),
        ),
      );
    }
  }

  surveySkeleton(){
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 4,
        horizontal: 4
      ),
      padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10
      ),
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(4.0, 4.0),
              blurRadius: 10.0,
              spreadRadius: 1.0
            ),
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(-3.0, -3.0),
              blurRadius: 10.0,
              spreadRadius: 1.0
            )
          ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.6),
        period: const Duration(seconds: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 11,
                    width: 180,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 20,
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(0.9)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(0.9)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 70,
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
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 45),  
                  Container(
                    height: 25,
                    width: 90,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  surveyComponent({required Map survey}){
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
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 4,
        horizontal: 4
      ),
      padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10
      ),
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(4.0, 4.0),
              blurRadius: 10.0,
              spreadRadius: 1.0
            ),
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(-3.0, -3.0),
              blurRadius: 10.0,
              spreadRadius: 1.0
            )
          ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
          child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            survey['title'],
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
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
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.recycling,
                size: 15,
                color: _getColorForState("Waiting"),
              ),
              SizedBox(width: 3),
              Text(
                "Waiting",
                style: TextStyle(
                    fontSize: 10,
                    color: _getColorForState("Waiting"),
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.dashboard, size: 15),
              SizedBox(width: 3),
              Text(
                survey['project'],
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.date_range, size: 15),
              SizedBox(width: 3),
              Text(
                survey['survey_date'],
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
      ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    popUpDelete(survey['id']);
                  },
                  child: Container(
                    height: 28,
                    width: 28,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Color(0xFFD32F2F)),
                    child: Icon(
                      Icons.delete_outline,
                      size: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 45), 
                InkWell(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyDetailPage(survey: survey)));
                    getInitialSurvey();
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
                        color: Color(0xFF4C53A5)),
                    child: Text(
                      'Detail',
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                  child:Text('Berhasil menghapus data survei!', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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

  void popUpFilter(){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 32
                  ),
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal Mulai', style: TextStyle(fontSize: 12, color: Colors.black54),),
                      SizedBox(height: 6,),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: SizedBox(
                            height: 35,
                            child: InkWell(
                              onTap: (){
                                _selectDateStart(context);
                              },
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black
                                ),
                                keyboardType: TextInputType.text,
                                enabled: false,
                                controller: _dateStartController,
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
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text('Tanggal Berakhir', style: TextStyle(fontSize: 12, color: Colors.black54),),
                      SizedBox(height: 6,),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: SizedBox(
                            height: 35,
                            child: InkWell(
                              onTap: (){
                                _selectDateEnd(context);
                              },
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black
                                ),
                                keyboardType: TextInputType.text,
                                enabled: false,
                                controller: _dateEndController,
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
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text('Status', style: TextStyle(fontSize: 12, color: Colors.black54),),
                      SizedBox(height: 6,),
                      Container(
                        width: MediaQuery.of(context).size.width, 
                        height: 35,
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
                          value: _selectedStatus,
                          style: TextStyle(
                            color: Colors.grey.shade500,  
                            fontSize: 12, 
                          ),
                          onChanged: (String? newValue) {
                              setStateDialog(() {
                                _selectedStatus = newValue;
                              });
                            },
                          underline: SizedBox(),
                          items: _statusMap.values.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(_statusMap.keys.firstWhere((k) => _statusMap[k] == value)),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4C53A5),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 15
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
                                setState(() {
                                  isApplyFilter = false;
                                  _dateEndController.clear();
                                  _dateStartController.clear();
                                  _selectedStatus = 'all';
                                });
                                getInitialSurvey();
                                Navigator.of(context).pop();
                              },
                              child: Text('Reset', style: TextStyle(fontSize: 12),),
                            ),
                          ),
                          SizedBox(width: 8,),
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
                              onPressed: (){
                                setState(() {
                                  isApplyFilter = true;
                                });
                                getInitialSurvey();
                                Navigator.of(context).pop();

                              },
                              child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
            }
          )
        );
      }
    );
    
  }
}
