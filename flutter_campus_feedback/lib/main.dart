import 'package:flutter/material.dart';
import 'home_page.dart';
import 'about_page.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';

void main() {
  runApp(const CampusFeedbackApp());
}

class CampusFeedbackApp extends StatelessWidget {
  const CampusFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Feedback',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        brightness: Brightness.light,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
      ),
      home: const HomePage(),
      routes: {
        AboutPage.routeName: (_) => const AboutPage(),
        FeedbackFormPage.routeName: (_) => const FeedbackFormPage(),
        FeedbackListPage.routeName: (_) => const FeedbackListPage(),
      },
    );
  }
}
