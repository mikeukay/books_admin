import 'package:books_admin/cubits/edit_book/edit_book_cubit.dart';
import 'package:books_admin/dialog_util.dart';
import 'package:books_admin/models/book.dart';
import 'package:books_admin/models/quote.dart';
import 'package:books_admin/repositories/book_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBookScreen extends StatelessWidget {

  final Book book;

  const EditBookScreen({Key key,
    @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditBookCubit(
        book,
        bookRepo: RepositoryProvider.of<BookRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Book",
            style: const TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  bool delete = await DialogUtil.showDeleteDialog(
                    context: context,
                    title: 'Delete Book',
                    prompt: 'Are you sure you want to delete this book? This action cannot be undone.',
                  );

                  if(delete == true) {
                    BlocProvider.of<EditBookCubit>(context).deleteBook();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BookPhoto(),
              const SizedBox(height: 8.0),
              BookBasicInfo(),
              const SizedBox(height: 8.0),
              BookReview(),
              const SizedBox(height: 8.0),
              BookQuotes(),
            ],
          ),
        ),
      ),
    );
  }
}


class BookPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (prevState, newState) => prevState.book?.photoUrl != newState.book?.photoUrl,
      builder: (context, state) {
        if(state.status != EditBookStatus.loaded || state.book == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: CachedNetworkImage(
              imageUrl: state.book.photoUrl,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholder: (context, url) => const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}

class _PageSection extends StatelessWidget {

  final String title;
  final List<Widget> actions;
  final Widget child;
  final bool childPadding;

  const _PageSection({Key key,
    @required this.title,
    @required this.child,
    this.actions,
    this.childPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  children: actions ?? [],
                ),
              ],
            ),
          ),
          Padding(
            padding: childPadding ? const EdgeInsets.all(32.0) : const EdgeInsets.all(0.0),
            child: Center(
              child: child,
            ),
          ),
        ]
    );
  }
}

class BookBasicInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      builder: (context, state) {
        if(state.status == EditBookStatus.error) {
          return const Center(
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: const Text('Error while loading book'),
              )
          );
        }

        return _PageSection(
          title: 'Basic Info',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DataTable(
              columns: const [
                const DataColumn(
                  label: const Text('Property'),
                ),
                const DataColumn(
                  label: const Text('Value'),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    const DataCell(const Text('Title')),
                    DataCell(
                      Text(state.book.title),
                      onTap: () async {
                        final String newTitle = await DialogUtil.showStringInputDialog(
                          context: context,
                          initialVal: state.book.title,
                          title: 'Change title',
                          labelText: 'New Title',
                          hintText: 'e.g. Moby Dick',
                        );
                        if(newTitle != null && newTitle != state.book.title)
                          BlocProvider.of<EditBookCubit>(context).updateBookTitle(newTitle);
                      }
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(const Text('Author')),
                    DataCell(
                        Text(state.book.author),
                        onTap: () async {
                          final String newAuthor = await DialogUtil.showStringInputDialog(
                            context: context,
                            initialVal: state.book.author,
                            title: 'Change Author',
                            labelText: 'New Author',
                            hintText: 'e.g. Cixin Liu',
                          );
                          if(newAuthor != null && newAuthor != state.book.author)
                            BlocProvider.of<EditBookCubit>(context).updateBookAuthor(newAuthor);
                        }
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(const Text('Date Read')),
                    DataCell(
                      Text("${state.book.dateRead.year}-${state.book.dateRead.month}-${state.book.dateRead.day}"),
                      onTap: () async {
                        DateTime newVal = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2100),
                        );
                        if(newVal == null) return;
                        newVal = DateTime(newVal.year, newVal.month, newVal.day);
                        if(newVal != state.book.dateRead)
                          BlocProvider.of<EditBookCubit>(context).updateBookDateRead(newVal);
                      }
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(const Text('Rating')),
                    DataCell(
                      Text("${state.book.rating}/10"),
                      onTap: () async {
                        final double newRating = await DialogUtil.showSliderInputDialog(
                          context: context,
                          initialVal: state.book.rating,
                        );

                        if(newRating != null && newRating != state.book.rating)
                          BlocProvider.of<EditBookCubit>(context).updateBookRating(newRating);
                      }
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(const Text('Photo URL')),
                    DataCell(
                        const Text('[tap to edit]'),
                        onTap: () async {
                          final String newPhotoUrl = await DialogUtil.showStringInputDialog(
                            context: context,
                            initialVal: state.book.photoUrl,
                            title: 'Change photo URL',
                            labelText: 'New URL',
                            hintText: 'https://kuhi.to/#..',
                          );
                          if(newPhotoUrl != null && newPhotoUrl != state.book.photoUrl)
                            BlocProvider.of<EditBookCubit>(context).updateBookPhotoUrl(newPhotoUrl);
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class BookReview extends StatefulWidget {
  @override
  _BookReviewState createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  TextEditingController _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (prevState, newState) => prevState.book?.review != newState.book?.review,
      builder: (context, state) {
        if(state.status == EditBookStatus.error || state.book == null) return const SizedBox.shrink();
        if(_controller == null) {
          _controller = TextEditingController(text: state.book.review);
        }

        return _PageSection(
          title: 'Review',
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[500]),
              ),
              hintText: 'I liked this book because...',
            ),
            maxLength: 4096,
            minLines: 2,
            maxLines: 7,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear),
              iconSize: Theme.of(context).textTheme.headline6.fontSize,
              onPressed: () => _controller.text = state.book.review,
            ),
            IconButton(
              icon: const Icon(Icons.check),
              iconSize: Theme.of(context).textTheme.headline6.fontSize,
              onPressed: () {
                String newVal = _controller.value.text;
                if(newVal != null)
                  BlocProvider.of<EditBookCubit>(context).updateBookReview(newVal);
              },
            ),
          ],
        );
      },
    );
  }
}


