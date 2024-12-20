import 'package:flutter/material.dart';

import 'package:pbl/pages/history/history.dart';
import 'package:pbl/pages/help/bantuan.dart';
import 'package:pbl/pages/adminhome.dart';
import 'package:pbl/pages/technicianhome.dart';
import 'package:pbl/pages/userhome.dart';
import 'package:pbl/pages/notification/notification.dart';
import 'package:pbl/pages/profile/profile.dart';

// SETTING
import 'package:pbl/pages/settings/privacypolicy.dart';
import 'package:pbl/pages/project/project.dart';
import 'package:pbl/pages/settings/settings.dart';
import 'package:pbl/pages/settings/twofactor.dart';

import 'package:pbl/pages/survey/survey.dart';
import 'package:pbl/pages/technician/technician.dart';
import 'package:pbl/pages/ticket/ticket.dart';
import 'package:pbl/pages/user/user.dart';

// AUTH
import 'package:pbl/pages/auth/login.dart'; // Tambahkan path ke login.dart
import 'package:pbl/pages/auth/register.dart'; // Tambahkan path ke register.dart
import 'package:pbl/pages/auth/splash_screen.dart'; // Import splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/adminhome': (context) => const AdminHomePage(),
        '/technicianhome': (context) => const TechnicianHomePage(),
        '/userhome': (context) => const UserHomePage(),
        '/user': (context) => const UserPage(),
        '/survey': (context) => const SurveyPage(),
        '/technician': (context) => const TechnicianPage(),
        '/ticket': (context) => const TicketPage(),
        '/project': (context) => const ProjectPage(),
        '/setting': (context) => const SettingsPage(),
        '/privacypolicy': (context) => const  PrivacyPolicyPage(),
        '/twofactor': (context) => const TwoFactorPage(),
        '/profile': (context) => const ProfilePage(),
        '/notification': (context) => const NotificationPage(),
        '/history': (context) => const HistoryPage(),
        '/bantuan': (context) => const HelpPage(),
      },
    );
  }
}