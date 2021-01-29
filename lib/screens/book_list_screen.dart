import 'package:books_admin/cubits/auth/auth_cubit.dart';
import 'package:books_admin/screens/create_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book List',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () => BlocProvider.of<AuthCubit>(context).signOut(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Builder(
          builder: (context) => FloatingActionButton(
            child: const Icon(Icons.add),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateBookScreen())
              );
            },
          ),
        ),
      ),
      body: Container(),
    );
  }
}


