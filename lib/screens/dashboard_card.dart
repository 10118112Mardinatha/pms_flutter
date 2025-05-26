import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final int count;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.blue;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isHovered
                ? [baseColor.shade400, baseColor.shade600]
                : [baseColor.shade50, baseColor.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(_isHovered ? 0.3 : 0.1),
              blurRadius: _isHovered ? 12 : 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isHovered
                    ? Colors.white.withOpacity(0.3)
                    : baseColor.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 36,
                color: _isHovered ? Colors.white : baseColor.shade800,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isHovered ? Colors.white : Colors.black87,
              ),
              child: Text(widget.count.toString()),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _isHovered ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
