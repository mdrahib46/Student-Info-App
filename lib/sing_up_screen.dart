import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_info/signin_screen.dart';

import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool  _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Create an Account to Access Exclusive Features',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email')),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: 'Password')),
                const SizedBox(height: 24),
                Visibility(
                  visible: !_inProgress,
                    replacement: const Center(child: CircularProgressIndicator(),),
                    child: ElevatedButton(onPressed: _onTapSignUp, child: Text('Sign Up'))),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have have an account ? ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: _modeToSignInScreen,
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapSignUp() async {
    _inProgress = true;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (predicate) => false,
          );
        }
        _clearText();
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } finally {
        _inProgress = false;
        setState(() {});
      }
    }
  }

  void _modeToSignInScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen(),),);
  }

  void _clearText(){
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
