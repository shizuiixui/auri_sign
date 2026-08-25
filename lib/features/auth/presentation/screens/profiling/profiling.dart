import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auri_sign/core/widgets/button.dart';
import 'package:auri_sign/core/widgets/loading_indicator.dart';
import 'package:auri_sign/features/auth/presentation/screens/signup.dart';

class ProfilingScreen extends StatefulWidget {
  const ProfilingScreen({super.key});

  @override
  State<ProfilingScreen> createState() => _ProfilingScreenState();
}

class _ProfilingScreenState extends State<ProfilingScreen> {
  bool _isLoading = false;
  int _currentPage = 0;
  final PageController _controller = PageController();
  final Map<String, int> _selectedAnswers = {};

  List<Map<String, dynamic>> get _profilingData {
    bool isChild = _selectedAnswers['age_group'] == 0;

    return [
      {
        "id": "age_group",
        "type": "question",
        "question": "Who is learning today?",
        "options": [
          {
            "text": "A Child",
            "subtitle":
                "(12 and below) Fun, colorful lessons and cartoon-based videos",
            "icon": Icons.child_care,
          },
          {
            "text": "A Teen or Adult",
            "subtitle":
                "(13 and above) Practical lessons and real-world videos",
            "icon": Icons.person,
          },
        ],
      },
      if (isChild)
        {
          "id": "parent_info",
          "type": "info",
          "text":
              "The following questions should be answered with help from a parent or guardian. Please ask a parent or guardian to help you along the way.",
        },
      {
        "id": "motivation",
        "type": "question",
        "question": "Why do you want to learn Filipino Sign Language (FSL)?",
        "options": [
          {
            "text": "Curiosity or Interest",
            "image": "assets/images/profiling/1st_page/lightbulb.png",
          },
          {
            "text": "For Inclusivity",
            "image": "assets/images/profiling/1st_page/hands.png",
          },
          {
            "text": "I am Deaf or HoH",
            "image": "assets/images/profiling/1st_page/ear.png",
          },
          {
            "text": "For Family",
            "image": "assets/images/profiling/1st_page/family.png",
          },
          {
            "text": "For Education",
            "image": "assets/images/profiling/1st_page/book.png",
          },
        ],
      },
      {
        "id": "communication",
        "type": "question",
        "question":
            "Are you learning FSL to communicate with someone you know?",
        "options": [
          {
            "text": "Yes, a family member",
            "image": "assets/images/profiling/2nd_page/house.png",
          },
          {
            "text": "Yes, a friend",
            "image": "assets/images/profiling/1st_page/hands.png",
          },
          {
            "text": "Not yet, but I want to",
            "image": "assets/images/profiling/1st_page/magnifying_glass.png",
          },
          {
            "text": "No, I am just learning",
            "image": "assets/images/profiling/1st_page/book.png",
          },
        ],
      },
      if (!isChild)
        {
          "id": "time",
          "type": "question",
          "question": "How much time can you spend per day?",
          "options": [
            {
              "text": "5 mins",
              "image": "assets/images/profiling/clock/5mins_clock.png",
            },
            {
              "text": "10 mins",
              "image": "assets/images/profiling/clock/10mins_clock.png",
            },
            {
              "text": "15 mins",
              "image": "assets/images/profiling/clock/15mins_clock.png",
            },
            {
              "text": "More than 20 mins",
              "image": "assets/images/profiling/clock/20mins_clock.png",
            },
          ],
        },
    ];
  }

  Future<void> _handleNext() async {
    final currentData = _profilingData;

    if (_currentPage < currentData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      bool isChild = _selectedAnswers['age_group'] == 0;
      int learnerType = (_selectedAnswers['age_group'] ?? 0) + 1;
      int motivation = (_selectedAnswers['motivation'] ?? 0) + 1;
      int communication = (_selectedAnswers['communication'] ?? 0) + 1;
      int? dailyTime = isChild ? null : (_selectedAnswers['time'] ?? 0) + 1;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignupForm(
            learnerType: learnerType,
            motivation: motivation,
            communicationContext: communication,
            dailyTime: dailyTime,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _profilingData;

    bool isInfoPage = currentData[_currentPage]['type'] == 'info';
    String currentId = currentData[_currentPage]['id'];
    bool canProceed = isInfoPage || _selectedAnswers.containsKey(currentId);

    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_currentPage > 0) {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / currentData.length,
                      color: const Color(0xFFE9B63B),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "${_currentPage + 1}/${currentData.length}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                itemCount: currentData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  if (currentData[index]['type'] == 'info') {
                    return _buildInfoPage(currentData[index]['text']);
                  } else {
                    return _buildQuestionPage(
                      currentData[index]['id'],
                      currentData[index]['question'],
                      currentData[index]['options'],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: _isLoading
                    ? const LoadingIndicator()
                    : Opacity(
                        opacity: canProceed ? 1.0 : 0.5,
                        child: AbsorbPointer(
                          absorbing: !canProceed,
                          child: Button(
                            text: _currentPage == currentData.length - 1
                                ? "Finish"
                                : "Next",
                            onPressed: _handleNext,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPage(
    String pageId,
    String question,
    List<dynamic> options,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            question,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.h),
          ...options.asMap().entries.map((entry) {
            int optionIndex = entry.key;
            Map<String, dynamic> optionData = entry.value;
            String optionText = optionData['text'];

            bool isSelected = _selectedAnswers[pageId] == optionIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAnswers[pageId] = optionIndex;
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15.h),
                padding: EdgeInsets.all(15.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFE9B63B)
                        : Colors.grey.shade300,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFE9B63B).withOpacity(0.1),
                            blurRadius: 4.r,
                            offset: Offset(0, 4.h),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    if (optionData.containsKey('image'))
                      Image.asset(
                        optionData['image'],
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.contain,
                      )
                    else if (optionData.containsKey('icon'))
                      Icon(
                        optionData['icon'],
                        size: 30.w,
                        color: const Color(0xFFE9B63B),
                      ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          if (optionData.containsKey('subtitle')) ...[
                            SizedBox(height: 4.h),
                            Text(
                              optionData['subtitle'],
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoPage(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, color: Colors.black87, height: 1.5),
        ),
      ),
    );
  }
}
