import 'package:flutter/material.dart';
import 'notificationModel.dart';
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService.notifications;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: notifications.isEmpty
          ? Center(child: Text('Aucune notification'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notif.title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Supprimer la notification',
                              onPressed: () {
                                setState(() {
                                  notifications.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(notif.message),
                        SizedBox(height: 4),
                        Text('Date : ' + notif.date, style: TextStyle(fontSize: 12, color: Colors.grey)),
                        if (notif.products.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Text('Produits commandés :', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...notif.products.map<Widget>((prod) => Text('- ' + (prod['name'] ?? ''), style: TextStyle(fontSize: 14))).toList(),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

