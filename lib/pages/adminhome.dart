import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C53A5),
      body: Container(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 60,
                  left: 25,
                  right: 25,
                  bottom: 10
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 6,
                            ),
                            child: Image.asset(
                              'assets/icon/icon.png',
                              width: 25,
                            ),
                          ),
                          const Text(
                              'SphereNet',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context, '/notification');
                            },
                            child:Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: 18,
                              ),
                            ), 
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context, '/setting');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(
                                  left: 10
                              ),
                              child: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10,
                    left: 25,
                    right: 25,
                    bottom: 25
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.account_circle,
                                    color: Color(0xFF4C53A5),
                                    size: 50,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Irvan Bakkara',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins'
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: const Color(0xFF4C53A5)
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10
                                            ),
                                            child: Text(
                                              'Admin',
                                              style:TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 9
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 10
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context, '/history');
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 3
                                        ),
                                        child: const Icon(
                                          Icons.access_time_sharp,
                                          color: Colors.yellow,
                                          size: 18,
                                        ),
                                      ),
                                      const Text(
                                        'Riwayat',
                                        style: TextStyle(
                                            color: Colors.black,
                                          fontSize: 12
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context, '/bantuan');
                                },
                                child: Container(
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      vertical: BorderSide(color: Color(0xFF4C53A5), width: 2)
                                    )
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 3
                                        ),
                                        child: const Icon(
                                          Icons.support_agent_outlined,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      ),
                                      const Text(
                                        'Bantuan',
                                        style: TextStyle(
                                            color: Colors.black,
                                          fontSize: 12
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context, '/profile');
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 3
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Color(0xFF4C53A5),
                                          size: 16,
                                        ),
                                      ),
                                      const Text(
                                        'Edit Profil',
                                        style: TextStyle(
                                            color: Colors.black,
                                          fontSize: 12
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children : [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context, '/user');
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 85,
                                height: 85,
                                margin: const EdgeInsets.only(
                                  bottom: 6
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.05),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.asset(
                                    'assets/images/group.png'
                                  ),
                                )
                              ),
                              const Text(
                                'Pengguna',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context, '/ticket');
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 85,
                                  height: 85,
                                  margin: const EdgeInsets.only(
                                      bottom: 6
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image.asset(
                                        'assets/images/ticket.png'
                                    ),
                                  )
                              ),
                              const Text(
                                'Tiket',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context, '/project');
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 85,
                                  height: 85,
                                  margin: const EdgeInsets.only(
                                      bottom: 6
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.asset(
                                        'assets/images/clipboard.png'
                                    ),
                                  )
                              ),
                              const Text(
                                'Projek Jaringan',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context, '/survey');
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 85,
                                  height: 85,
                                  margin: const EdgeInsets.only(
                                      bottom: 6
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.asset(
                                        'assets/images/checklist.png'
                                    ),
                                  )
                              ),
                              const Text(
                                'Survei',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context, '/technician');
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 85,
                                  height: 85,
                                  margin: const EdgeInsets.only(
                                      bottom: 6
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.asset(
                                        'assets/images/technician.png'
                                    ),
                                  )
                              ),
                              const Text(
                                'Pekerja Lapangan',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}