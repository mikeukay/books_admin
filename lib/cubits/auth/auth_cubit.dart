import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_admin/repositories/user_repository.dart';
import 'package:books_admin/models/app_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit({UserRepository userRepository}) :
      _userRepository = userRepository ?? UserRepository(), super(AuthState.initial());

  Future<void> tryToSignInSilently() async {
    emit(AuthState.loading());
    try {
      final AppUser user = await _userRepository.signInWithGoogleSilently();
      emit(AuthState.loggedIn(user));
    } catch(_) {
      emit(AuthState.loggedOut());
    }
  }

  Future<void> signIn() async {
    emit(AuthState.loading());
    try {
      final AppUser user = await _userRepository.signInWithGoogle();
      if(user.isAdmin) {
        emit(AuthState.loggedIn(user));
      } else {
        signOut();
      }
    } catch(_) {
      emit(AuthState.loggedOut());
    }
  }

  Future<void> signOut() async {
    emit(AuthState.loading());
    await _userRepository.signOut();
    emit(AuthState.loggedOut());
  }
}