import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/profile/viewmodels/badges_view_model.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:auri_sign/features/profile/presentation/widgets/badge_display_helper.dart';
import 'package:auri_sign/core/routes/app_router.dart';

class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  // Status filter: 'all', 'earned', 'locked'
  String _selectedStatus = 'all';

  // Category filter: 'all', 'streak', 'track', 'milestone'
  String _selectedCategory = 'all';

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userVM = context.read<UserViewModel>();
      final userId = userVM.user?.id;
      if (userId != null) {
        context.read<BadgesViewModel>().fetchUserProgress(userId);
      }
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      final months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return "N/A";
    }
  }

  List<Map<String, dynamic>> _getFilteredBadges(List<Map<String, dynamic>> badges) {
    return badges.where((badge) {
      final isEarned = badge['isEarned'] == true;
      final categoryType = (badge['categoryType'] ?? '').toString().toLowerCase();
      final name = (badge['name'] ?? '').toString().toLowerCase();
      final desc = (badge['description'] ?? badge['desc'] ?? '').toString().toLowerCase();
      final criteria = (badge['criteria'] ?? '').toString().toLowerCase();

      // Status filter
      if (_selectedStatus == 'earned' && !isEarned) return false;
      if (_selectedStatus == 'locked' && isEarned) return false;

      // Category filter
      if (_selectedCategory != 'all' && categoryType != _selectedCategory) {
        return false;
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final matches = name.contains(_searchQuery) ||
            desc.contains(_searchQuery) ||
            criteria.contains(_searchQuery);
        if (!matches) return false;
      }

      return true;
    }).toList();
  }

  void _showBadgeDetailModal(BuildContext context, Map<String, dynamic> badge) {
    final badgeId = (badge['badgeId'] ?? badge['id'] ?? '').toString();
    final name = (badge['name'] ?? 'Badge').toString();
    final category = (badge['category'] ?? 'Milestone').toString();
    final description = (badge['description'] ?? badge['desc'] ?? '').toString();
    final criteria = (badge['criteria'] ?? 'Complete requirements to unlock.').toString();
    final isEarned = badge['isEarned'] == true;
    final unlockedAt = badge['unlockedAt'];

    bool isPreviewFullColor = false;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Header: Category Tag on left, Close button on right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isEarned ? Icons.check_circle_outline : Icons.lock_outline,
                                size: 13.sp,
                                color: const Color(0xFF475569),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF475569),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(dialogContext),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.all(4.r),
                            child: Icon(
                              Icons.close,
                              size: 20.sp,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Badge Artwork with subtle background glow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140.r,
                          height: 140.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF8FAFC),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100.r,
                          height: 100.r,
                          child: BadgeDisplayHelper.getBadgeWidget(
                            badgeId,
                            badgeName: name,
                            isGreyscale: !isEarned && !isPreviewFullColor,
                          ),
                        ),
                        if (!isEarned)
                          Positioned(
                            bottom: 12.h,
                            right: 18.w,
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F172A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // Toggle button to preview full-color artwork if locked
                    if (!isEarned)
                      TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            isPreviewFullColor = !isPreviewFullColor;
                          });
                        },
                        icon: Icon(
                          isPreviewFullColor
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 15.sp,
                          color: const Color(0xFF2563EB),
                        ),
                        label: Text(
                          isPreviewFullColor
                              ? "Preview grayscale artwork"
                              : "Preview full-color artwork",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                            fontFamily: 'Inter',
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),

                    SizedBox(height: 14.h),

                    // Badge Title
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                        fontFamily: 'Inter',
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // Badge Description
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                        fontFamily: 'Inter',
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // Status Pill
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isEarned ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEarned ? Icons.check_circle : Icons.lock,
                            size: 13.sp,
                            color: isEarned ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            isEarned
                                ? (unlockedAt != null
                                    ? "Achieved on ${formatDate(unlockedAt)}"
                                    : "Achieved")
                                : "Not Achieved Yet",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: isEarned ? const Color(0xFF15803D) : const Color(0xFF475569),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // How to Unlock Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF6FF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.track_changes,
                              size: 16.sp,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "How to Unlock",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  criteria,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF64748B),
                                    fontFamily: 'Inter',
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 22.h),

                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              AppRouter.navTabIndex.value = 0;
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Start Learning",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 15.sp),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F5F9),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                          ),
                          child: Text(
                            "Close",
                            style: TextStyle(
                              color: const Color(0xFF475569),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BadgesViewModel>();
    final filteredBadges = _getFilteredBadges(vm.allBadges);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Badges Showcase",
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
      ),
      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            )
          : RefreshIndicator(
              color: const Color(0xFF2563EB),
              onRefresh: () async {
                final userVM = context.read<UserViewModel>();
                final userId = userVM.user?.id;
                if (userId != null) {
                  await context.read<BadgesViewModel>().fetchUserProgress(userId);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 0. Top Stat Cards (Badges Earned & Total Points)
                    _buildTopStatCards(vm),
                    SizedBox(height: 16.h),

                    // 1. Overall Collection Card
                    _buildOverallCollectionCard(vm),
                    SizedBox(height: 16.h),

                    // 2. Filters & Search Section Card
                    _buildFiltersAndSearchCard(vm),
                    SizedBox(height: 16.h),

                    // 3. Badges List
                    if (filteredBadges.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredBadges.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final badge = filteredBadges[index];
                          return _buildBadgeCard(badge);
                        },
                      ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
    );
  }

  // 0. Top Stat Cards (Badges Earned & Total Points)
  Widget _buildTopStatCards(BadgesViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Badges Earned",
            "${vm.earnedCount}",
            Icons.workspace_premium,
            const Color(0xFFFFB800),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: _buildStatCard(
            "Total Points",
            vm.totalPoints.toInt().toString(),
            Icons.star,
            const Color(0xFF1E74FD),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 34.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  // 1. Overall Collection Card (matching web header)
  Widget _buildOverallCollectionCard(BadgesViewModel vm) {
    final unlockedPercent = vm.unlockedPercent;
    final percentText = "${(unlockedPercent * 100).round()}%";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: "Overall Collection (1 of 11 Unlocked)" & "9%"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Overall Collection",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "(${vm.earnedCount} of ${vm.totalCount} Unlocked)",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF64748B),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  percentText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: unlockedPercent,
              minHeight: 8.h,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            ),
          ),

          SizedBox(height: 12.h),

          // Tip with Lightbulb
          Row(
            children: [
              const Text("💡", style: TextStyle(fontSize: 14)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  "Click any badge to maximize and preview unlock requirements!",
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF64748B),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Filters & Search Section Card
  Widget _buildFiltersAndSearchCard(BadgesViewModel vm) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Tabs: All, Earned, Locked
          Row(
            children: [
              _buildStatusPill("All (${vm.totalCount})", 'all'),
              SizedBox(width: 8.w),
              _buildStatusPill("Earned (${vm.earnedCount})", 'earned'),
              SizedBox(width: 8.w),
              _buildStatusPill("Locked (${vm.lockedCount})", 'locked'),
            ],
          ),

          SizedBox(height: 12.h),

          // Search Field
          Container(
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _searchController,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontSize: 13.sp, fontFamily: 'Inter'),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search badges...",
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13.sp,
                  fontFamily: 'Inter',
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xFF94A3B8),
                  size: 18.sp,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 16.sp, color: const Color(0xFF94A3B8)),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),

          SizedBox(height: 12.h),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          SizedBox(height: 12.h),

          // Category Chips Row (Horizontal Scroll)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip("All Types", 'all'),
                SizedBox(width: 8.w),
                _buildCategoryChip("🔥 Streak Milestones", 'streak'),
                SizedBox(width: 8.w),
                _buildCategoryChip("🎓 Course Tracks", 'track'),
                SizedBox(width: 8.w),
                _buildCategoryChip("🏆 Platform Milestones", 'milestone'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String label, String value) {
    final isSelected = _selectedStatus == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = value;
        });
      },
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF334155),
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = _selectedCategory == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = value;
        });
      },
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF475569),
            fontSize: 11.5.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  // 3. Individual Badge Card (Mirrors card in screenshot 2)
  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    final badgeId = (badge['badgeId'] ?? badge['id'] ?? '').toString();
    final name = (badge['name'] ?? 'Badge').toString();
    final category = (badge['category'] ?? 'Milestone').toString();
    final description = (badge['description'] ?? badge['desc'] ?? '').toString();
    final criteria = (badge['criteria'] ?? '').toString();
    final isEarned = badge['isEarned'] == true;

    return InkWell(
      onTap: () => _showBadgeDetailModal(context, badge),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Category tag and Maximize icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_full,
                  size: 15.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Middle Content: Avatar + Title & Description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge Icon with Lock Overlay if locked
                Stack(
                  children: [
                    Container(
                      width: 54.r,
                      height: 54.r,
                      alignment: Alignment.center,
                      child: BadgeDisplayHelper.getBadgeWidget(
                        badgeId,
                        badgeName: name,
                        isGreyscale: !isEarned,
                      ),
                    ),
                    if (!isEarned)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F172A),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 14.w),

                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF64748B),
                          fontFamily: 'Inter',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Bottom Row: Criteria preview and Status Pill (Locked / Earned)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    criteria,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF64748B),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isEarned ? const Color(0xFF10B981) : const Color(0xFF475569),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isEarned ? Icons.check : Icons.lock,
                        color: Colors.white,
                        size: 11.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isEarned ? "Earned" : "Locked",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48.sp,
            color: const Color(0xFF94A3B8),
          ),
          SizedBox(height: 12.h),
          Text(
            "No Badges Found",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Try changing your search term or filter options.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
