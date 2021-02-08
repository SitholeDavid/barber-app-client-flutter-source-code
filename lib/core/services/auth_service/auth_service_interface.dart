import 'package:barber_app_client/core/models/client.dart';

abstract class AuthServiceInterface {
  Future<Client> getCurrentUser();
  Future<bool> signInWithEmail(String email, String password);
  Future<bool> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<bool> isUserLoggedIn();
  Future<bool> signUpWithEmail(String email, String password, String name,
      String surname, String phoneNo);
}
