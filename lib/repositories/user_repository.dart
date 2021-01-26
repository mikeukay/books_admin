import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:books_admin/models/app_user.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppUser _userToAppUser(User user) {
    if(user == null) return null;
    return AppUser(
      email: user.email,
    );
  }

  Future<AppUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    return _userToAppUser(user);
  }

  Future<AppUser> signInWithGoogleSilently() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signInSilently();
    final GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    return _userToAppUser(user);
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut()
    ]);
  }
}