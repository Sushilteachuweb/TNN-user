import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String location;
  final String subLocation;
  final bool showNotification;
  final VoidCallback? onNotificationTap;

  const CustomHeader({
    Key? key,
    this.location = "Noida",
    this.subLocation = "Sector 62",
    this.showNotification = true,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location Section
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 18,
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    subLocation,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Logo and Icons Section
          Row(
            children: [
              Image.asset(
                'images/logo3.png',
                height: 32,
              ),
              const SizedBox(width: 12),
              if (showNotification) ...[
                GestureDetector(
                  onTap: onNotificationTap,
                  child: Image.asset(
                    'images/notification1.png',
                    height: 22,
                    color: Colors.blue,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