class BookQuotes extends StatefulWidget {
  @override
  _BookQuotesState createState() => _BookQuotesState();
}

class _BookQuotesState extends State<BookQuotes> {
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBookCubit, EditBookState>(
      buildWhen: (prevState, newState) => prevState.book?.quotes != newState.book?.quotes,
      builder: (context, state) {
        if(state.status == EditBookStatus.error || state.book == null) return const SizedBox.shrink();

        return _PageSection(
          title: 'Quotes',
          childPadding: false,
          child: state.book.quotes == null ?
            const Center(child: CircularProgressIndicator()) :
            state.book.quotes.length == 0 ? Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
              child: const Center(child: const Text('No quotes - add some!')),
            ):
            ListView.builder(
              shrinkWrap: true,
              itemCount: state.book.quotes.length,
              controller: _controller,
              itemBuilder: (context, index) => QuoteListTile(
                quote: state.book.quotes.elementAt(index),
                index: index,
                canMoveUp: index != 0,
                canMoveDown: index != state.book.quotes.length - 1,
              ),
            ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: Theme.of(context).textTheme.headline6.fontSize,
              onPressed: () async {
                final String quoteText = await DialogUtil.showStringInputDialog(
                  context: context,
                  title: 'New Quote',
                  labelText: 'Quote',
                  hintText: 'Firewalls don\'t stop dragons',
                );

                if(quoteText != null) {
                  BlocProvider.of<EditBookCubit>(context).addQuote(quoteText);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class QuoteListTile extends StatelessWidget {

  final Quote quote;
  final int index;
  final bool canMoveUp;
  final bool canMoveDown;

  const QuoteListTile({Key key,
    @required this.quote,
    @required this.index,
    this.canMoveUp = true,
    this.canMoveDown = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32.0),
      title: Text('"${quote.text}"'),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          showEditBottomSheet(context);
        },
      ),
    );
  }

  void showEditBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                tooltip: "Move Down",
                onPressed: canMoveDown ? () {
                  Navigator.of(context).pop();
                  BlocProvider.of<EditBookCubit>(context).moveQuoteDown(index);
                } : () {},
              ),
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                tooltip: "Move Up",
                onPressed: canMoveUp ? () {
                  Navigator.of(context).pop();
                  BlocProvider.of<EditBookCubit>(context).moveQuoteUp(index);
                } : () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: "Delete",
                onPressed: () async {
                  bool delete = await DialogUtil.showDeleteDialog(
                    context: context,
                    title: 'Delete Quote',
                    prompt: 'Are you sure you want to delete this quote?',
                  );

                  if(delete != null && delete) {
                    Navigator.of(context).pop();
                    BlocProvider.of<EditBookCubit>(context).deleteQuote(index);
                  }
                },
              ),
            ],
          ),
        );
      }
    );
  }
}