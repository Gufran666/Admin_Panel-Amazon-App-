import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _verificationButtonController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isProcessingRegistration = false;
  bool _isVerified = false;

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
    setState(() {
      _isProcessingRegistration = true;
    });

    try {
      await HapticFeedback.lightImpact();
      _verificationButtonController.forward();
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isVerified = true;
      });
    } finally {
      _verificationButtonController.reverse();
      setState(() {
        _isProcessingRegistration = false;
      });
    }
  }

  Future<void> _resendVerification() async {
    try {
      await HapticFeedback.lightImpact();
      setState(() {
        _isVerified = false;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isVerified = true;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Register Admin Account',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.primaryColor,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        prefixIconColor: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.primaryColor,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
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
                        labelStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.primaryColor,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
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
                        labelStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.primaryColor,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
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
                    const SizedBox(height: 24),
                    _buildRegisterButton(),
                    const SizedBox(height: 16),
                    if (!_isVerified) _buildVerificationSection(),
                    const SizedBox(height: 16),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.darkTheme.primaryColor,
                        textStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        // Navigate to login screen
                        Navigator.pop(context);
                      },
                      child: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.darkTheme.primaryColor,
        foregroundColor: AppTheme.darkTheme.textTheme.bodyLarge!.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        textStyle: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      onPressed: _isProcessingRegistration ? null : _register,
      child: _isProcessingRegistration
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : const Text('Register'),
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
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We have sent a verification email to ${_emailController.text}',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.darkTheme.primaryColor,
            foregroundColor: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
            textStyle: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          onPressed: _resendVerification,
          child: const Text('Resend Verification'),
        ),
      ],
    );
  }
}