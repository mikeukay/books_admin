import 'package:books_admin/cubits/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: const Text('Log in'),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () {
            BlocProvider.of<AuthCubit>(context).signIn();
          },
        ),
      ),
    );
  }
}
