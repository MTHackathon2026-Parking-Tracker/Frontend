import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart'; 

// 1. Create a global client variable
final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // 2. Initialize Supabase
  // IMPORTANT: Replace 'something' with your actual key starting with "eyJ..."
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']! ,
    anonKey: dotenv.env['SUPABASE_SERVICE_ROLE_KEY']!, 
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}