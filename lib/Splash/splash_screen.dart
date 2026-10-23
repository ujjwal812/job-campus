import 'dart:async';
import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../local_Store/local_store.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _scheduleNavigation();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
  }

  void _scheduleNavigation() {
    _navigationTimer = Timer(
      const Duration(seconds: 3),
      () async {
        if (!mounted) return;

        final localStore = LocalStore.instance;
        if (!localStore.isOnboardingCompleted()) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
        } else if (!localStore.isLoggedIn()) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      },
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenBackgroundGradient(),
        child: Stack(
          children: [
            const _DecorativeBackground(),
            SafeArea(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LogoSection(),
                          SizedBox(height: 28),
                          _TaglineSection(),
                          SizedBox(height: 45),
                          _LoadingSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 22,
              left: 0,
              right: 0,
              child: _FooterSection(),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MODULAR SUB-WIDGETS
// =============================================================================

class _DecorativeBackground extends StatelessWidget {
  const _DecorativeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -90,
          right: -70,
          child: _buildCircle(210, AppTheme.softMintTeal.withValues(alpha: 0.12)),
        ),
        Positioned(
          bottom: -100,
          left: -80,
          child: _buildCircle(240, AppTheme.darkTeal.withValues(alpha: 0.20)),
        ),
      ],
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/splash_logo.png',
      width: double.infinity,
      height: 250,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/logo.png',
          width: double.infinity,
          height: 250,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const _FallbackLogo();
          },
        );
      },
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: AppTheme.glassDecoration(opacity: 0.20, borderOpacity: 0.30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.school_rounded,
            size: 85,
            color: AppTheme.lightIceTeal,
          ),
          const SizedBox(height: 12),
          const Text(
            'JOB CAMPUS',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 65,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.softMintTeal,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaglineSection extends StatelessWidget {
  const _TaglineSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Your Career Starts Here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightIceTeal,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Discover opportunities. Build your future.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.softMintTeal),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Preparing your journey...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white60,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'LEARN  •  APPLY  •  GROW',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppTheme.lightIceTeal,
        letterSpacing: 2,
      ),
    );
  }
}
