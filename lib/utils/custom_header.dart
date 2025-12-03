import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/LocationProvider.dart';

class CustomHeader extends StatelessWidget {
  final bool showNotification;
  final VoidCallback? onNotificationTap;

  const CustomHeader({
    Key? key,
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
          Consumer<LocationProvider>(
            builder: (context, locationProvider, child) {
              return GestureDetector(
                onTap: () {
                  locationProvider.refreshLocation();
                },
                child: Row(
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
                          locationProvider.city,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          locationProvider.area,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    if (locationProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
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
