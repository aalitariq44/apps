import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLanguageToggle;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onLanguageToggle,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال البريد الإلكتروني' : 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return isArabic ? 'بريد إلكتروني غير صحيح' : 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter your password';
    }
    if (value.length < 6) {
      return isArabic 
          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' 
          : 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: widget.onLanguageToggle,
                      icon: const Icon(Icons.language, color: Colors.white),
                      tooltip: isArabic ? 'اللغة' : 'Language',
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 40),
                            
                            // Logo and Title
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF667eea).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.hotel,
                                      size: 50,
                                      color: Color(0xFF667eea),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    isArabic ? 'حجز الفنادق' : 'Hotel Booking',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isArabic 
                                        ? 'اكتشف أفضل الفنادق حول العالم' 
                                        : 'Discover the best hotels worldwide',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Login Form
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Email Field
                                    TextFormField(
                                      controller: _emailController,
                                      validator: _validateEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                      decoration: InputDecoration(
                                        labelText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                                        hintText: isArabic ? 'أدخل بريدك الإلكتروني' : 'Enter your email',
                                        prefixIcon: const Icon(Icons.email_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Password Field
                                    TextFormField(
                                      controller: _passwordController,
                                      validator: _validatePassword,
                                      obscureText: _obscurePassword,
                                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                      decoration: InputDecoration(
                                        labelText: isArabic ? 'كلمة المرور' : 'Password',
                                        hintText: isArabic ? 'أدخل كلمة المرور' : 'Enter your password',
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Remember Me & Forgot Password
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          activeColor: const Color(0xFF667eea),
                                        ),
                                        Text(
                                          isArabic ? 'تذكرني' : 'Remember me',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            // Handle forgot password
                                          },
                                          child: Text(
                                            isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                                            style: const TextStyle(
                                              color: Color(0xFF667eea),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 30),
                                    
                                    // Login Button
                                    SizedBox(
                                      height: 55,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF667eea),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: _isLoading
                                            ? const CircularProgressIndicator(color: Colors.white)
                                            : Text(
                                                isArabic ? 'تسجيل الدخول' : 'Login',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Sign Up Link
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isArabic ? 'ليس لديك حساب؟ ' : "Don't have an account? ",
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to sign up (for now, just login)
                                            widget.onLoginSuccess();
                                          },
                                          child: Text(
                                            isArabic ? 'إنشاء حساب' : 'Sign Up',
                                            style: const TextStyle(
                                              color: Color(0xFF667eea),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 30),
                                    
                                    // Demo Note
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.blue[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info_outline, color: Colors.blue[600]),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              isArabic 
                                                  ? 'هذا تطبيق عرض تقديمي. يمكنك استخدام أي بريد إلكتروني وكلمة مرور'
                                                  : 'This is a demo app. You can use any email and password',
                                              style: TextStyle(
                                                color: Colors.blue[700],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}
