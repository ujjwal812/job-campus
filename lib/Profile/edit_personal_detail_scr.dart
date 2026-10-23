import 'package:flutter/material.dart';
import '../core/app_theams.dart';
import '../local_Store/local_store.dart';

class EditPersonalDetailScreen extends StatefulWidget {
  const EditPersonalDetailScreen({super.key});

  @override
  State<EditPersonalDetailScreen> createState() =>
      _EditPersonalDetailScreenState();
}

class _EditPersonalDetailScreenState extends State<EditPersonalDetailScreen> {
  static const Color navy = Color(0xFF12345A);
  static const Color teal = AppTheme.vibrantTeal;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _educationController;
  late TextEditingController _experienceController;
  late TextEditingController _headlineController;
  late TextEditingController _skillInputController;

  List<String> _skills = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final localStore = LocalStore.instance;

    _nameController = TextEditingController(
      text: localStore.getUserName() ?? 'Job Seeker',
    );
    _emailController = TextEditingController(
      text: localStore.getUserEmail() ?? '',
    );
    _phoneController = TextEditingController(
      text: localStore.getUserPhone() ?? '',
    );
    _locationController = TextEditingController(
      text: localStore.getUserLocation() ?? 'Ranchi, Jharkhand',
    );
    _educationController = TextEditingController(
      text: localStore.getUserEducation() ?? 'BCA Graduate',
    );
    _experienceController = TextEditingController(
      text: localStore.getUserExperience() ?? 'Fresher',
    );
    _headlineController = TextEditingController(
      text: localStore.getUserHeadline() ?? 'Fresher | Open to Opportunities',
    );
    _skillInputController = TextEditingController();

    _skills = localStore.getUserSkills() ?? ['Flutter', 'Dart', 'Communication'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _headlineController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final text = _skillInputController.text.trim();
    if (text.isNotEmpty) {
      if (!_skills.contains(text)) {
        setState(() {
          _skills.add(text);
          _skillInputController.clear();
        });
      } else {
        _skillInputController.clear();
      }
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();
    final education = _educationController.text.trim();
    final experience = _experienceController.text.trim();
    final headline = _headlineController.text.trim();

    await LocalStore.instance.saveFullUserProfile(
      name: name,
      email: email,
      phone: phone,
      location: location,
      education: education,
      experience: experience,
      headline: headline,
      skills: _skills,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personal details updated successfully!'),
        backgroundColor: teal,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        final titleColor = isDark ? Colors.white : navy;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? AppTheme.deepTeal : Colors.white,
            elevation: isDark ? 0 : 0.5,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Edit Personal Details',
              style: TextStyle(
                color: titleColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: false,
          ),
          body: Container(
            decoration: AppTheme.screenBackgroundGradient(isDarkMode: isDark),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(isDark),
                      const SizedBox(height: 24),

                      _sectionHeader('Basic Information', Icons.person_outline, isDark),
                      const SizedBox(height: 14),
                      _buildCardContainer([
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_rounded,
                          isDark: isDark,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'Enter your email address',
                          icon: Icons.email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          isDark: isDark,
                          validator: (val) {
                            if (val != null && val.trim().isNotEmpty) {
                              final emailRegExp = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegExp.hasMatch(val.trim())) {
                                return 'Please enter a valid email address';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: 'Enter your 10-digit mobile number',
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _locationController,
                          label: 'Location / Address',
                          hint: 'e.g. Ranchi, Jharkhand',
                          icon: Icons.location_on_rounded,
                          isDark: isDark,
                        ),
                      ], isDark),
                      const SizedBox(height: 26),

                      _sectionHeader('Education & Career', Icons.work_outline, isDark),
                      const SizedBox(height: 14),
                      _buildCardContainer([
                        _buildTextField(
                          controller: _educationController,
                          label: 'Highest Education',
                          hint: 'e.g. BCA / B.Tech / Higher Secondary',
                          icon: Icons.school_rounded,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _experienceController,
                          label: 'Experience Status',
                          hint: 'e.g. Fresher or 2 Years Experience',
                          icon: Icons.badge_rounded,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _headlineController,
                          label: 'Professional Headline',
                          hint: 'e.g. Flutter Developer | Open to Work',
                          icon: Icons.subtitles_rounded,
                          maxLines: 2,
                          isDark: isDark,
                        ),
                      ], isDark),
                      const SizedBox(height: 26),

                      _sectionHeader('Skills & Expertise', Icons.auto_awesome, isDark),
                      const SizedBox(height: 14),
                      _buildCardContainer([
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _skillInputController,
                                style: TextStyle(
                                  color: isDark ? Colors.white : navy,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Add a skill (e.g. Dart, Communication)',
                                  hintStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black38,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.add_task_rounded,
                                    color: isDark
                                        ? AppTheme.lightIceTeal
                                        : teal,
                                    size: 20,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? Colors.black.withValues(alpha: 0.2)
                                      : const Color(0xFFF6F8FC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onSubmitted: (_) => _addSkill(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              color: teal,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: _addSkill,
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.all(13),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_skills.isEmpty)
                          Text(
                            'No skills added yet. Type a skill and tap +',
                            style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black45,
                              fontSize: 12,
                            ),
                          )
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: _skills.map((skill) {
                              return Container(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 6,
                                  top: 6,
                                  bottom: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : const Color(0xFFEAF7F5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white24
                                        : teal.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      skill,
                                      style: TextStyle(
                                        color: isDark ? Colors.white : navy,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => _removeSkill(skill),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white24
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: isDark ? Colors.white : navy,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ], isDark),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDark ? AppTheme.vibrantTeal : teal,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: teal.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Save Personal Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF0F2B48), Color(0xFF0B757B)]
              : const [navy, Color(0xFF176B79)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.manage_accounts_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Profile Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Keep your information updated to attract better job opportunities.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: isDark ? AppTheme.lightIceTeal : teal, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer(List<Widget> children, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.glassDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white : navy,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : navy,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.black38,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(
              icon,
              color: isDark ? AppTheme.lightIceTeal : teal,
              size: 21,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? AppTheme.lightIceTeal : teal,
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
