import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;
  
  User? get currentUser => _supabase.auth.currentUser;
  
  Session? get currentSession => _supabase.auth.currentSession;
  
  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    
    if (response.user != null) {
      await _supabase.from('profiles').insert({
        'user_id': response.user!.id,
        'username': username,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
    
    return response;
  }

  Future<void> resetPassword({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;
    
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('user_id', currentUser!.id)
        .single();
    
    return response;
  }
  
  Stream<AuthState> get authStateChange => _supabase.auth.onAuthStateChange;
}