import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/screen/home_screen.dart';
import 'package:insta_clone/screen/login_screen.dart';
import 'package:insta_clone/screen/signup_screen.dart';
import 'package:insta_clone/screen/user_details_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      routes: {
        // '/': (context) => Scaffold(
        //       body: context.watch<UserProvider>().getCurrentUser != null
        //           ? Center(
        //               child: ElevatedButton(
        //                 onPressed: () {
        //                   context.read<UserProvider>().logoutUser();
        //                 },
        //                 child: const Text('Logout'),
        //               ),
        //             )
        //           : const LoginScreen(),
        //     ),
        // '/': (context) => HomeScreen(),
        '/': (context) => const UserDetailScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/user_details': (context) => const UserDetailScreen(),
      },
      initialRoute: '/',
    );
  }
}
