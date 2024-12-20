import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pbl/models/technician.dart';

class PopUpDeleteSurvey extends StatelessWidget {
  const PopUpDeleteSurvey({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: (){},
                  child: Text('Konfirmasii', style: TextStyle(fontSize: 12),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PopUpDeleteTechnicianTeam extends StatelessWidget {
  const PopUpDeleteTechnicianTeam({super.key});

  @override
  Widget build(BuildContext context) {
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
              child:Text('Anda yakin ingin menghapus data tim?', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
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
                  onPressed: (){},
                  child: Text('Konfirmasii', style: TextStyle(fontSize: 12),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PopUpAddTechnicianTeam extends StatelessWidget {
  const PopUpAddTechnicianTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 32
        ),
        height: 250,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.person, size:70, color: Colors.white,),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
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
                  )
                ],
              ),
            ),
            Text('Nama', style: TextStyle(fontSize: 12, color: Colors.black54),),
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
                      hintText: 'Masukkan nama tim',
                      prefixIcon: Icon(Icons.group, size: 18,),
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

class PopUpEditTechnicianTeam extends StatefulWidget {
  final TechnicianTeam team;
  const PopUpEditTechnicianTeam({super.key, required this.team});

  @override
  State<PopUpEditTechnicianTeam> createState() => _PopUpEditTechnicianTeamState();
}

class _PopUpEditTechnicianTeamState extends State<PopUpEditTechnicianTeam> {
  
  final _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.team.name;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 32
        ),
        height: 250,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.person, size:70, color: Colors.white,),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
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
                  )
                ],
              ),
            ),
            Text('Nama', style: TextStyle(fontSize: 12, color: Colors.black54),),
            SizedBox(height: 6,),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                  height: 35,
                  child: TextFormField(
                    controller: _nameController,
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
                      hintText: 'Masukkan nama tim',
                      prefixIcon: Icon(Icons.group, size: 18,),
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
                    child: Text('Simpan', style: TextStyle(fontSize: 12),),
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

class PopUpAddTicket extends StatefulWidget {
  const PopUpAddTicket({super.key});

  @override
  State<PopUpAddTicket> createState() => _PopUpAddTicketState();
}

class _PopUpAddTicketState extends State<PopUpAddTicket> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}