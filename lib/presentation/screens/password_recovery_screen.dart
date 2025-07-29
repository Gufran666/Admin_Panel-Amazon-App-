import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _recoveryButtonController;
  late TextEditingController _emailController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _recoveryButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _recoveryButtonController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _recoverPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessSnackBar('Recovery email sent to $email');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            );
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar('Recovery failed: ${e.message}');
    } catch (e) {
      _showErrorSnackBar('Recovery failed: $e');
    } finally {
      _recoveryButtonController.reverse();
      setState(() => _isProcessing = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Image.asset(
                'assets/images/background.PNG',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withAlpha(10),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox.expand(),
            ),
            Container(
              color: Colors.black.withAlpha(50),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 1200),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.scale(
                                  scale: value,
                                  child: child,
                                ),
                              );
                            },
                            child: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.cyanAccent,
                                  Colors.purpleAccent,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                'Recover Password',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  shadows: <Shadow>[
                                    Shadow(
                                      blurRadius: 15.0,
                                      color: Theme.of(context).primaryColor,
                                      offset: const Offset(3.0, 3.0),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildRecoveryButton(),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            ),
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryButton() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: _recoverPassword,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) => _isProcessing
                      ? Colors.grey.shade300
                      : Theme.of(context).colorScheme.primary,
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2
                    ),
                  ),
                ),
                overlayColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary.withAlpha(30)
                ),
                elevation: WidgetStateProperty.all(12),
                shadowColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary.withAlpha(130)
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'SEND LINK',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.5,
                    color: Colors.white
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}