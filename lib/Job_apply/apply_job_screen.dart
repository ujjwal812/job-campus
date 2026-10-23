import 'package:flutter/material.dart';
import '../app_routes/app_routs.dart';
import '../home/models/job_model.dart';
import '../local_Store/local_store.dart';

class ApplyJobScreen extends StatefulWidget {
  final JobModel? job;

  const ApplyJobScreen({super.key, this.job});

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  static const Color navy = Color(0xFF12345A);
  static const Color teal = Color(0xFF0CA997);
  static const Color background = Color(0xFFF6F8FC);

  int _currentStep = 0;
  bool _isSubmitting = false;
  late JobModel _currentJob;

  // Form Keys & Controllers
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  late TextEditingController _portfolioController;
  late TextEditingController _linkedInController;
  late TextEditingController _coverLetterController;

  late TextEditingController _experienceController;
  late TextEditingController _expectedSalaryController;
  String _noticePeriod = 'Immediate (0-15 days)';

  bool _resumeAttached = true;
  String _resumeFileName = 'Resume_JobSeeker_2025.pdf';

  static const JobModel _defaultJob = JobModel(
    title: 'Flutter App Developer',
    company: 'TechNova Solutions',
    location: 'Ranchi, Jharkhand',
    salary: '₹3–6 LPA',
    type: 'Full-time',
    category: 'Development',
    logoText: 'TN',
    logoColor: 0xFF0A858C,
  );

  @override
  void initState() {
    super.initState();
    _initPreFilledData();
  }

