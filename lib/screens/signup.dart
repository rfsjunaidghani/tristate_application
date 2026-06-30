import 'package:flutter/material.dart';

// Shared colors (matching the rest of the app).
const Color _kNavy = Color(0xFF0b1f3a);
const Color _kGrey = Color(0xFF6B7280);
const Color _kBlue = Color(0xFF3B82F6);
const Color _kFieldFill = Color(0xFFF3F4F6);
const Color _kBorder = Color(0xFFE5E7EB);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kNavy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 56,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Create Your Account",
                      style: TextStyle(
                        color: _kNavy,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      "Join Tri-State Master Services",
                      style: TextStyle(color: _kNavy, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _label("First name"),
                  _field(hint: "Enter Your First Name*"),
                  const SizedBox(height: 16),

                  _label("Last name"),
                  _field(hint: "Enter Your Last Name*"),
                  const SizedBox(height: 16),

                  _label("Email"),
                  _field(hint: "your.email@example.com*"),
                  const SizedBox(height: 16),

                  _label("Password"),
                  _field(
                    hint: "Enter Your Password*",
                    obscure: _obscurePassword,
                    onToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 16),

                  _label("Confirm Password"),
                  _field(
                    hint: "Enter Your Confirm Password*",
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 24),

                  // Non-functional: returns to the login screen.
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _linkRow(
                    "Already have an account? ",
                    "Login",
                    () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---- Builder helpers ----

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: _kNavy,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _field({
    required String hint,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: _kNavy),
      decoration: InputDecoration(
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
        suffixIcon: onToggle == null
            ? null
            : IconButton(
                onPressed: onToggle,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _kGrey,
                  size: 20,
                ),
              ),
      ),
    );
  }

  Widget _linkRow(String normal, String link, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          normal,
          style: const TextStyle(color: _kGrey, fontSize: 13),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            link,
            style: const TextStyle(
              color: _kBlue,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
