import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  // Called with a tab index to switch the bottom-nav tab.
  final ValueChanged<int> onNavigate;

  const Dashboard({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    const String currentDate = "Wednesday, June 24, 2026";
    // Leave a gap above the transparent CurvedNavigationBar. The body extends
    // behind it (Scaffold.extendBody is true), so the bottom padding accounts
    // for the bar height plus the device's safe-area inset.
    final double bottomGap = MediaQuery.of(context).padding.bottom + 30;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            // padding: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side: Text Content
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Today's Date",
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6), // Spacing between the two texts
                      Text(
                        currentDate,
                        style: TextStyle(
                          color: Color(0xFF0b1f3a),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Side: Calendar Icon Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF), // Light blue box background
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Small rounded box
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF3B82F6),
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // Stat cards row
          const Row(
            children: [
              // Left Card: Invoices
              Expanded(
                child: StatCard(
                  label: "Invoices",
                  value: "7",
                  icon: Icons.description_outlined,
                ),
              ),

              // Spacing between the two cards
              SizedBox(width: 16),

              // Right Card: Total Earnings
              Expanded(
                child: StatCard(
                  label: "Earnings",
                  value: "\$130.40",
                  icon: Icons.attach_money_rounded,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),

          // Action cards row: icon on top, label below
          Row(
            children: [
              Expanded(
                child: ActionCard(
                  label: "View My Invoices",
                  icon: Icons.format_list_bulleted_rounded,
                  onTap: () => onNavigate(2), // My Invoices tab
                ),
              ),

              // Spacing between the two cards
              const SizedBox(width: 16),

              Expanded(
                child: ActionCard(
                  label: "My Profile",
                  icon: Icons.person_outline_rounded,
                  onTap: () => onNavigate(3), // Profile tab
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Full-width Create Daily Invoice card
          SizedBox(
            width: double.infinity,
            child: ActionCard(
              label: "Create Daily Invoice",
              icon: Icons.add,
              onTap: () => onNavigate(1), // Create Daily Invoice tab
            ),
          ),
          const SizedBox(height: 16),

          // Quick Tips card
          const QuickTipsCard(
            tips: [
              "Submit invoices daily for faster processing",
              "Include detailed comments for each service code",
              "Double-check work order numbers before submission",
              "Contact admin if you need help with any invoice",
            ],
          ),
        ],
      ),
    );
  }
}

/// Reusable stat card displaying a small label, a large value and a trailing icon.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF3B82F6),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable action card with a centered icon on top and a label below,
/// used for quick navigation shortcuts.
class ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  // Optional tap handler; when null the card is not interactive.
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF0b1f3a),
              size: 26,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0b1f3a),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Quick Tips card showing a title followed by a bulleted list,
/// with a divider between each tip.
class QuickTipsCard extends StatelessWidget {
  final List<String> tips;

  const QuickTipsCard({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Tips",
            style: TextStyle(
              color: Color(0xFF0b1f3a),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Build a row (bullet + text) for each tip, separated by a divider.
          for (int i = 0; i < tips.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0x14000000)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tips[i],
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
