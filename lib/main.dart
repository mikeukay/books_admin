import 'package:books_admin/auth_wrapper.dart';
import 'package:books_admin/cubits/auth/auth_cubit.dart';
import 'package:books_admin/repositories/book_repository.dart';
import 'package:books_admin/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/initial_loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static const Color hooloovoo = Color(0xFF42DAFA);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done)
          return InitialLoadingScreen();
        return RepositoryProvider(
          create: (context) => BookRepository(),
          child: BlocProvider(
            create: (context) => AuthCubit()..tryToSignInSilently(),
            child: MaterialApp(
              title: 'Books - Admin',
              theme: ThemeData(
                primaryColor: hooloovoo,
                accentColor: hooloovoo,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: AuthWrapper(),
            ),
          ),
        );
      }
    );
  }
}
