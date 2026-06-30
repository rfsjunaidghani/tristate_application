import 'package:flutter/material.dart';

// Shared colors.
const Color _kNavy = Color(0xFF0b1f3a);
const Color _kGrey = Color(0xFF6B7280);
const Color _kBlue = Color(0xFF3B82F6);
const Color _kFieldFill = Color(0xFFF3F4F6);
const Color _kBorder = Color(0xFFE5E7EB);

/// A single billable service code shown in the Auto-Calculation Summary.
class ServiceCode {
  final String label;
  final int rate;
  const ServiceCode(this.label, this.rate);
}

class CreateInvoice extends StatefulWidget {
  // Called with a tab index to switch the bottom-nav tab.
  final ValueChanged<int> onNavigate;

  const CreateInvoice({super.key, required this.onNavigate});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  // All available service codes with their tech rates.
  static const List<ServiceCode> _services = [
    ServiceCode("F1-Trip Charge", 7),
    ServiceCode("F2-Terminal & House Box Connection", 20),
    ServiceCode("F3-Exchange House Box", 7),
    ServiceCode("F4C-ONT Conversion (internet only)", 15),
    ServiceCode("F4N-ONT New Install (internet only)", 20),
    ServiceCode("F5-Eero/Router New or Existing", 7),
    ServiceCode("F6E-eStream Verify", 3),
    ServiceCode("F6N-eStream Install", 7),
    ServiceCode("F7-Verify WiFi Levels", 7),
    ServiceCode("FBC-ONT EMTA & Internet Conversion (internet and phone)", 20),
    ServiceCode("FBN-ONT EMTA New Phone Install", 25),
    ServiceCode("F9-Alarm Line Seizure Verification", 7),
  ];

  // Tracks checked service codes and their quantity (index -> qty, min 1).
  // A key being present means the code is checked.
  final Map<int, int> _quantities = {};

  // Form field controllers.
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _workOrderController = TextEditingController();
  final TextEditingController _serviceAddressController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  String? _workType;

  // Running total of the checked tech rates multiplied by their quantity.
  int get _techTotal => _quantities.entries
      .fold(0, (sum, e) => sum + _services[e.key].rate * e.value);

  // Set a code's quantity, clamped to a minimum of 1.
  void _setQuantity(int index, int qty) {
    setState(() => _quantities[index] = qty < 1 ? 1 : qty);
  }

  void _resetForm() {
    setState(() {
      _quantities.clear();
      _workOrderController.clear();
      _serviceAddressController.clear();
      _commentsController.clear();
      _workType = null;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _workOrderController.dispose();
    _serviceAddressController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Leave a gap above the transparent CurvedNavigationBar. The body extends
    // behind it (Scaffold.extendBody is true), so the bottom padding accounts
    // for the bar height plus the device's safe-area inset.
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

          // Page heading.
          const Text(
            "Invoice Details",
            style: TextStyle(
              color: _kNavy,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Form card.
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Date"),
                _textField(
                  hint: "MM/DD/YYYY",
                  controller: _dateController,
                  readOnly: true,
                  suffixIcon: Icons.calendar_today_outlined,
                  onTap: () => _pickDate(_dateController),
                ),
                const SizedBox(height: 16),

                _fieldLabel("Work Order Number", required: true),
                _textField(
                  hint: "WO-2026-XXX",
                  controller: _workOrderController,
                ),
                const SizedBox(height: 16),

                _fieldLabel("Work Type", required: true),
                _workTypeDropdown(),
                const SizedBox(height: 16),

                _fieldLabel("Service Address", required: true),
                _textField(
                  hint: "Enter Complete Service Address",
                  controller: _serviceAddressController,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Auto-Calculation Summary card.
          _Card(
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                const Text(
                  "Auto-Calculation Summary",
                  style: TextStyle(
                    color: _kNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  height: 220, 
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < _services.length; i++) ...[
                          if (i > 0) const SizedBox(height: 10),
                          _serviceRow(i),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tech Total row.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  
                  children: [
                    const Text(
                      "Tech Total",
                      style: TextStyle(
                        color: _kNavy,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${_techTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: _kBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Submit button.
                _primaryButton(
                  label: "Submit Invoice",
                  color: _kBlue,
                  onPressed: () {},
                ),
                const SizedBox(height: 12),

                // Reset button.
                _primaryButton(
                  label: "Reset Form",
                  color: _kNavy,
                  onPressed: _resetForm,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Comments / Notes card.
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Comments / Notes",
                  style: TextStyle(
                    color: _kNavy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentsController,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 14, color: _kNavy),
                  decoration: _inputDecoration(
                    "Add any additional notes or comments...",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Small builder helpers ----

  // Field label with an optional red asterisk for required fields.
  Widget _fieldLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: _kGrey, fontSize: 13),
          children: [
            if (required)
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14, color: _kNavy),
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, size: 20, color: _kGrey),
      ),
    );
  }

  // Opens a calendar and writes the chosen date (MM/DD/YYYY) into the field.
  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final String formatted =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      setState(() => controller.text = formatted);
    }
  }

  Widget _workTypeDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _workType,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _kGrey),
      hint: const Text(
        "Select Work Type",
        style: TextStyle(fontSize: 14, color: _kGrey),
      ),
      style: const TextStyle(fontSize: 14, color: _kNavy),
      decoration: _inputDecoration(""),

      items: const [
        DropdownMenuItem(value: "Upgrade", child: Text("Upgrade")),
        DropdownMenuItem(value: "Downgrade", child: Text("Downgrade")),
        DropdownMenuItem(value: "New Install", child: Text("New Install")),
        DropdownMenuItem(value: "Re-connect", child: Text("Re-connect")),
      ],
      onChanged: (value) => setState(() => _workType = value),
    );
  }

  // A bordered, checkable row for a single service code.
  Widget _serviceRow(int index) {
    final ServiceCode service = _services[index];
    final bool checked = _quantities.containsKey(index);

    void toggle(bool value) {
      setState(() {
        // Checking starts the quantity at 1; unchecking removes it.
        value ? _quantities[index] = 1 : _quantities.remove(index);
      });
    }

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => toggle(!checked),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: checked,
                activeColor: _kBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) => toggle(value == true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.label,
                    style: const TextStyle(
                      color: _kNavy,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Tech Rate: \$${service.rate}",
                    style: const TextStyle(color: _kGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Quantity stepper appears only when the code is checked.
            if (checked) ...[
              const SizedBox(width: 12),
              _quantityStepper(index),
            ],
          ],
        ),
      ),
    );
  }

  // "Qty:" label + a number box with up/down steppers (minimum 1).
  Widget _quantityStepper(int index) {
    final int qty = _quantities[index] ?? 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Qty:",
          style: TextStyle(
            color: _kNavy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                alignment: Alignment.center,
                child: Text(
                  "$qty",
                  style: const TextStyle(
                    color: _kNavy,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(width: 1, height: 36, color: _kBorder),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _stepButton(
                    Icons.keyboard_arrow_up,
                    () => _setQuantity(index, qty + 1),
                  ),
                  _stepButton(
                    Icons.keyboard_arrow_down,
                    // Disabled at the minimum of 1.
                    qty > 1 ? () => _setQuantity(index, qty - 1) : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          icon,
          size: 15,
          color: onTap == null ? _kBorder : _kGrey,
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
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
