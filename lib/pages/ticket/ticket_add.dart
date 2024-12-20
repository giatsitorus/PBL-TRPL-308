import 'package:flutter/material.dart';

class TicketAddPage extends StatefulWidget {
  const TicketAddPage({super.key});

  @override
  State<TicketAddPage> createState() => _TicketAddPageState();
}

class _TicketAddPageState extends State<TicketAddPage> {
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
            Text('Judul Tiket', style: TextStyle(fontSize: 12, color: Colors.black54),),
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
                      hintText: 'Masukkan Judul',
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
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text('Deskripsi', style: TextStyle(fontSize: 12, color: Colors.black54),),
            SizedBox(height: 6,),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                  child: TextFormField(
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
                    child: Text('Tambah Tiket', style: TextStyle(fontSize: 12),),
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