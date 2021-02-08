import 'package:barber_app_client/core/models/client.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service_interface.dart';

class AuthService extends AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = locator<FirestoreServiceInterface>();

  @override
  Future<Client> getCurrentUser() async {
    var user = await _auth.currentUser();

    if (user == null) return null;
    return await _firestore.getClient(user.uid);
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    if (await isUserLoggedIn()) {
      await _auth.signOut();
    }
  }

  @override
  Future<bool> signUpWithEmail(String email, String password, String name,
      String surname, String phoneNo) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (authResult == null) throw Error();

      var client = Client(
          clientID: authResult.user.uid,
          email: email,
          name: name,
          surname: surname,
          phoneNo: phoneNo);

      var result = await _firestore.createClient(client, authResult.user.uid);

      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    var user = await getCurrentUser();
    return user != null;
  }
}
