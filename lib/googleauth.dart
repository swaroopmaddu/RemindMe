import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseUser loggedinUser;

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> handleSignIn() async {
    // Step 1
    GoogleSignInAccount googleUser = await googleSignIn.signIn();

    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    loggedinUser = currentUser;
    print("signed in " + user.displayName);
    return user;
  }

  Future<void> handleSignOut() async {
    await _auth.signOut();
    googleSignIn.signOut();
  }
}
