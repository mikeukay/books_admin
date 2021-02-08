import 'package:books_admin/cubits/create_book/create_book_cubit.dart';
import 'package:books_admin/repositories/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreateBookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a new book',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: BlocProvider(
        create: (context) => CreateBookCubit(
          bookRepository: RepositoryProvider.of<BookRepository>(context),
        ),
        child: CreateBookForm(),
      ),
    );
  }
}

class CreateBookForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBookCubit, CreateBookState>(
      listener: (context, state) {
        if(state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar
            ..showSnackBar(
              const SnackBar(content: Text('Error. Make sure all fields are valid.')),
            );
        } else if(state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0),
                _TitleFormInput(),
                _AuthorFormInput(),
                _PhotoUrlFormInput(),
                _RatingFormInput(),
                _DateReadFormInput(),
                _ReviewFormInput(),
                _SubmitFormButton(),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookCubit, CreateBookState>(
      buildWhen: (oldState, newState) => oldState.title != newState.title,
      builder: (context, state) {
        return TextField(
          key: const Key('createBookForm_titleFormInput_textField'),
          onChanged: (newVal) => BlocProvider.of<CreateBookCubit>(context).updateTitle(newVal),
          decoration: InputDecoration(
            labelText: 'Book Title',
            hintText: 'War and Peace',
            errorText: state.title.invalid ? 'invalid title' : null,
          ),
          maxLength: 128,
        );
      },
    );
  }
}

class _AuthorFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookCubit, CreateBookState>(
      buildWhen: (oldState, newState) => oldState.author != newState.author,
      builder: (context, state) {
        return TextField(
          key: const Key('createBookForm_authorUrlFormInput_textField'),
          onChanged: (newVal) => BlocProvider.of<CreateBookCubit>(context).updateAuthor(newVal),
          decoration: InputDecoration(
            labelText: 'Author',
            hintText: 'Isaac Asimov',
            errorText: state.author.invalid ? 'invalid author' : null,
          ),
          maxLength: 128,
        );
      },
    );
  }
}

class _PhotoUrlFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookCubit, CreateBookState>(
      buildWhen: (oldState, newState) => oldState.photoUrl != newState.photoUrl,
      builder: (context, state) {
        return TextField(
          key: const Key('createBookForm_photoUrlFormInput_textField'),
          onChanged: (newVal) => BlocProvider.of<CreateBookCubit>(context).updatePhotoUrl(newVal),
          decoration: InputDecoration(
            labelText: 'Photo URL',
            hintText: 'https://www.fireacademy.io/favicon.png',
            errorText: state.photoUrl.invalid ? 'invalid photo url' : null,
          ),
          maxLength: 256,
        );
      },
    );
  }
}

class _RatingFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookCubit, CreateBookState>(
      buildWhen: (oldState, newState) => oldState.rating != newState.rating,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rating'),
            Slider(
                key: const Key('createBookForm_ratingFormInput_slider'),
                value: state.rating.invalid ? 0.0 : state.rating.value,
                min: 0.0,
                max: 10.0,
                divisions: 20,
                label: '${state.rating.value} / 10',
                onChanged: (newVal) => BlocProvider.of<CreateBookCubit>(context).updateRating(newVal)
            ),
            state.rating.invalid ? const Text(
              'invalid rating',
              style: const TextStyle(color: Colors.red),
            ) : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

class _DateReadFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookCubit, CreateBookState>(
      buildWhen: (oldState, newState) => oldState.dateRead != newState.dateRead,
      builder: (context, state) {
        DateTime currVal = state.dateRead.value;
        return FlatButton(
          child: Text(
              'Date read: ' + (currVal == null ?
              'Click to choose' :
              '${currVal.year}-${currVal.month}-${currVal.day}')
          ),
          onPressed: () async {
            DateTime newVal = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
            );
            if(newVal == null) return;
            newVal = DateTime(newVal.year, newVal.month, newVal.day);
            BlocProvider.of<CreateBookCubit>(context).updateDateRead(newVal);
          },
        );
      },
    );
  }
}

class _ReviewFormInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookCubit, CreateBookState>(
      buildWhen: (oldState, newState) => oldState.review != newState.review,
      builder: (context, state) {
        return TextField(
          key: const Key('createBookForm_reviewFormInput_textField'),
          onChanged: (newVal) => BlocProvider.of<CreateBookCubit>(context).updateReview(newVal),
          decoration: InputDecoration(
            labelText: 'Review',
            hintText: 'This book made me laugh.',
            errorText: state.review.invalid ? 'invalid review' : null,
          ),
          maxLength: 4096,
          minLines: 1,
          maxLines: 7,
        );
      },
    );
  }
}

class _SubmitFormButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookCubit, CreateBookState>(
      buildWhen: (oldState, newState) => oldState.status != newState.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress ?
        const CircularProgressIndicator() :
        RaisedButton(
          key: const Key('createBookForm_submitFormButton_raisedButton'),
          child: const Text('Create'),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          onPressed: state.status.isValidated ? () {
            BlocProvider.of<CreateBookCubit>(context).submitForm();
          } : null,
        );
      },
    );
  }
}