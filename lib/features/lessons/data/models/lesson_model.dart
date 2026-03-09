class LessonStep {
  final int stepNumber;
  final String stepType;
  final String content;
  final Map<String, dynamic>? metadata;

  LessonStep({
    required this.stepNumber,
    required this.stepType,
    required this.content,
    this.metadata,
  });

  factory LessonStep.fromJson(Map<String, dynamic> json) {
    return LessonStep(
      stepNumber: json['stepNumber'] ?? 1,
      stepType: json['stepType'] ?? 'introduction',
      content: json['content'] ?? '',
      metadata: json['metadata'],
    );
  }

  // 👇 ADD THIS METHOD TO FIX THE ERROR
  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'stepType': stepType,
      'content': content,
      'metadata': metadata,
    };
  }
}

class StartLessonResponse {
  final LessonStep currentStep;
  final int totalSteps;
  final String progressStatus;

  StartLessonResponse({
    required this.currentStep,
    required this.totalSteps,
    required this.progressStatus,
  });

  factory StartLessonResponse.fromJson(Map<String, dynamic> json) {
    return StartLessonResponse(
      currentStep: LessonStep.fromJson(json['currentStep']),
      totalSteps: json['totalSteps'] ?? 0,
      progressStatus: json['progress']['status'] ?? 'in-progress',
    );
  }
}

class SubmitAnswerResponse {
  final bool isCorrect;
  final bool lessonCompleted;
  final LessonStep? nextStep;
  final int? finalScore;

  SubmitAnswerResponse({
    required this.isCorrect,
    required this.lessonCompleted,
    this.nextStep,
    this.finalScore,
  });

  factory SubmitAnswerResponse.fromJson(Map<String, dynamic> json) {
    return SubmitAnswerResponse(
      isCorrect: json['isCorrect'] ?? false,
      lessonCompleted: json['lessonCompleted'] ?? false,
      nextStep: json['nextStep'] != null ? LessonStep.fromJson(json['nextStep']) : null,
      finalScore: json['finalScore'],
    );
  }
}