  void _initPreFilledData() {
    final store = LocalStore.instance;

    _nameController = TextEditingController(
      text: store.getUserName() ?? 'Job Seeker',
    );
    _emailController = TextEditingController(
      text: store.getUserEmail() ?? 'seeker@jobcampus.in',
    );
    _phoneController = TextEditingController(
      text: store.getUserPhone() ?? '9876543210',
    );
    _locationController = TextEditingController(
      text: store.getUserLocation() ?? 'Ranchi, Jharkhand',
    );

    _portfolioController = TextEditingController(
      text: 'https://github.com/jobseeker-portfolio',
    );
    _linkedInController = TextEditingController(
      text: 'https://linkedin.com/in/jobseeker',
    );
    _coverLetterController = TextEditingController(
      text:
          'I am passionate about this role and confident that my technical skills match your requirements.',
    );

    _experienceController = TextEditingController(
      text: store.getUserExperience() ?? 'Fresher (0-1 Years)',
    );
    _expectedSalaryController = TextEditingController(
      text: 'As per industry standards',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeJob = ModalRoute.of(context)?.settings.arguments as JobModel?;
    _currentJob = widget.job ?? routeJob ?? _defaultJob;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _portfolioController.dispose();
    _linkedInController.dispose();
    _coverLetterController.dispose();
    _experienceController.dispose();
    _expectedSalaryController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_step1FormKey.currentState!.validate()) return;
    } else if (_currentStep == 1) {
      if (!_resumeAttached) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please attach your resume to continue.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    } else if (_currentStep == 2) {
      if (!_step3FormKey.currentState!.validate()) return;
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitApplication() async {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate API network submission
    await Future.delayed(const Duration(milliseconds: 1600));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    _showSuccessModal();
  }

  void _showSuccessModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: teal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: teal,
                  size: 56,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Application Submitted! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: navy,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your application for ${_currentJob.title} at ${_currentJob.company} has been sent successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apply for Job',
          style: TextStyle(
            color: navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildJobHeaderBanner(),
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: _buildCurrentStepContent(),
              ),
            ),
            _buildBottomNavigationControls(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER BANNER & STEP INDICATOR
  // ---------------------------------------------------------------------------

  Widget _buildJobHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _currentJob.logoText,
              style: const TextStyle(
                color: teal,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentJob.title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_currentJob.company} • ${_currentJob.location}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _currentJob.salary,
              style: const TextStyle(
                color: teal,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Personal', 'Resume', 'Questions', 'Review'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFEFF5FA),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index <= _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor:
                                isActive ? teal : const Color(0xFFCBD5E1),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[index],
                        style: TextStyle(
                          color: isCurrent
                              ? navy
                              : isActive
                                  ? teal
                                  : Colors.black45,
                          fontSize: 11,
                          fontWeight:
                              isCurrent ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index < _currentStep
                          ? teal
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP CONTENT SWITCHER
  // ---------------------------------------------------------------------------

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Personal();
      case 1:
        return _buildStep2Resume();
      case 2:
        return _buildStep3Questions();
      case 3:
        return _buildStep4Review();
      default:
        return const SizedBox();
    }
  }

  // STEP 1: PERSONAL DETAILS
  Widget _buildStep1Personal() {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader('Personal Details', 'Step 1 of 4'),
          const SizedBox(height: 16),
          _inputCard([
            _textField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_rounded,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'Enter your email',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || !v.contains('@')
                  ? 'Enter valid email'
                  : null,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter mobile number',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _locationController,
              label: 'Current Location',
              hint: 'e.g. Ranchi, Jharkhand',
              icon: Icons.location_on_rounded,
            ),
          ]),
        ],
      ),
    );
  }

  // STEP 2: RESUME & PORTFOLIO
  Widget _buildStep2Resume() {
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader('Resume & Links', 'Step 2 of 4'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEAF0F5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Resume / CV',
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Supported formats: PDF, DOC, DOCX (Max 5MB)',
                  style: TextStyle(color: Colors.black45, fontSize: 11),
                ),
                const SizedBox(height: 14),

                if (_resumeAttached)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7F5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: teal.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded,
                            color: Colors.redAccent, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _resumeFileName,
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Attached from Profile',
                                style: TextStyle(
                                  color: teal,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.black45),
                          onPressed: () {
                            setState(() {
                              _resumeAttached = false;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _resumeAttached = true;
                        _resumeFileName = 'Updated_Resume_2025.pdf';
                      });
                    },
                    icon: const Icon(Icons.cloud_upload_rounded, color: teal),
                    label: const Text('Attach PDF Resume'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: teal,
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(color: teal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _inputCard([
            _textField(
              controller: _portfolioController,
              label: 'Portfolio / GitHub Link (Optional)',
              hint: 'https://github.com/username',
              icon: Icons.link_rounded,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _linkedInController,
              label: 'LinkedIn Profile URL (Optional)',
              hint: 'https://linkedin.com/in/username',
              icon: Icons.work_rounded,
            ),
          ]),
        ],
      ),
    );
  }

  // STEP 3: SCREENING QUESTIONS
  Widget _buildStep3Questions() {
    return Form(
      key: _step3FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _stepHeader('Screening Questions', 'Step 3 of 4'),
          const SizedBox(height: 16),
          _inputCard([
            _textField(
              controller: _experienceController,
              label: 'Total Experience',
              hint: 'e.g. Fresher / 2 Years',
              icon: Icons.badge_rounded,
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _expectedSalaryController,
              label: 'Expected CTC / Salary',
              hint: 'e.g. ₹4 LPA or As per industry',
              icon: Icons.payments_rounded,
            ),
            const SizedBox(height: 14),
            const Text(
              'Notice Period',
              style: TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _noticePeriod,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.access_time_rounded, color: teal),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Immediate (0-15 days)',
                  child: Text('Immediate (0-15 days)'),
                ),
                DropdownMenuItem(
                  value: '1 Month',
                  child: Text('1 Month'),
                ),
                DropdownMenuItem(
                  value: '2 Months',
                  child: Text('2 Months'),
                ),
                DropdownMenuItem(
                  value: '3 Months',
                  child: Text('3 Months'),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _noticePeriod = val);
                }
              },
            ),
            const SizedBox(height: 14),
            _textField(
              controller: _coverLetterController,
              label: 'Cover Note / Why hire you?',
              hint: 'Briefly state why you are a great fit for this role...',
              icon: Icons.notes_rounded,
              maxLines: 3,
            ),
          ]),
        ],
      ),
    );
  }

  // STEP 4: REVIEW & SUBMIT
  Widget _buildStep4Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader('Review & Confirm', 'Step 4 of 4'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAF0F5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reviewRow('Applicant Name', _nameController.text),
              _reviewDivider(),
              _reviewRow('Email Address', _emailController.text),
              _reviewDivider(),
              _reviewRow('Phone Number', _phoneController.text),
              _reviewDivider(),
              _reviewRow('Current Location', _locationController.text),
              _reviewDivider(),
              _reviewRow('Resume Attached', _resumeFileName),
              _reviewDivider(),
              _reviewRow('Notice Period', _noticePeriod),
              _reviewDivider(),
              _reviewRow('Expected CTC', _expectedSalaryController.text),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _stepHeader(String title, String stepText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          stepText,
          style: const TextStyle(
            color: teal,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _inputCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAF0F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: navy,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
            prefixIcon: Icon(icon, color: teal, size: 20),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewDivider() {
    return const Divider(height: 12, color: Color(0xFFEAF0F5));
  }

  // BOTTOM BUTTONS
  Widget _buildBottomNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : _currentStep == 3
                      ? _submitApplication
                      : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      _currentStep == 3 ? 'Submit Application 🚀' : 'Next Step →',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
