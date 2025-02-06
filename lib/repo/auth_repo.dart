import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  Future<AuthResponse> signInWithGoogle() async {
    try {
      const webClientId = String.fromEnvironment('WEBKEY');
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: webClientId,
        scopes: [
          'email',
          'openid',
        ],
      );
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw "SignIn Cancelled";
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }
      return _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  User? get currentUser => _supabaseClient.auth.currentUser;
}
