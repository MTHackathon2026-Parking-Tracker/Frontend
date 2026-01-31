import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart'; // Imports the 'supabase' variable

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool isSignUp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // --- 1. SIGN UP LOGIC ---
  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();

    // Validation: MTSU Emails only
    if (!email.endsWith('@mtmail.mtsu.edu')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restricted to @mtmail.mtsu.edu emails.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

      // Send to Supabase
      await supabase.auth.signUp(
        email: email,
        password: _passwordController.text.trim(),
        data: {
          'full_name': fullName,
          'username': _usernameController.text.trim(),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success! Check your email to confirm.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => isSignUp = false);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unexpected error occurred'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. SIGN IN LOGIC ---
  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Logged In!'), backgroundColor: Colors.green),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 3. CONNECTION TEST ---
  Future<void> _testSupabaseConnection() async {
    try {
      print('Testing connection...');
      final response = await supabase.from('profiles').select().limit(1);
      print('Response: $response');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection Successful!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection Failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // MTSU Colors
    const Color mtsuRoyalBlue = Color.fromARGB(255, 1, 17, 243);
    const Color mtsuWhite = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: mtsuWhite,
      appBar: AppBar(
        backgroundColor: mtsuRoyalBlue,
        title: Text(
          isSignUp ? 'Sign Up' : 'Sign In',
          style: const TextStyle(color: mtsuWhite, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: mtsuRoyalBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isSignUp ? 'Shark and Park' : 'Welcome Back',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: mtsuWhite,
                        ),
                      ),
                      if (isSignUp)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Use your @mtmail.mtsu.edu email',
                            style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Fields
                if (!isSignUp) ...[
                  _buildTextField(_emailController, 'Email', Icons.email),
                  const SizedBox(height: 16),
                  _buildTextField(_passwordController, 'Password', Icons.lock, obscureText: true),
                ],

                if (isSignUp) ...[
                  Row(children: [
                    Expanded(child: _buildTextField(_firstNameController, 'First Name', Icons.person)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(_lastNameController, 'Last Name', Icons.person)),
                  ]),
                  const SizedBox(height: 16),
                  _buildTextField(_usernameController, 'Username', Icons.account_circle),
                  const SizedBox(height: 16),
                  _buildTextField(_emailController, 'Email', Icons.email),
                  const SizedBox(height: 16),
                  _buildTextField(_passwordController, 'Password', Icons.lock, obscureText: true),
                  const SizedBox(height: 16),
                  _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, obscureText: true),
                ],

                const SizedBox(height: 32),

                // Action Button
                if (_isLoading)
                  const CircularProgressIndicator(color: mtsuRoyalBlue)
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSignUp ? _handleSignUp : _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mtsuRoyalBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        isSignUp ? 'Sign Up' : 'Sign In',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mtsuWhite),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isSignUp = !isSignUp;
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  },
                  child: Text(
                    isSignUp ? 'Already have an account? Sign In' : 'Need an account? Sign Up',
                    style: const TextStyle(color: mtsuRoyalBlue, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: _testSupabaseConnection,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: mtsuRoyalBlue, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Test Database Connection",
                    style: TextStyle(color: mtsuRoyalBlue, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build styled text fields
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
  }) {
    const Color mtsuRoyalBlue = Color.fromARGB(255, 1, 17, 243);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 1, 17, 243)),
        prefixIcon: Icon(icon, color: mtsuRoyalBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mtsuRoyalBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mtsuRoyalBlue, width: 2),
        ),
      ),
    );
  }
}