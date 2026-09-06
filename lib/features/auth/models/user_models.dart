class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePicture;
  final String token;
  final int? learnerType;
  final String? role;
  final Map<String, dynamic>? profiling;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicture,
    required this.token,
    this.learnerType,
    this.role,
    this.profiling,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

    Map<String, dynamic>? profilingMap;
    if (userMap['profiling'] is Map<String, dynamic>) {
      profilingMap = userMap['profiling'] as Map<String, dynamic>;
    } else if (json['profiling'] is Map<String, dynamic>) {
      profilingMap = json['profiling'] as Map<String, dynamic>;
    }

    int? parsedLearnerType;
    if (userMap['learnerType'] != null) {
      parsedLearnerType = (userMap['learnerType'] as num?)?.toInt();
    } else if (profilingMap != null && profilingMap['learnerType'] != null) {
      parsedLearnerType = (profilingMap['learnerType'] as num?)?.toInt();
    } else if (profilingMap != null && profilingMap['age_group'] != null) {
      final ageGroup = (profilingMap['age_group'] as num?)?.toInt();
      if (ageGroup != null) {
        parsedLearnerType = ageGroup + 1;
      }
    }

    return UserModel(
      id: (userMap['_id'] ?? userMap['id'] ?? '').toString(),
      firstName: (userMap['firstName'] ?? '').toString(),
      lastName: (userMap['lastName'] ?? '').toString(),
      email: (userMap['email'] ?? '').toString(),
      profilePicture: userMap['profilePicture']?.toString(),
      token: (json['token'] ?? userMap['token'] ?? '').toString(),
      learnerType: parsedLearnerType,
      role: (userMap['role'] ?? profilingMap?['role'])?.toString(),
      profiling: profilingMap,
    );
  }

  bool get isChild {
    if (learnerType == 1) return true;
    if (profiling?['learnerType'] == 1) return true;
    if (profiling?['age_group'] == 0) return true;
    final r = role?.toLowerCase() ?? '';
    if (r == 'child' || r == 'child learner') return true;
    return false;
  }

  bool get isAdult {
    if (learnerType == 2) return true;
    if (profiling?['learnerType'] == 2) return true;
    if (profiling?['age_group'] == 1) return true;
    final r = role?.toLowerCase() ?? '';
    if (r == 'adult' || r == 'teen' || r == 'adult learner') return true;
    return false;
  }

  String get roleDisplayName {
    if (isAdult) return "ADULT LEARNER";
    return "CHILD LEARNER";
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
    String? token,
    int? learnerType,
    String? role,
    Map<String, dynamic>? profiling,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      token: token ?? this.token,
      learnerType: learnerType ?? this.learnerType,
      role: role ?? this.role,
      profiling: profiling ?? this.profiling,
    );
  }
}