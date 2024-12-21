import 'package:flutter/material.dart';
import 'package:pbl/config/config.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';


class TicketDetailPage extends StatefulWidget {
  final Map ticket;

  const TicketDetailPage({super.key, required this.ticket});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late Map _ticket;

  @override
  void initState(){
    super.initState();
    setState(() {

    });
    _ticket = widget.ticket;
  }

  deleteTicket(int ticket_id) async{
    try {
      final dio = Dio();
      var url = baseUrl + "/api/delete-ticket";
      final res = await dio.post(url, data: {'id' : ticket_id});

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
      body:Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 8
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6,),
                Row(
                  children:[
                    Text(_ticket['title'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)
                  ],
                ),
                SizedBox(height: 6,),
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
                SizedBox(height: 6,),
                Row(
                  children:[
                    Icon(Icons.recycling, size: 18, color: _getColorForState(_ticket['state'])),
                    SizedBox(width: 4,),
                    Text(_getState(_ticket['state']), style: TextStyle(fontSize: 13, color: _getColorForState(_ticket['state'])),)
                  ],
                ),
                SizedBox(height: 6,),
                Row(
                  children:[
                    Icon(Icons.date_range, size: 18,),
                    SizedBox(width: 4,),
                    Text(_ticket['created_at'], style: TextStyle(fontSize: 13),)
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
                          child: Text(_ticket['description']),
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
                  // await Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyEditPage(survey: _survey)));
                  // getDetailSurvey();
                  // getSurveyImages(widget.survey['id']);
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
                  popUpDelete(widget.ticket['id']);
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
                      Text('Hapus Tiket', style: TextStyle(color: Colors.white, fontSize: 14))
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
                  child:Text('Anda yakin ingin menghapus data tiket?', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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
}