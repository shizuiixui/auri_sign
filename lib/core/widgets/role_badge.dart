import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:auri_sign/features/auth/viewmodels/user_view_model.dart';
import 'package:auri_sign/features/auth/models/user_models.dart';

class RoleBadge extends StatelessWidget {
  final UserModel? user;
  final int? learnerType;
  final String? role;

  const RoleBadge({super.key, this.user, this.learnerType, this.role});

  @override
  Widget build(BuildContext context) {
    final activeUser = user ?? context.watch<UserViewModel>().user;

    String label = "CHILD LEARNER";

    if (learnerType != null) {
      label = learnerType == 2 ? "ADULT LEARNER" : "CHILD LEARNER";
    } else if (role != null) {
      final r = role!.toLowerCase();
      label = (r.contains("adult") || r.contains("teen"))
          ? "ADULT LEARNER"
          : "CHILD LEARNER";
    } else if (activeUser != null) {
      label = activeUser.roleDisplayName;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB800),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1E1E1E),
          letterSpacing: 0.4,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
