import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pbl/models/project.dart';
import 'package:pbl/pages/project/project_add.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  List<Project> _Projects = [
    Project('Kepuasan Kinerja Jaringan', 'Optimasi Jaringan', 'Jln Kamboja C2 No.5', 'In Progress', '22 Jan 2024', 'Irvan Bakkara', 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', 'Survey ini mengukur tingkat kepuasan pengguna terhadap kinerja jaringan, termasuk kecepatan, kestabilan, dan kualitas layanan secara keseluruhan. Tujuannya untuk mengidentifikasi area yang perlu perbaikan dan memastikan bahwa jaringan memenuhi ekspektasi pengguna.'),
    Project('Evaluasi Kualitas Jaringan', 'Optimasi Jaringan', 'Jln Mawar F2 No.4', 'Waiting', '18 Feb 2024', 'Eric Steven', 'https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'Survey ini bertujuan untuk menilai kualitas jaringan yang digunakan, seperti kekuatan sinyal, kecepatan internet, dan pengalamannya dalam penggunaan sehari-hari. Hasilnya memberikan wawasan mengenai potensi peningkatan infrastruktur jaringan yang ada.'
    ),
    Project('Umpan Balik Pengguna Jaringan', 'Keamanan Jaringan', 'Jln Melati D4 No.12 ', 'Completed', '03 Mar 2024', 'Jannes', 'https://static.vecteezy.com/system/resources/thumbnails/026/497/734/small_2x/businessman-on-isolated-png.png',
      'Survey ini mengumpulkan masukan dari pengguna mengenai pengalaman mereka menggunakan jaringan, baik dari sisi kecepatan, kestabilan, maupun kepuasan secara umum. Umpan balik ini membantu provider untuk memahami kebutuhan dan keinginan pengguna, serta meningkatkan layanan yang diberikan.'
    ),
  ];
  List<Project> _foundedProjects = [];
  Timer? _debounce;

  @override
  void initState(){
    super.initState();
    setState(() {
      _foundedProjects = _Projects;
    });
  }

  void onSearch(String search) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _foundedProjects = _Projects
            .where((survey) => survey.name.toLowerCase().contains(search.toLowerCase()))
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
          title: const Text('Projek Jaringan',
            style: TextStyle(fontSize: 17, color: Colors.white),),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: Colors.white,),
          ),
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
                        hintText: 'Cari Projek...'
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectAddPage()));
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
          Expanded(
            child: Container(
            padding: EdgeInsets.only(
              right: 5,
              left: 5
            ),
            child: ListView.builder(
              itemCount: _foundedProjects.length,
              itemBuilder: (context, index){
                return projectComponent(project: _foundedProjects[index]);
              },
            ),
          ),
          )
        ],
      ),
    );
  }

  projectComponent({required Project project}){
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
            project.name,
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
                  backgroundImage: NetworkImage(project.userphoto),
                ),
                SizedBox(width: 3),
                Text(
                  project.username,
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
                color: _getColorForState(project.state),
              ),
              SizedBox(width: 3),
              Text(
                project.state,
                style: TextStyle(
                    fontSize: 10,
                    color: _getColorForState(project.state),
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
                project.projectTitle,
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
                project.date,
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
                // Button delete
                InkWell(
                  onTap: () {
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => const PopUpDeleteSurvey(),
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
                        color: Color(0xFFD32F2F)),
                    child: Icon(
                      Icons.delete_outline,
                      size: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 45),  // Menambahkan jarak antara tombol delete dan detail
                // Button detail
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyDetailPage(survey)));
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
}