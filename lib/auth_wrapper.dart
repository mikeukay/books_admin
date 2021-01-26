import 'package:books_admin/cubits/auth/auth_cubit.dart';
import 'package:books_admin/screens/book_list_screen.dart';
import 'package:books_admin/screens/initial_loading_screen.dart';
import 'package:books_admin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        switch(state.status) {
          case AuthStatus.authenticated:
            return BookListScreen();
          case AuthStatus.authenticating:
            return InitialLoadingScreen();
          case AuthStatus.not_authenticated:
          default:
            return LoginScreen();
        }
      },
    );
  }
}
