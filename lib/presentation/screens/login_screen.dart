import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _loginButtonController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isProcessingLogin = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isProcessingLogin = true;
    });

    try {
      await HapticFeedback.lightImpact();
      _loginButtonController.forward();
      await Future.delayed(const Duration(seconds: 1));
      // Simulate authentication
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    } finally {
      _loginButtonController.reverse();
      setState(() {
        _isProcessingLogin = false;
      });
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
                      'Admin Login',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(128),
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
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withAlpha(128),
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          activeColor: AppTheme.darkTheme.primaryColor,
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                          ),
                        ),
                        const Spacer(),
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
                            // Navigate to password recovery screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PasswordRecoveryScreen(),
                              ),
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
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
                        // Navigate to registration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text('Create Account'),
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

  Widget _buildLoginButton() {
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
      onPressed: _isProcessingLogin ? null : _login,
      child: _isProcessingLogin
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : const Text('Login'),
    );
  }
}