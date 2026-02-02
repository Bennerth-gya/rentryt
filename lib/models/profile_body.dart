import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenuWIdget extends StatelessWidget {
  const ProfileMenuWIdget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40, // a bit nicer touch target
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.08), // light background (optional)
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon, // ← NOW uses the passed icon
          color: Colors.blue, // or Theme.of(context).colorScheme.primary
          size: 26,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                LineAwesomeIcons.angle_double_right_solid,
                color: Colors.grey,
                size: 18.0,
              ),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}
