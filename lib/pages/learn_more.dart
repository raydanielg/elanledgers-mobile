import 'package:flutter/material.dart';
import 'package:duka_app/widgets/image_background.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({Key? key}) : super(key: key);

  @override
  State<LearnMorePage> createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ImageBackground(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF800000),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Elan Ledgers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF800000),
                        const Color(0xFF600000),
                        const Color(0xFF400000),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.business,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tagline
                      _buildAnimatedCard(
                        delay: 0.1,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF800000).withOpacity(0.1),
                                const Color(0xFF800000).withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF800000).withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.lightbulb_outline,
                                size: 40,
                                color: Color(0xFF800000),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Your Smart Business Manager',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF800000),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Empowering businesses across Africa with intelligent digital solutions',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // What is Elan Ledgers
                      _buildAnimatedCard(
                        delay: 0.2,
                        child: _buildSection(
                          icon: Icons.info_outline,
                          title: 'What is Elan Ledgers?',
                          content:
                              'Elan Ledgers is a comprehensive business management platform designed specifically for SMEs in Africa. We provide digital tools for inventory management, sales tracking, purchase orders, customer management, and financial analytics - all in one powerful mobile application.',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Who We Are
                      _buildAnimatedCard(
                        delay: 0.3,
                        child: _buildSection(
                          icon: Icons.people_outline,
                          title: 'Who We Are',
                          content:
                              'We are a team of passionate technologists, business experts, and innovators dedicated to transforming how African businesses operate. Our mission is to democratize access to enterprise-grade business tools for every entrepreneur.',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Features Grid
                      _buildAnimatedCard(
                        delay: 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.apps,
                                  color: Color(0xFF800000),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Key Features',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildFeatureGrid(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // How It Works
                      _buildAnimatedCard(
                        delay: 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.play_circle_outline,
                                  color: Color(0xFF800000),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'How It Works',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildHowItWorks(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Contact Section
                      _buildAnimatedCard(
                        delay: 0.6,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF800000),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF800000).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.contact_mail,
                                size: 40,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Get In Touch',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildContactItem(
                                icon: Icons.email,
                                text: 'support@elanledgers.com',
                              ),
                              const SizedBox(height: 8),
                              _buildContactItem(
                                icon: Icons.phone,
                                text: '+255 700 123 456',
                              ),
                              const SizedBox(height: 8),
                              _buildContactItem(
                                icon: Icons.location_on,
                                text: 'Dar es Salaam, Tanzania',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Back Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800000),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required double delay,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, _) {
        final value = (_scrollController.value - delay).clamp(0.0, 1.0);
        final offset = (1 - value) * 50;
        return Transform.translate(
          offset: Offset(0, offset),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF800000).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF800000),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': Icons.inventory_2, 'title': 'Inventory', 'desc': 'Track stocks'},
      {'icon': Icons.point_of_sale, 'title': 'Sales', 'desc': 'Manage orders'},
      {'icon': Icons.shopping_cart, 'title': 'Purchases', 'desc': 'Buy stocks'},
      {'icon': Icons.people, 'title': 'Customers', 'desc': 'CRM tools'},
      {'icon': Icons.bar_chart, 'title': 'Analytics', 'desc': 'Insights'},
      {'icon': Icons.receipt_long, 'title': 'Invoices', 'desc': 'Billing'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                features[index]['icon'] as IconData,
                color: const Color(0xFF800000),
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                features[index]['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF800000),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                features[index]['desc'] as String,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {
        'number': '1',
        'title': 'Register',
        'desc': 'Create your account in seconds',
      },
      {
        'number': '2',
        'title': 'Setup',
        'desc': 'Add your products & customers',
      },
      {
        'number': '3',
        'title': 'Operate',
        'desc': 'Start managing your business',
      },
      {
        'number': '4',
        'title': 'Grow',
        'desc': 'Analyze & expand with insights',
      },
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF800000),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF800000).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    step['number']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF800000),
                        ),
                      ),
                      Text(
                        step['desc']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index < steps.length - 1)
                Container(
                  margin: const EdgeInsets.only(left: 19),
                  width: 2,
                  height: 20,
                  color: const Color(0xFF800000).withOpacity(0.3),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
