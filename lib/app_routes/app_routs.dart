import 'package:flutter/material.dart';
import '../Splash/splash_screen.dart';
import '../Splash/onboarding_screen.dart';
import '../Splash/logIn_screen.dart';
import '../Splash/create_account_screen.dart';
import '../Splash/forgot_pass_screen.dart';
import '../home/main_navigation_screen.dart';
import '../screen/explore_screen.dart';
import '../screen/manage_applications_screen.dart';
import '../Profile/profile_screen.dart';
import '../Profile/edit_personal_detail_scr.dart';
import '../Profile/help_support_scr.dart';
import '../Job_apply/apply_job_screen.dart';
import '../features/notification_screen.dart';
import '../features/view_details_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String createAccount = '/create_account';
  static const String forgotPassword = '/forgot_password';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String profile = '/profile';
  static const String editPersonalDetails = '/edit_personal_details';
  static const String helpSupport = '/help_support';
  static const String applyJob = '/apply_job';
  static const String notifications = '/notifications';
  static const String jobDetails = '/job_details';
  static const String manageApplications = '/manage_applications';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LogInScreen(),
        createAccount: (context) => const CreateAccountScreen(),
        forgotPassword: (context) => const ForgotPassScreen(),
        home: (context) => const MainNavigationScreen(),
        explore: (context) => const ExploreScreen(),
        profile: (context) => const ProfileScreen(),
        editPersonalDetails: (context) => const EditPersonalDetailScreen(),
        helpSupport: (context) => const HelpSupportScreen(),
        applyJob: (context) => const ApplyJobScreen(),
        notifications: (context) => const NotificationScreen(),
        jobDetails: (context) => const ViewDetailsScreen(),
        manageApplications: (context) => const ManageApplicationsScreen(),
      };
}
