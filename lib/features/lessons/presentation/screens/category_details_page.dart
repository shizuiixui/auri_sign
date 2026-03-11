import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../lessons/presentation/viewmodels/category_view_model.dart';
import '../../../lessons/presentation/screens/lesson_execution_screen.dart';
import '../widgets/category_helper.dart';
import '/features/auth/viewmodels/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String title; 
  final String
  apiCategoryName;
  final String
  webCategorySlug;
  final String description; 

  const CategoryDetailsPage({
    super.key,
    required this.title,
    required this.apiCategoryName,
    required this.webCategorySlug,
    required this.description,
  });

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🔄 DYNAMIC: Fetches progress based on whatever category was passed in
      context.read<CategoryViewModel>().fetchCategoryProgress(
        widget.apiCategoryName,
      );
    });
  }

  void _navigateToLesson(String lessonId) async {
    String targetId = lessonId;
    if (targetId == "alphabet_1") {
      targetId = "lesson-a-d"; // Keep your specific alphabet fallback
    }

    String myToken = context.read<UserViewModel>().user?.token ?? "";
    if (myToken.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      myToken = prefs.getString('auth_token') ?? "";
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonExecutionScreen(
          lessonId: targetId,
          category: widget
              .webCategorySlug, // 🔄 DYNAMIC: Uses the right React URL slug
          userToken: myToken,
        ),
      ),
    );

    if (mounted) {
      // Refresh the specific category when returning
      context.read<CategoryViewModel>().fetchCategoryProgress(
        widget.apiCategoryName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryViewModel>();

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      appBar: AppBar(
        // 🔄 DYNAMIC TITLE
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0XFFF8F8F8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.w),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFE9B63B)),
              )
            : vm.errorMessage != null
            ? _buildErrorState(vm.errorMessage!)
            : _buildLessonList(vm),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            "Error: $error",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context
                .read<CategoryViewModel>()
                .fetchCategoryProgress(widget.apiCategoryName),
            child: Text("Retry", style: TextStyle(fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList(CategoryViewModel vm) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 🔄 DYNAMIC DESCRIPTION
            CategoryHeader(title: widget.description),
            SizedBox(height: 18.h),
            if (vm.categoryData != null &&
                vm.categoryData!.lessonProgress.isNotEmpty)
              ...vm.categoryData!.lessonProgress.map((lesson) {
                LessonStatus uiStatus;
                if (lesson.status == 'completed') {
                  uiStatus = LessonStatus.completed;
                } else if (lesson.isUnlocked) {
                  uiStatus = LessonStatus.current;
                } else {
                  uiStatus = LessonStatus.locked;
                }

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Category(
                    title: lesson.title,
                    description: "Score: ${lesson.score}%",
                    status: uiStatus,
                    onTap: lesson.isUnlocked
                        ? () => _navigateToLesson(lesson.lessonId)
                        : () {},
                  ),
                );
              })
            else
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text(
                  "No lessons found for this category.",
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
