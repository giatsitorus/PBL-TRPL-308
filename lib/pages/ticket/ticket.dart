import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbl/config/config.dart';
import 'package:pbl/models/ticket.dart';
import 'package:pbl/pages/ticket/ticket_add.dart';
import 'package:pbl/pages/ticket/ticket_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';

final dio = Dio();
final _formKey = GlobalKey<FormState>();


class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage>{
  List<Map<dynamic, dynamic>> _tickets = [];
  List<Ticket> _foundedTickets = [];
  Timer? _debounce;
  String _querySearch = '';
  bool _isLoading = false;
  bool hasMore = true;
  int _limit = 10; 
  int _offset = 0;

  final controller = ScrollController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime selectedDateEnd = DateTime.now();
  DateTime selectedDateStart = DateTime.now();
  final _dateEndController = TextEditingController();
  final _dateStartController = TextEditingController();
  bool isApplyFilter = false;
  String? _selectedStatus = 'all';
  final Map<String, String> _statusMap = {
    'All': 'all',
    'Open': 'open',
    'In Progress': 'in_progress',
    'Closed': 'closed',
  };

  @override
  void initState() {
    super.initState();
    getInitialTicket();
  }

  @override
  void dispose() {
    super.dispose();
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
      getInitialTicket();
    });
  }

  Future fetchData() async {
    var res = await getTicket(_limit, _offset, _querySearch, selectedDateStart, selectedDateEnd, _selectedStatus);
    setState(() {
      _offset += 10;
      _tickets.addAll(List<Map<String, dynamic>>.from(res['data']));
    });
  }

  Future getInitialTicket() async {
    setState(() {
      _isLoading = true;
      _offset = 0;
    });
    var res = await getTicket(_limit, _offset, _querySearch, selectedDateStart, selectedDateEnd, _selectedStatus);
    setState(() {
      _offset = 10;
      _isLoading = false;
      _tickets = List<Map<String, dynamic>>.from(res['data']);
      if (res.length < _limit){
        hasMore = false;
      }
    });
  }

  getTicket(int limit, int offset, String search, DateTime startDate, DateTime endDate, String? status) async {
    var start = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
    var end = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);
    try {
      final dio = Dio();
      var url = baseUrl + "/api/get-ticket?limit=" + limit.toString() +  "&offset=" + offset.toString() + "&search=" + search + "&state=" + status.toString() + "&startDate=" + start + "&endDate=" + end + "&applyFilter=" + isApplyFilter.toString();
      final res = await dio.get(url);

      if (res.statusCode == 200) {
        return res.data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return {'data':[]};
  }

  deleteTicket(int ticket_id) async{
    try {
      final dio = Dio();
      var url = baseUrl + "/api/delete-ticket";
      final res = await dio.post(url, data: {'id' : ticket_id});

      if (res.statusCode == 200) {
        popUpMessage(true, 'Berhasil menghapus data ticket!');
        getInitialTicket();
      }else{
        popUpMessage(false, '');
      }
    } catch (e) {
      popUpMessage(false,'');
      debugPrint(e.toString());
    }
  }

  String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul tidak boleh kosong';
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    return null;
  }

  Future<void> addTicket() async {
    var ticketData = {
      "title": _titleController.text,
      "description": _descriptionController.text,
    };
    try {
      final dio = Dio();
      final res = await dio.post(
        baseUrl + '/api/add-ticket',
        data: ticketData,
      );

      if (res.statusCode == 200) {
        popUpMessage(true, 'Berhasil menambahkan data tiket baru!');
        getInitialTicket();
        setState(() {
          _titleController.clear();
          _descriptionController.clear();
        });
      } else {
        popUpMessage(false, '');
      }
    } catch (e) {
      popUpMessage(false, '');
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
          title: const Text('Tiket',
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
                        hintText: 'Cari Tiket...'
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
                    popUpAddTicket();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.add, size: 14, color: Colors.white,),
                      ),
                      Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 12),)
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

  ticketComponent({required Map ticket}){
    Color _getColorForState(String state) {
      switch (state) {
        case 'open':
          return Colors.orange;
        case 'in_progress':
          return Color(0xFF388E3C);
        case 'closed':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }
    String _getState(String state) {
      switch (state) {
        case 'open':
          return 'Open';
        case 'in_progress':
          return 'In Progress';
        case 'closed':
          return 'Closed';
        default:
          return '';
      }
    }
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
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticket['title'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
                  SizedBox(height: 2),
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
                          backgroundImage: NetworkImage('https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Jannes',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.recycling,
                        size: 15,
                        color: _getColorForState(ticket['state']),
                      ),
                      SizedBox(width: 3),
                      Text(
                        _getState(ticket['state']),
                        style: TextStyle(
                            fontSize: 10,
                            color: _getColorForState(ticket['state']),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(ticket['created_at'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: (){
                  popUpDelete(ticket['id']);
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
                onTap: () async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => TicketDetailPage(ticket: ticket,)));
                  getInitialTicket();
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
              return ticketSkeleton();
            },
          ),
        ),
      );
    }
    else if(!_isLoading && _tickets.length > 0){
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(
            right: 5,
            left: 5
          ),
          child: ListView.builder(
            itemCount: _tickets.length,
            itemBuilder: (context, index){
              return ticketComponent(ticket: _tickets[index]);
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
                  child:Text('Tidak ada data tiket!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                ),
              ],
            ),
        ),
      );
    }
  }

  ticketSkeleton(){
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 11,
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 22,
                    width: 80,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 8,
                    width: 60,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 8,
                    width: 120,
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

  void popUpAddTicket() {
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
                              Text('Judul', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _titleController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF4C53A5),
                                  hintText: 'Masukkan judul',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                  isDense: true,
                                ),
                                validator: titleValidator,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Deskripsi', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF4C53A5),
                                  hintText: 'Masukkan deskripsi',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(color: Color(0xFF4C53A5), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                  isDense: true,
                                ),
                                validator: descriptionValidator,
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
                                    addTicket();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text('Tambah Tiket', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
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

  void popUpDelete(int ticket_id){
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
                  child:Text('Anda yakin ingin menghapus data ticket?', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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
                        deleteTicket(ticket_id);
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
                                getInitialTicket();
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
                                getInitialTicket();
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
