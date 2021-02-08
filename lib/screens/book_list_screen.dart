import 'package:books_admin/cubits/auth/auth_cubit.dart';
import 'package:books_admin/cubits/book_list/book_list_cubit.dart';
import 'package:books_admin/models/book.dart';
import 'package:books_admin/repositories/book_repository.dart';
import 'package:books_admin/screens/create_book_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookListCubit(
        bookRepository: RepositoryProvider.of<BookRepository>(context),
      )..initialize(),
      child: Scaffold(
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
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CreateBookScreen())
                );
                BlocProvider.of<BookListCubit>(context).refresh();
              },
            ),
          ),
        ),
        body: BookList(),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookListCubit, BookListState>(
      builder: (context, state) {
        switch(state.status) {
          case BookListStatus.not_initialized:
          case BookListStatus.loading:
            return const Center(child: const CircularProgressIndicator());
          case BookListStatus.loaded:
            return _BookListView(
              books: state.books,
              canLoadMore: state.canLoadMore,
              loadingMore: state.loadingMore,
            );
          default:
            return const Center(child: const Text('An error has occurred :('));
        }
      },
    );
  }
}

class _BookListView extends StatelessWidget {
  final List<Book> books;
  final bool canLoadMore;
  final bool loadingMore;

  const _BookListView({Key key,
    @required this.books,
    @required this.canLoadMore,
    @required this.loadingMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => BlocProvider.of<BookListCubit>(context).refresh(),
      child: ListView.builder(
        itemCount: books.length + 1,
        itemBuilder: (context, index) {
          if(index == books.length)
            if(loadingMore)
              return const Center(child: const CircularProgressIndicator());
            else
              return canLoadMore ? FlatButton(
                child: const Text("Load more"),
                onPressed: () => BlocProvider.of<BookListCubit>(context).loadMoreBooks(),
              ) : const SizedBox.shrink();

          Book b = books.elementAt(index);
          return ListTile(
            title: Text(b.title),
            subtitle: Text('Read on ${b.dateRead.year}-${b.dateRead.month}-${b.dateRead.day}\nRating: ${b.rating}/10'),
            isThreeLine: true,
            leading: CachedNetworkImage(
              imageUrl: b.photoUrl,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholder: (context, url) => const SizedBox.shrink(),
            ),
            onTap: () async {
              /* TODO: push edit book screen */
              BlocProvider.of<BookListCubit>(context).refresh();
            },
          );
        },
      ),
    );
  }
}


