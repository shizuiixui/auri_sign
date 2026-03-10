import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auri_sign/features/notifications/presentation/viewmodels/notification_center_view_model.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationCenterViewModel>();
    final notifications = viewModel.notifications;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          if (viewModel.unreadCount > 0)
            TextButton(
              onPressed: () => viewModel.markAllAsRead(),
              child: const Text(
                "Mark all as read",
                style: TextStyle(color: Color(0xFFE9B63B), fontSize: 16),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                "You have no notifications.",
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(height: 1.h),
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  tileColor: notification.isRead
                      ? Colors.white
                      : const Color(0xFFFFF9E5),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFFFB800).withOpacity(0.2),
                    child: Icon(
                      Icons.notifications,
                      color: const Color(0xFFFFB800),
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatTime(notification.timestamp),
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    context.read<NotificationCenterViewModel>().markAsRead(
                      notification.id,
                    );
                  },
                );
              },
            ),
    );
  }

  // Timestamp Formatting Helper
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
