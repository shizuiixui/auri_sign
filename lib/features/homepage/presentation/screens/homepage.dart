import 'package:auri_sign/core/widgets/bottom_nav_bar.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '/features/homepage/presentation/widgets/homepage_helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  double _currentPage = 0;

  final List<String> imgList = [
    "assets/images/homepage_FSL_img/common_words_FSL.png",
    "assets/images/homepage_FSL_img/letter_A_FSL.png",
    "assets/images/homepage_FSL_img/number_1_FSL.png",
  ];

  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && mounted) {
        context.read<UserViewModel>().fetchUser(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final user = userVM.user;

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      body: userVM.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            )
          : CustomScrollView(
              slivers: [
                // Header Widget
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      child: HomeHeader(
                        firstName: user?.firstName ?? 'Guest',
                        profilePicture: user?.profilePicture,
                      ),
                    ),
                  ),
                ),

                // Carousel Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        child: Text(
                          "Continue Lessons",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: imgList.length,
                          itemBuilder: (context, index) {
                            // Stack Animation Logic
                            double relativePosition = index - _currentPage;
                            return Transform(
                              transform: Matrix4.identity()
                                ..translate(relativePosition * -20.0)
                                ..scale(1 - (relativePosition.abs() * 0.1)),
                              child: Opacity(
                                opacity: (1 - (relativePosition.abs() * 0.3))
                                    .clamp(0.0, 1.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: ContinueLessonCard(
                                    title: ["Common Words", "Alphabets", "Numbers"][index],
                                    progress: 0,
                                    color: const Color(0xFFE9B63B),
                                    imagePath: imgList[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Pagination Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imgList.length, (index) {
                          bool isActive = _currentPage.round() == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: isActive ? 20 : 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF3B82F6)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Daily Tracker Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                        child: Text(
                          "Daily Tracker",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // Horizontal Scrollable List
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            // Monday to Sunday Tracker Items
                            const DailyTrackerItem(
                              day: "Mon",
                              isCompleted: false,
                            ),
                            const SizedBox(width: 12),
                            const DailyTrackerItem(
                              day: "Tue",
                              isCompleted: false,
                            ),
                            const SizedBox(width: 12),
                            const DailyTrackerItem(
                              day: "Wed",
                              isCompleted: false,
                            ),
                            const SizedBox(width: 12),
                            const DailyTrackerItem(
                              day: "Thu",
                              isCompleted: false,
                            ),
                            const SizedBox(width: 12),
                            const DailyTrackerItem(
                              day: "Fri",
                              isCompleted: false,
                            ),
                            const SizedBox(width: 12),
                            const DailyTrackerItem(
                              day: "Sat",
                              isCompleted: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Vertical List (Category Sections)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      CategorySectionCard(
                        title: "Sign Language of the Day",
                        color: const Color(0xFFE9B63B),
                        imagePath: imgList[1],
                      ),
                      const SizedBox(height: 20),
                      CategorySectionCard(
                        title: "Alphabets",
                        color: const Color(0xFF3B82F6),
                        imagePath: imgList[1],
                        bigDisplayChar: "A",
                      ),
                      const SizedBox(height: 20),
                      CategorySectionCard(
                        title: "Numbers",
                        color: const Color(0xFF10B981),
                        imagePath: imgList[2],
                        bigDisplayChar: "1",
                      ),
                      const SizedBox(height: 20),
                      CategorySectionCard(
                        title: "Common Words",
                        color: const Color(0xFFEF4444),
                        imagePath: imgList[0],
                        bigDisplayIcon: Icons.favorite,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
