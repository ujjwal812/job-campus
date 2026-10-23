import 'package:flutter/material.dart';
import '../core/app_theams.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  static const Color navy = Color(0xFF12345A);
  static const Color teal = Color(0xFF0CA997);

  late TabController _tabController;
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  bool _isAgentTyping = false;
  String _searchQuery = '';

  // Chat Messages State
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'isUser': false,
      'sender': 'JobCampus Support',
      'text':
          'Hi there! 👋 Welcome to JobCampus Live Support. How can we assist your career journey today?',
      'time': 'Just now',
    },
  ];

  // FAQ Items
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I apply for a job on JobCampus?',
      'answer':
          'Browse available listings on the Home or Explore screen, tap on a job card to view full details, and click "Apply Now". Make sure your profile details and resume are updated.',
      'category': 'Applications',
    },
    {
      'question': 'How do I update my profile and skills?',
      'answer':
          'Go to "My Profile" tab, tap on "Edit Profile" or the edit pencil icon to update your basic info, education, experience, headline, and skills.',
      'category': 'Profile',
    },
    {
      'question': 'How can I track my submitted job applications?',
      'answer':
          'Open "My Profile" and tap on "Applied Jobs" under Resume & Applications section to view real-time status updates from employers.',
      'category': 'Applications',
    },
    {
      'question': 'Is JobCampus completely free for job seekers?',
      'answer':
          'Yes! JobCampus is 100% free for all students, freshers, and experienced job seekers searching for opportunities.',
      'category': 'General',
    },
    {
      'question': 'How do I change my password or account details?',
      'answer':
          'Go to "My Profile" -> "Account Settings" -> "Privacy & Security" to update your security settings or password.',
      'category': 'Account',
    },
  ];

  final List<String> _quickSuggestions = [
    'How to apply?',
    'Track my application',
    'Update my resume',
    'Talk to support agent',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _searchController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? customText]) {
    final text = customText ?? _chatController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now().format(context);

    setState(() {
      _chatMessages.add({
        'isUser': true,
        'sender': 'You',
        'text': text,
        'time': now,
      });
      _isAgentTyping = true;
    });

    if (customText == null) {
      _chatController.clear();
    }

    _scrollToBottom();

    // Simulate Support Agent / AI Response
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;

      String reply =
          'Thank you for reaching out! Our team is reviewing your query regarding "$text". A live support representative will guide you shortly.';

      final lower = text.toLowerCase();
      if (lower.contains('apply') || lower.contains('how to apply')) {
        reply =
            'To apply for any job, simply open the job details card and click "Apply Now". Ensure your resume is uploaded in your profile!';
      } else if (lower.contains('track') || lower.contains('application')) {
        reply =
            'You can view all your application statuses directly under "My Profile" -> "Applied Jobs".';
      } else if (lower.contains('resume') || lower.contains('profile')) {
        reply =
            'You can edit your personal details, education, skills, and headline anytime in the "My Profile" section.';
      } else if (lower.contains('agent') || lower.contains('human')) {
        reply =
            'Connecting you to a human agent... Agent Priya Sharma has joined the chat. How can Priya assist you?';
      }

      setState(() {
        _isAgentTyping = false;
        _chatMessages.add({
          'isUser': false,
          'sender': 'Priya • JobCampus Agent',
          'text': reply,
          'time': TimeOfDay.now().format(context),
        });
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        final titleColor = isDark ? Colors.white : AppTheme.darkNavy;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? AppTheme.deepTeal : Colors.white,
            elevation: isDark ? 0 : 0.5,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help & Support',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Row(
                  children: [
                    CircleAvatar(
                        radius: 3.5, backgroundColor: Color(0xFF00C853)),
                    SizedBox(width: 5),
                    Text(
                      'Live Chat Online',
                      style: TextStyle(
                        color: Color(0xFF00C853),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: isDark ? AppTheme.deepTeal : Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: isDark ? AppTheme.lightIceTeal : teal,
                  unselectedLabelColor:
                      isDark ? Colors.white60 : Colors.black45,
                  indicatorColor: isDark ? AppTheme.lightIceTeal : teal,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'FAQs'),
                    Tab(text: 'Live Chat 💬'),
                    Tab(text: 'Contact Us'),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            decoration: AppTheme.screenBackgroundGradient(isDarkMode: isDark),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFaqSection(isDark),
                _buildLiveChatSection(isDark),
                _buildContactSection(isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // FAQ & KNOWLEDGE BASE SECTION
  // ===========================================================================

  Widget _buildFaqSection(bool isDark) {
    final filteredFaqs = _faqs.where((faq) {
      final q = faq['question']!.toLowerCase();
      final a = faq['answer']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return query.isEmpty || q.contains(query) || a.contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerCard(isDark),
          const SizedBox(height: 20),

          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
            style: TextStyle(color: isDark ? Colors.white : AppTheme.darkNavy),
            decoration: InputDecoration(
              hintText: 'Search help articles, topics...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black38,
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: isDark ? AppTheme.lightIceTeal : teal,
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : const Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: isDark ? AppTheme.lightIceTeal : teal,
                  width: 1.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),

          Text(
            'Explore Categories',
            style: TextStyle(
              color: isDark ? Colors.white : navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _quickCategoryCard(
                  'Applications',
                  Icons.assignment_turned_in_rounded,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _quickCategoryCard(
                  'Profile & Resume',
                  Icons.person_pin_rounded,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: isDark ? Colors.white : navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),

          if (filteredFaqs.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.glassDecoration(),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 40,
                    color: isDark ? Colors.white54 : Colors.black38,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No articles found for your search',
                    style: TextStyle(
                      color: isDark ? Colors.white : navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: filteredFaqs.map((faq) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: AppTheme.glassDecoration(),
                  child: ExpansionTile(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: teal.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.help_outline_rounded,
                        color: isDark ? AppTheme.lightIceTeal : teal,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      faq['question']!,
                      style: TextStyle(
                        color: isDark ? Colors.white : navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Text(
                          faq['answer']!,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Search FAQs or chat live with our support team 24/7.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    _tabController.animateTo(1);
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('Start Live Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickCategoryCard(String title, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.glassDecoration(),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? AppTheme.lightIceTeal : teal,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : navy,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // LIVE CHAT MODULE
  // ===========================================================================

  Widget _buildLiveChatSection(bool isDark) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : const Color(0xFFEAF7F5),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                color: isDark ? AppTheme.lightIceTeal : teal,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Connected to JobCampus Priority Support',
                  style: TextStyle(
                    color: isDark ? Colors.white : navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Chat Message Stream
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              final msg = _chatMessages[index];
              return _buildChatBubble(msg, isDark);
            },
          ),
        ),

        if (_isAgentTyping)
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: teal),
                ),
                const SizedBox(width: 8),
                Text(
                  'Agent is typing response...',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black45,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

        // Quick Suggestions
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _quickSuggestions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final suggestion = _quickSuggestions[index];
              return ActionChip(
                label: Text(suggestion),
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white,
                labelStyle: TextStyle(
                  color: isDark ? Colors.white : navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: isDark ? AppTheme.lightIceTeal : teal,
                ),
                onPressed: () => _sendMessage(suggestion),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Input Field
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          color: isDark ? AppTheme.deepTeal : Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: TextStyle(color: isDark ? Colors.white : navy),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black38,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : const Color(0xFFF6F8FC),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: teal,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _sendMessage(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> msg, bool isDark) {
    final isUser = msg['isUser'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: teal,
              child: Icon(
                Icons.headset_mic_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  msg['sender'] as String,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? navy
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.18)
                            : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    msg['text'] as String,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : (isDark ? Colors.white : navy),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  msg['time'] as String,
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 16,
              backgroundColor: navy,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // CONTACT US SECTION
  // ===========================================================================

  Widget _buildContactSection(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _contactTile(
            title: 'Call Support',
            subtitle: '+91 1800 123 4567 (Toll-Free)',
            icon: Icons.phone_in_talk_rounded,
            color: const Color(0xFF00C853),
            isDark: isDark,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling JobCampus support line...'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _contactTile(
            title: 'Email Us',
            subtitle: 'support@jobcampus.in',
            icon: Icons.mark_email_read_rounded,
            color: const Color(0xFF2979FF),
            isDark: isDark,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening email client...')),
              );
            },
          ),
          const SizedBox(height: 12),
          _contactTile(
            title: 'Office Address',
            subtitle: 'JobCampus HQ, Tech Hub, Ranchi, Jharkhand 834001',
            icon: Icons.business_rounded,
            color: const Color(0xFFFF9100),
            isDark: isDark,
            onTap: () {},
          ),
          const SizedBox(height: 28),

          Text(
            'Send Feedback or Report Issue',
            style: TextStyle(
              color: isDark ? Colors.white : navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.glassDecoration(),
            child: Column(
              children: [
                TextField(
                  maxLines: 4,
                  style: TextStyle(color: isDark ? Colors.white : navy),
                  decoration: InputDecoration(
                    hintText: 'Describe your issue or suggestions...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black38,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.black.withValues(alpha: 0.2)
                        : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Thank you! Your feedback has been submitted.',
                          ),
                          backgroundColor: teal,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Submit Feedback'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: AppTheme.glassDecoration(),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : navy,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isDark ? Colors.white38 : Colors.black38,
        ),
      ),
    );
  }
}
