import 'package:balancika_demo/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

enum NotificationCategory { order, offer, account }

class NotificationItem {
  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationCategory category;
  bool isRead;
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> _notifications = <NotificationItem>[
    NotificationItem(
      id: '1',
      title: 'Order Out for Delivery 🛵',
      message: 'Your order #BLC-8402 is on the way with our courier.',
      time: '10 mins ago',
      category: NotificationCategory.order,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: '20% OFF Special Promo 🎉',
      message: 'Get 20% off on your next order of Beef Lok Lak. Valid today!',
      time: '1 hour ago',
      category: NotificationCategory.offer,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Reward Points Earned ⭐',
      message: 'You earned +150 Balancika Rewards points from your recent order.',
      time: '3 hours ago',
      category: NotificationCategory.account,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Order Confirmed ✅',
      message: 'The kitchen received order #BLC-8402 and has started cooking.',
      time: 'Yesterday',
      category: NotificationCategory.order,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Welcome to Gold Membership! 👑',
      message: 'You unlocked Gold Member status with extra perks and priority service.',
      time: '2 days ago',
      category: NotificationCategory.account,
      isRead: true,
    ),
  ];

  int get _unreadCount =>
      _notifications.where((NotificationItem item) => !item.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (final NotificationItem item in _notifications) {
        item.isRead = true;
      }
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('All notifications cleared')),
      );
  }

  void _toggleRead(NotificationItem item) {
    setState(() {
      item.isRead = !item.isRead;
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((NotificationItem item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.coffee,
              ),
            ),
            if (_unreadCount > 0) ...<Widget>[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.terracotta,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount new',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: <Widget>[
          if (_notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.coffee),
              onSelected: (String value) {
                if (value == 'read_all') {
                  _markAllAsRead();
                } else if (value == 'clear_all') {
                  _clearAll();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (_unreadCount > 0)
                  const PopupMenuItem<String>(
                    value: 'read_all',
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.done_all, size: 18, color: AppColors.coffee),
                        SizedBox(width: 8),
                        Text('Mark all as read'),
                      ],
                    ),
                  ),
                const PopupMenuItem<String>(
                  value: 'clear_all',
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete_outline, size: 18, color: AppColors.coffee),
                      SizedBox(width: 8),
                      Text('Clear all'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.sand,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_off_outlined,
                      size: 36,
                      color: AppColors.taupe,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'We will let you know when updates or offers arrive.',
                    style: TextStyle(fontSize: 12, color: AppColors.taupe),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final NotificationItem item = _notifications[index];
                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteNotification(item.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item.isRead
                          ? Colors.white
                          : AppColors.sand.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: item.isRead
                            ? AppColors.stroke
                            : AppColors.terracotta.withValues(alpha: 0.3),
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x0A2D1B12),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _toggleRead(item),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _CategoryBadgeIcon(category: item.category),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: item.isRead
                                                ? FontWeight.w600
                                                : FontWeight.w700,
                                            color: AppColors.coffee,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.time,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.taupe,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.message,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      height: 1.4,
                                      color: AppColors.taupe,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!item.isRead) ...<Widget>[
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.terracotta,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _CategoryBadgeIcon extends StatelessWidget {
  const _CategoryBadgeIcon({required this.category});

  final NotificationCategory category;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color bgColor, Color iconColor) = switch (category) {
      NotificationCategory.order => (
          Icons.delivery_dining_rounded,
          AppColors.sand,
          AppColors.terracottaDeep,
        ),
      NotificationCategory.offer => (
          Icons.local_offer_rounded,
          const Color(0xFFFFF0D4),
          AppColors.gold,
        ),
      NotificationCategory.account => (
          Icons.workspace_premium_rounded,
          const Color(0xFFE5F4E7),
          AppColors.leaf,
        ),
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: iconColor),
    );
  }
}
