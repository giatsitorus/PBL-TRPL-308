import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pbl/models/ticket.dart';
import 'package:pbl/pages/ticket/ticket_add.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage>{
  List<Ticket> _tickets = [
    Ticket('Internet Down	', 'Koneksi internet di kantor utama tiba-tiba terputus. Semua perangkat tidak bisa terhubung ke internet.', 'Open', 'Rani Cintia', '2024-12-01 08:30:00'),
    Ticket('Permintaan Upgrade Jaringan	', 'Mengajukan permintaan untuk upgrade kecepatan jaringan di lantai 3. Pengguna melaporkan lambatnya koneksi pada waktu puncak.', 'In Progress', 'Josua','2024-12-03 14:45:00'),
    Ticket('Masalah Koneksi VPN	', 'Tidak bisa terhubung ke VPN perusahaan dari rumah. Sudah mencoba beberapa kali tetapi tetap gagal.', 'Closed', 'example@gmail.com','2024-12-05 09:00:00',),
  ];
  List<Ticket> _foundedTickets = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _foundedTickets = _tickets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSearch(String search) {
    // Hentikan timer sebelumnya jika ada
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Timer baru untuk pencarian dengan debounce
    _debounce = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _foundedTickets = _tickets
            .where((ticket) => ticket.subject.toLowerCase().contains(search.toLowerCase()))
            .toList();
      });
    });
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
              showDialog(
                context: context,
                builder: (context) => const PopUpFilter(),
              );
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
                    showDialog(
                      context: context,
                      builder: (context) => const TicketAddPage(),
                    );
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
          Expanded(
            child: Container(
            padding: EdgeInsets.only(
              right: 5,
              left: 5
            ),
            child: ListView.builder(
              itemCount: _foundedTickets.length,
              itemBuilder: (context, index){
                return ticketComponent(ticket: _foundedTickets[index]);
              },
            ),
          ),
          )
        ],
      ),
    );
  }

  ticketComponent({required Ticket ticket}){
    Color _getColorForState(String state) {
      switch (state) {
        case 'Open':
          return Colors.orange;
        case 'In Progress':
          return Color(0xFF388E3C);
        case 'Closed':
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
                  Text(ticket.subject, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),),
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
                        color: _getColorForState(ticket.state),
                      ),
                      SizedBox(width: 3),
                      Text(
                        ticket.state,
                        style: TextStyle(
                            fontSize: 10,
                            color: _getColorForState(ticket.state),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(ticket.create_date, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54)),
                  // Text(ticket.phone, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.black54))
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: (){
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => const PopUpDeleteUser(),
                  // );
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
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailPage(user)));
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
}


class PopUpFilter extends StatelessWidget {
  const PopUpFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
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
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                      fillColor: Color(0xFF4C53A5),
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500
                      ),
                      hintText: 'Pilih Tanggal',
                      prefixIcon: Icon(Icons.date_range, size: 18,),
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
                      contentPadding: const EdgeInsets.only(top: 8.0),
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
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                      fillColor: Color(0xFF4C53A5),
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500
                      ),
                      hintText: 'Pilih Tanggal',
                      prefixIcon: Icon(Icons.date_range, size: 18,),
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
                      contentPadding: const EdgeInsets.only(top: 8.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text('Status', style: TextStyle(fontSize: 12, color: Colors.black54),),
            SizedBox(height: 6,),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                  height: 35,
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                      fillColor: Color(0xFF4C53A5),
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500
                      ),
                      hintText: 'Pilih Status',
                      prefixIcon: Icon(Icons.stacked_bar_chart, size: 18,),
                      suffixIcon: Icon(Icons.arrow_drop_down, size: 18,),
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
                      contentPadding: const EdgeInsets.only(top: 8.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
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
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('Konfirmasi', style: TextStyle(fontSize: 12),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}