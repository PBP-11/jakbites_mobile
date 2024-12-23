import 'package:flutter/material.dart';
import 'package:jakbites_mobile/admin/admin_page.dart';
import 'package:jakbites_mobile/authentication/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jakbites_mobile/main/menu.dart';
import 'package:jakbites_mobile/widgets/left_drawer.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Jakbites',
        theme: ThemeData(
          // Base Fonts
          textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
            bodySmall: GoogleFonts.lora(
              textStyle: textTheme.bodySmall,
              fontSize: 15.0,
            ),
          ),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey,
          ).copyWith(
            secondary: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
          ),
        ),
        home: Consumer<CookieRequest>(
          builder: (context, request, child) {
            if (request.loggedIn) {
              // Fetch user type from the backend
              return FutureBuilder(
                future: request.get('https://william-matthew31-jakbites.pbp.cs.ui.ac.id/authentication/get_user_type_flutter/'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const LoginPage();
                  } else {
                    final userType = snapshot.data['user_type'];
                    if (userType == 'admin') {
                      return const AdminPage();
                    } else {
                      return const MyHomePage();
                    }
                  }
                },
              );
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}