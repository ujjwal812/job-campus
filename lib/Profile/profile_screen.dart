import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../core/app_theams.dart';
import '../local_Store/local_store.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color navy = Color(0xFF12345A);
  static const Color teal = AppTheme.vibrantTeal;

  String name = 'Job Seeker';
  String headline = 'Fresher | Open to Opportunities';
  String email = '';
  String phone = '';
  String location = 'Ranchi, Jharkhand';
  String education = 'BCA Graduate';
  String experience = 'Fresher';

  List<String> skills = [
    'Flutter',
    'Dart',
    'Communication',
  ];

  @override
  void initState() {
    super.initState();
    _loadStoredUserData();
  }

  void _loadStoredUserData() {
    final localStore = LocalStore.instance;
    final storedName = localStore.getUserName();
    final storedEmail = localStore.getUserEmail();
    final storedPhone = localStore.getUserPhone();
    final storedLocation = localStore.getUserLocation();
    final storedEducation = localStore.getUserEducation();
    final storedExperience = localStore.getUserExperience();
    final storedHeadline = localStore.getUserHeadline();
    final storedSkills = localStore.getUserSkills();

    setState(() {
      if (storedName != null && storedName.isNotEmpty) name = storedName;
      if (storedEmail != null && storedEmail.isNotEmpty) email = storedEmail;
      if (storedPhone != null && storedPhone.isNotEmpty) phone = storedPhone;
      if (storedLocation != null && storedLocation.isNotEmpty) location = storedLocation;
      if (storedEducation != null && storedEducation.isNotEmpty) education = storedEducation;
      if (storedExperience != null && storedExperience.isNotEmpty) experience = storedExperience;
      if (storedHeadline != null && storedHeadline.isNotEmpty) headline = storedHeadline;
      if (storedSkills != null && storedSkills.isNotEmpty) skills = storedSkills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: AppTheme.screenBackgroundGradient(isDarkMode: isDark),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(isDark)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildCompletionCard(isDark),
                      const SizedBox(height: 24),

                      _sectionTitle('App Display Mode', isDark),
                      const SizedBox(height: 12),
                      _buildThemeModeCard(isDark),
                      const SizedBox(height: 24),

                      _sectionTitle('Personal Information', isDark),
                      const SizedBox(height: 12),
                      _buildPersonalInformation(isDark),
                      const SizedBox(height: 24),

                      _sectionTitle('Skills & Expertise', isDark),
                      const SizedBox(height: 12),
                      _buildSkillsCard(isDark),
                      const SizedBox(height: 24),

                      _sectionTitle('Career Profile', isDark),
                      const SizedBox(height: 12),
                      _buildHeadlineCard(isDark),
                      const SizedBox(height: 24),

                      _sectionTitle('Resume & Applications', isDark),
                      const SizedBox(height: 12),
                      _buildMenuCard([
                        _menuTile(
                          icon: Icons.description_outlined,
                          title: 'My Resume',
                          subtitle: 'View or upload your resume',
                          onTap: _showResumeDialog,
                          isDark: isDark,
                        ),
                        _menuDivider(isDark),
                        _menuTile(
                          icon: Icons.work_history_outlined,
                          title: 'Applied Jobs',
                          subtitle: 'Track your job applications',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.manageApplications,
                          ),
                          isDark: isDark,
                        ),
                        _menuDivider(isDark),
                        _menuTile(
                          icon: Icons.bookmark_border_rounded,
                          title: 'Saved Jobs',
                          subtitle: 'View jobs you bookmarked',
                          onTap: () => _showMessage(
                            'Open Saved Jobs tab from bottom navigation.',
                          ),
                          isDark: isDark,
                        ),
                      ], isDark),
                      const SizedBox(height: 24),

                      _sectionTitle('Account Settings', isDark),
                      const SizedBox(height: 12),
                      _buildMenuCard([
                        _menuTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          subtitle: 'Manage your alerts',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.notifications,
                          ),
                          isDark: isDark,
                        ),
                        _menuDivider(isDark),
                        _menuTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Privacy & Security',
                          subtitle: 'Manage account security',
                          onTap: () => _showMessage(
                            'Privacy settings are up to date.',
                          ),
                          isDark: isDark,
                        ),
                        _menuDivider(isDark),
                        _menuTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          subtitle: 'Get help with Job Campus',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.helpSupport,
                          ),
                          isDark: isDark,
                        ),
                        _menuDivider(isDark),
                        _menuTile(
                          icon: Icons.logout_rounded,
                          title: 'Log Out',
                          subtitle: 'Sign out of your account',
                          iconColor: Colors.redAccent,
                          titleColor: Colors.redAccent,
                          onTap: _confirmLogout,
                          isDark: isDark,
                        ),
                      ], isDark),
                      const SizedBox(height: 28),

                      Center(
                        child: Column(
                          children: [
                            Text(
                              'JOB CAMPUS',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : navy,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Bridge to Your Career',
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // HEADER

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 27),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF0F2B48), Color(0xFF0B757B)]
              : const [Color(0xFF0A858C), Color(0xFF36B8B7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'My Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _headerAction(
                Icons.settings_outlined,
                _showSettings,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Color(0xFFE5F5F2),
                  child: Icon(
                    Icons.person_rounded,
                    size: 60,
                    color: AppTheme.darkTeal,
                  ),
                ),
              ),
              Material(
                color: AppTheme.vibrantTeal,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _editPersonalDetails,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            headline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _editPersonalDetails,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white60),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  // APP THEME MODE TOGGLE CARD (Compact Modular ON/OFF Switch)

  Widget _buildThemeModeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: _cardDecoration(isDark),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal)
                  .withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
              color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: isDark ? Colors.white : navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isDark ? 'Dark Theme ON (#0B757B)' : 'Light Theme ON (#A5E6E2)',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Modern Animated Compact ON/OFF Switch
          GestureDetector(
            onTap: () {
              final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
              AppTheme.setThemeMode(newMode);
              _showMessage(
                newMode == ThemeMode.dark
                    ? 'Dark Mode Enabled (#0B757B)'
                    : 'Light Mode Enabled (#A5E6E2)',
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: 58,
              height: 32,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? AppTheme.deepTeal : const Color(0xFFCBD5E1),
                border: Border.all(
                  color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? AppTheme.deepTeal : AppTheme.darkTeal)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 280),
                curve: Curves.fastOutSlowIn,
                alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppTheme.lightIceTeal : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    size: 14,
                    color: isDark ? navy : AppTheme.darkTeal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PROFILE COMPLETION

  int _completionPercentage() {
    final fields = [
      name,
      headline,
      email,
      phone,
      location,
      education,
      experience,
    ];

    int completed = fields
        .where((field) => field.trim().isNotEmpty)
        .length;

    if (skills.isNotEmpty) completed++;

    return ((completed / 8) * 100).round();
  }

  Widget _buildCompletionCard(bool isDark) {
    final percentage = _completionPercentage();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: teal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: teal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Strength',
                      style: TextStyle(
                        color: isDark ? Colors.white : navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Build a stronger professional profile',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color(0xFFEAF0F5),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.vibrantTeal),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Complete your details to improve your profile.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ),
              TextButton(
                onPressed: _editPersonalDetails,
                child: Text(
                  'Complete →',
                  style: TextStyle(
                    color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PERSONAL INFORMATION

  Widget _buildPersonalInformation(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        children: [
          _informationRow(
            Icons.email_outlined,
            'Email Address',
            email,
            isDark,
          ),
          _divider(isDark),
          _informationRow(
            Icons.phone_outlined,
            'Phone Number',
            phone,
            isDark,
          ),
          _divider(isDark),
          _informationRow(
            Icons.location_on_outlined,
            'Location',
            location,
            isDark,
          ),
          _divider(isDark),
          _informationRow(
            Icons.school_outlined,
            'Education',
            education,
            isDark,
          ),
          _divider(isDark),
          _informationRow(
            Icons.work_outline_rounded,
            'Experience',
            experience,
            isDark,
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _editPersonalDetails,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit Personal Details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                side: BorderSide(
                  color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: teal.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black45,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? 'Not added yet' : value,
                style: TextStyle(
                  color: isDark ? Colors.white : navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SKILLS

  Widget _buildSkillsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'My Skills',
                  style: TextStyle(
                    color: isDark ? Colors.white : navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: _editSkills,
                icon: Icon(
                  Icons.edit_outlined,
                  color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
                ),
              ),
            ],
          ),
          Text(
            'Highlight your skills to employers',
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black45,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          if (skills.isEmpty)
            Text(
              'Add your skills to complete your profile.',
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black45,
                fontSize: 12,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : const Color(0xFFEAF7F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? Colors.white24 : AppTheme.lightIceTeal,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: isDark ? Colors.white : navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // CAREER HEADLINE

  Widget _buildHeadlineCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: teal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.work_outline_rounded,
              color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Professional Headline',
                  style: TextStyle(
                    color: isDark ? Colors.white : navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  headline.isEmpty ? 'Add a headline' : headline,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _editHeadline,
            icon: Icon(
              Icons.edit_outlined,
              color: isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal,
            ),
          ),
        ],
      ),
    );
  }

  // MENU COMPONENTS

  Widget _buildMenuCard(List<Widget> children, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      decoration: _cardDecoration(isDark),
      child: Column(children: children),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
    Color? titleColor,
  }) {
    final effectiveIconColor =
        iconColor ?? (isDark ? AppTheme.lightIceTeal : AppTheme.darkTeal);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: effectiveIconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: effectiveIconColor, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? (isDark ? Colors.white : navy),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white38 : Colors.black38,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 54,
      color: isDark ? Colors.white12 : const Color(0xFFEAF0F5),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white : navy,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white12 : const Color(0xFFEAF0F5),
      ),
    );
  }

  BoxDecoration _cardDecoration(bool isDark) {
    return AppTheme.glassDecoration();
  }

  // EDIT PERSONAL DETAILS

  Future<void> _editPersonalDetails() async {
    await Navigator.pushNamed(
      context,
      AppRoutes.editPersonalDetails,
    );
    if (!mounted) return;
    _loadStoredUserData();
  }

  // EDIT HEADLINE

  void _editHeadline() {
    final controller = TextEditingController(text: headline);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Professional Headline'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'e.g. BCA Graduate | Flutter Developer',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  headline = controller.text.trim();
                });
                Navigator.pop(dialogContext);
                _showMessage('Headline updated.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // EDIT SKILLS

  void _editSkills() {
    final controller = TextEditingController(
      text: skills.join(', '),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Edit Skills'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Flutter, Dart, SQL',
              helperText: 'Separate skills with commas',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  skills = controller.text
                      .split(',')
                      .map((skill) => skill.trim())
                      .where((skill) => skill.isNotEmpty)
                      .toSet()
                      .toList();
                });
                Navigator.pop(dialogContext);
                _showMessage('Skills updated.');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Skills'),
            ),
          ],
        );
      },
    );
  }

  // SETTINGS

  void _showSettings() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Profile Settings',
                  style: TextStyle(
                    color: navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: teal,
                  ),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _editPersonalDetails();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: teal,
                  ),
                  title: const Text('Notification Settings'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(context, AppRoutes.notifications);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: teal,
                  ),
                  title: const Text('Privacy & Security'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showMessage('Privacy settings are up to date.');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // RESUME

  void _showResumeDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.description_outlined,
            color: teal,
            size: 44,
          ),
          title: const Text('My Resume'),
          content: const Text(
            'Connect a file picker and upload service to '
            'upload, view and manage your resume.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // LOGOUT

  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Log Out?'),
          content: const Text(
            'Are you sure you want to log out of Job Campus?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await LocalStore.instance.logout();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
