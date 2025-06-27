import 'package:flutter/material.dart';
import 'notification_page.dart';

class NotificationModel {
  final String id;
  final String title;
  final List<dynamic> products;
  final String message;
  final String date;
  final String status;

  NotificationModel({
    required this.id,
    required this.title,
    required this.products,
    required this.message,
    required this.date,
    required this.status,
  });
}

class NotificationService {
  static List<NotificationModel> notifications = [];

  static void addNotification(NotificationModel notification) {
    notifications.add(notification);
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.green,
      ),
      body: NotificationService.notifications.isEmpty
          ? Center(
              child: Text(
                'Aucune notification',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: NotificationService.notifications.length,
              itemBuilder: (context, index) {
                final notification = NotificationService.notifications[index];
                Color statusColor;
                IconData statusIcon;
                switch (notification.status) {
                  case 'success':
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'error':
                    statusColor = Colors.red;
                    statusIcon = Icons.error;
                    break;
                  case 'warning':
                    statusColor = Colors.orange;
                    statusIcon = Icons.warning;
                    break;
                  default:
                    statusColor = Colors.blueGrey;
                    statusIcon = Icons.notifications;
                }
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: statusColor.withOpacity(0.15),
                      child: Icon(
                        statusIcon,
                        color: statusColor,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          notification.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Supprimer la notification',
                      onPressed: () {
                        NotificationService.notifications.removeAt(index);
                        // Forcer le rafraîchissement de la page
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
