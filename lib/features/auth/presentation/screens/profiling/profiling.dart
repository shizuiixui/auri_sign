import 'package:flutter/material.dart';
import 'package:auri_sign/core/widgets/button.dart';
import 'package:auri_sign/core/widgets/loading_indicator.dart';

class ProfilingScreen extends StatefulWidget {
  const ProfilingScreen({super.key});

  @override
  State<ProfilingScreen> createState() => _ProfilingScreenState();
}

class _ProfilingScreenState extends State<ProfilingScreen> {
  bool _isLoading = false;
  int _currentPage = 0;
  final PageController _controller = PageController();
  final Map<int, int> _selectedAnswers = {};

  final List<Map<String, dynamic>> _profilingData = [
    {
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
      "question": "Are you learning FSL to communicate with someone you know?",
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
    {
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

  Future<void> _handleNext() async {
    if (_currentPage < _profilingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
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
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / _profilingData.length,
                      color: const Color(0xFFE9B63B),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${_currentPage + 1}/${_profilingData.length}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // MIDDLE
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _profilingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildQuestionPage(
                    index,
                    _profilingData[index]["question"],
                    _profilingData[index]["options"],
                  );
                },
              ),
            ),

            // BOTTOM
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading
                    ? const LoadingIndicator()
                    : Opacity(
                        opacity: _selectedAnswers.containsKey(_currentPage)
                            ? 1.0
                            : 0.5,
                        child: AbsorbPointer(
                          absorbing: !_selectedAnswers.containsKey(
                            _currentPage,
                          ),
                          child: Button(
                            text: _currentPage == _profilingData.length - 1
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

  // Helper Widget
  Widget _buildQuestionPage(
    int pageIndex,
    String question,
    List<dynamic> options,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ...options.asMap().entries.map((entry) {
            int optionIndex = entry.key;
            Map<String, dynamic> optionData = entry.value;
            String optionText = optionData['text'];
            String optionImage = optionData['image'];

            bool isSelected = _selectedAnswers[pageIndex] == optionIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAnswers[pageIndex] = optionIndex;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFE9B63B)
                        : Colors.grey.shade300,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFE9B63B).withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Image.asset(optionImage, width: 24, height: 24),
                    const SizedBox(width: 15),
                    Text(
                      optionText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: Colors.black,
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
}
