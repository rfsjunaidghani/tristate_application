import 'package:flutter/material.dart';
import 'login.dart';

// Shared colors (matching dashboard.dart / create_invoice.dart).
const Color _kNavy = Color(0xFF0b1f3a);
const Color _kGrey = Color(0xFF6B7280);
const Color _kBlue = Color(0xFF3B82F6);
const Color _kRed = Color(0xFFDC2626);
const Color _kFieldFill = Color(0xFFF3F4F6);
const Color _kBorder = Color(0xFFE5E7EB);

class Profile extends StatefulWidget {
  // Called with a tab index to switch the bottom-nav tab.
  final ValueChanged<int> onNavigate;

  const Profile({super.key, required this.onNavigate});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Personal info field controllers.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(text: "John@gmail.com");
  final TextEditingController _phoneController = TextEditingController();

  // Change password field controllers.
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Leave a gap above the transparent CurvedNavigationBar (extendBody is true).
    final double bottomGap = MediaQuery.of(context).padding.bottom + 30;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Native-style flat back button: leading chevron + label.
          TextButton.icon(
            onPressed: () => widget.onNavigate(0), // Dashboard tab
            icon: const Icon(Icons.arrow_back_ios_new, size: 16),
            label: const Text("Back to Dashboard"),
            style: TextButton.styleFrom(
              foregroundColor: _kNavy,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Personal Information card.
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Personal Information",
                  style: TextStyle(
                    color: _kNavy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _fieldLabel("Name"),
                _textField(hint: "John", controller: _nameController),
                const SizedBox(height: 16),

                _fieldLabel("Email (Read Only)"),
                _textField(
                  hint: "",
                  controller: _emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),

                _fieldLabel("Phone"),
                _textField(
                  hint: "e.g., (215) 555-0200",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Change Password card.
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Change Password",
                  style: TextStyle(
                    color: _kNavy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _fieldLabel("Current Password"),
                _textField(
                  hint: "Current Password",
                  controller: _currentPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                _fieldLabel("New Password"),
                _textField(
                  hint: "New Password",
                  controller: _newPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                _fieldLabel("Confirm New Password"),
                _textField(
                  hint: "Confirm New Password",
                  controller: _confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Save button.
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Logout button.
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _confirmLogout,
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _kRed,
                side: const BorderSide(color: _kRed),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Builder helpers ----

  // Confirms before logging out, then returns to the login screen.
  Future<void> _confirmLogout() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(
            color: _kNavy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: _kGrey, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            style: TextButton.styleFrom(foregroundColor: _kGrey),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      // Clear the navigation stack so the user can't go "back" into the app.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: _kGrey, fontSize: 13),
      ),
    );
  }

  Widget _textField({
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: _kNavy),
      decoration: _inputDecoration(hint),
    );
  }

  // Shared input decoration for all form fields.
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _kGrey, fontSize: 14),
      filled: true,
      fillColor: _kFieldFill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _kBlue),
      ),
    );
  }
}

/// White rounded card with the soft shadow used across the app.
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
      child: child,
    );
  }
}
