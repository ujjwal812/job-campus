import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../local_Store/local_store.dart';
import 'forgot_pass_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  // Login Mode: 0 for Email, 1 for Mobile Number
  int _selectedLoginMode = 0;

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_selectedLoginMode == 1 && !_otpSent) {
      // Send OTP flow
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _otpSent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your mobile number.'),
            backgroundColor: AppTheme.darkTeal,
          ),
        );
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;

      final email = _selectedLoginMode == 0
          ? _emailController.text.trim()
          : _phoneController.text.trim();

      await LocalStore.instance.setIsLoggedIn(true);
      await LocalStore.instance.saveUserData(
        id: 'user_1',
        name: email.contains('@') ? email.split('@').first : 'User $email',
        email: email,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    });
  }

  void _googleLogin() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    await LocalStore.instance.setIsLoggedIn(true);
    await LocalStore.instance.saveUserData(
      id: 'google_user_1',
      name: 'Job Seeker',
      email: 'user@jobcampus.com',
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPassScreen(),
      ),
    );
  }

  void _createAccount() {
    Navigator.pushNamed(context, AppRoutes.createAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackgroundGradient(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.glassDecoration(
                    opacity: 0.18,
                    borderOpacity: 0.28,
                    radius: 28,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App logo
                        Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.softMintTeal.withValues(alpha: 0.25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.business_center_rounded,
                              size: 44,
                              color: AppTheme.lightIceTeal,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Center(
                          child: Text(
                            'JobCampus',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightIceTeal,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Sign in to explore campus placements & job opportunities.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Mode Selector (Email vs Mobile Number)
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedLoginMode = 0;
                                      _otpSent = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: _selectedLoginMode == 0
                                          ? AppTheme.darkTeal
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Email Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: _selectedLoginMode == 0
                                            ? Colors.white
                                            : Colors.white60,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedLoginMode = 1;
                                      _otpSent = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: _selectedLoginMode == 1
                                          ? AppTheme.darkTeal
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Mobile No.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: _selectedLoginMode == 1
                                            ? Colors.white
                                            : Colors.white60,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // EMAIL MODE
                        if (_selectedLoginMode == 0) ...[
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hint: 'Enter your email',
                              icon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(email)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _login(),
                            decoration: _inputDecoration(
                              hint: 'Enter your password',
                              icon: Icons.lock_outline_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],

                        // MOBILE MODE
                        if (_selectedLoginMode == 1) ...[
                          const Text(
                            'Mobile Number',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: _inputDecoration(
                              hint: 'Enter 10-digit mobile number',
                              icon: Icons.phone_android_rounded,
                              prefixWidget: Container(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 10),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppTheme.lightIceTeal,
                                  ),
                                ),
                              ),
                            ).copyWith(counterText: ''),
                            validator: (value) {
                              final phone = value?.trim() ?? '';
                              if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone)) {
                                return 'Enter a valid 10-digit mobile number';
                              }
                              return null;
                            },
                          ),
                          if (_otpSent) ...[
                            const SizedBox(height: 18),
                            const Text(
                              'Enter OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _otpController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              onFieldSubmitted: (_) => _login(),
                              decoration: _inputDecoration(
                                hint: 'Enter 6-digit OTP',
                                icon: Icons.pin_outlined,
                              ).copyWith(counterText: ''),
                              validator: (value) {
                                final otp = value?.trim() ?? '';
                                if (otp.length != 6) {
                                  return 'Enter valid 6-digit OTP';
                                }
                                return null;
                              },
                            ),
                          ],
                        ],

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            SizedBox(
                              height: 38,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppTheme.softMintTeal,
                                    checkColor: AppTheme.deepTeal,
                                    side: const BorderSide(color: Colors.white60),
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (_selectedLoginMode == 0)
                              TextButton(
                                onPressed: _forgotPassword,
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppTheme.lightIceTeal,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.vibrantTeal,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedLoginMode == 1 && !_otpSent
                                            ? 'Send OTP'
                                            : 'Login',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_rounded,
                                          size: 18),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR CONTINUE WITH',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.60),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Google Sign In
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _googleLogin,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.10),
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GoogleLogoWidget(size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Create Account Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _createAccount,
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: AppTheme.lightIceTeal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? prefixWidget,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white54,
        fontSize: 13,
      ),
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 14),
          Icon(
            icon,
            color: AppTheme.lightIceTeal,
            size: 20,
          ),
          if (prefixWidget != null) prefixWidget,
        ],
      ),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.20),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.20),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.20),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppTheme.softMintTeal,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

// =============================================================================
// MODULAR GOOGLE LOGO WIDGET
// =============================================================================

class GoogleLogoWidget extends StatelessWidget {
  final double size;

  const GoogleLogoWidget({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = w * 0.42;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Red Arc (Top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -2.35, 1.57, false, paint);

    // Yellow Arc (Bottom-Left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 2.35, 1.57, false, paint);

    // Green Arc (Bottom-Right)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 0.78, 1.57, false, paint);

    // Blue Arc (Right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.78, 1.57, false, paint);

    // Blue Horizontal Bar
    final fillPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(w * 0.45, h * 0.39, w * 0.42, h * 0.22),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
