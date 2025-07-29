import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amazon_clone_admin/presentation/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _verificationButtonController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isProcessingRegistration = false;
  bool _isVerified = false;
  final _formKey = GlobalKey<FormState>();
  DateTime? _lastResend;
  late BuildContext scaffoldContext;

  @override
  void initState() {
    super.initState();
    _verificationButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _verificationButtonController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      return;
    }

    setState(() => _isProcessingRegistration = true);

    try {
      print("Attempting to create user with email: ${_emailController.text.trim()}");
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Send email verification
      final user = userCredential.user;
      await user?.sendEmailVerification();

      // Update user profile with name
      await user?.updateDisplayName(_nameController.text.trim());

      setState(() => _isVerified = true);
      print("User created and verification email sent successfully");
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException caught: ${e.code}");
      if (e.code == 'weak-password') {
        _showErrorSnackBar('The password is too weak');
      } else if (e.code == 'email-already-in-use') {
        _showErrorSnackBar('The email is already in use');
      } else {
        _showErrorSnackBar('Registration failed: ${e.message}');
      }
    } catch (e) {
      print("General exception caught: $e");
      _showErrorSnackBar('Registration failed: $e');
    } finally {
      setState(() => _isProcessingRegistration = false);
    }
  }

  Future<void> _resendVerification() async {
    if (_lastResend != null && DateTime.now().difference(_lastResend!) < const Duration(seconds: 30)) {
      _showErrorSnackBar('Please wait before resending verification');
      return;
    }

    try {
      print("Resending verification email");
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      _showSuccessSnackBar('Verification email resent');
      _lastResend = DateTime.now();
    } catch (e) {
      print("Error resending verification email: $e");
      _showErrorSnackBar('Resend failed: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
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
        body: Builder(
          builder: (scaffoldCtx) {
            scaffoldContext = scaffoldCtx;
            return Stack(
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
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              shrinkWrap: true,
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
                                      'Register Admin',
                                      style: TextStyle(
                                        fontSize: 33,
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
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    prefixIcon: const Icon(Icons.person),
                                    filled: true,
                                    fillColor: Colors.white24,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Full name is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    prefixIcon: const Icon(Icons.email),
                                    filled: true,
                                    fillColor: Colors.white24,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    filled: true,
                                    fillColor: Colors.white24,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () =>
                                          setState(() =>
                                          _obscurePassword = !_obscurePassword),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    filled: true,
                                    fillColor: Colors.white24,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () =>
                                          setState(() =>
                                          _obscureConfirmPassword =
                                          !_obscureConfirmPassword),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                _buildRegisterButton(),
                                const SizedBox(height: 24),
                                if (_isVerified) _buildVerificationSection(),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const LoginScreen(),
                                          transitionsBuilder: (context,
                                              animation, secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: Tween(
                                                  begin: 0.0, end: 1.0).animate(
                                                  animation),
                                              child: child,
                                            );
                                          },
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
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
              onPressed: _register,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) => _isProcessingRegistration
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
              child: _isProcessingRegistration
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'REGISTER',
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

  Widget _buildVerificationSection() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          'Verification Email Sent',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We have sent a verification email to ${_emailController.text}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: _resendVerification,
          child: const Text('RESEND VERIFICATION'),
        ),
      ],
    );
  }
}