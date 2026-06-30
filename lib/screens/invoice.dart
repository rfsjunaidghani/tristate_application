import 'package:flutter/material.dart';
import 'invoice_detail.dart';

// Shared colors
const Color _kNavy = Color(0xFF0b1f3a);
const Color _kGrey = Color(0xFF6B7280);
const Color _kBlue = Color(0xFF3B82F6);
const Color _kFieldFill = Color(0xFFF3F4F6);
const Color _kBorder = Color(0xFFE5E7EB);

/// A single invoice row shown in the table.
class InvoiceRecord {
  final int id;
  final String date;
  final String workOrder;
  final String workType;
  final String address;
  final String codes;
  final double techTotal;
  final String status;

  const InvoiceRecord({
    required this.id,
    required this.date,
    required this.workOrder,
    required this.workType,
    required this.address,
    required this.codes,
    required this.techTotal,
    required this.status,
  });
}

class Invoice extends StatefulWidget {
  // Called with a tab index to switch the bottom-nav tab.
  final ValueChanged<int> onNavigate;

  const Invoice({super.key, required this.onNavigate});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  // Sample invoice data.
  static const List<InvoiceRecord> _invoices = [
    InvoiceRecord(
      id: 1,
      date: "06/15/2026",
      workOrder: "gsssssssssssssssssssss",
      workType: "New Install",
      address: "Temporary drop",
      codes: "F1, F5, F6E, F10, F12, F14S, F15, F16, FD200",
      techTotal: 170.00,
      status: "Submitted",
    ),
    InvoiceRecord(
      id: 2,
      date: "06/15/2026",
      workOrder: "000000000000000",
      workType: "Downgrade",
      address: "1111111111111111111",
      codes: "F1, F2, F3, F4C, F5, F6E, F9, F11, F14, F14S, CVHC, FD300",
      techTotal: 197.00,
      status: "Submitted",
    ),
    InvoiceRecord(
      id: 3,
      date: "06/15/2026",
      workOrder: "11111111111111111",
      workType: "Re-connect",
      address: "222222222222222222",
      codes: "F1, F2, F3, F4C, F5, F9, FDR200",
      techTotal: 122.00,
      status: "Submitted",
    ),
    InvoiceRecord(
      id: 4,
      date: "06/16/2026",
      workOrder: "2222222222222222",
      workType: "Downgrade",
      address: "333333333333333333",
      codes: "F1, F2, F3, F4C, F8C, F12, F14, F14S, WF, FD800",
      techTotal: 233.00,
      status: "Submitted",
    ),
    InvoiceRecord(
      id: 5,
      date: "06/16/2026",
      workOrder: "333333333333333",
      workType: "Upgrade",
      address: "4444444444444444",
      codes: "F1, F2, F3, F4C, F6N, F7, F12, F13, F14, COS, F15, FD1100",
      techTotal: 272.00,
      status: "Submitted",
    ),
    InvoiceRecord(
      id: 6,
      date: "06/17/2026",
      workOrder: "erqweeeeeeeeeeeeee",
      workType: "New Install",
      address: "ggggggggggggggggggggg",
      codes: "F13, WF, FS, CVHC, F16, FD1100",
      techTotal: 248.40,
      status: "Submitted",
    ),
    InvoiceRecord(
      id: 7,
      date: "06/17/2026",
      workOrder: "ewwwwwwwwwwwwwwwwwwww",
      workType: "Re-connect",
      address: "3333333333333333333",
      codes: "F1, F2, F3, F4C, F4N, F5, F6E, F6N, F7, F8C, F8N",
      techTotal: 138.00,
      status: "Submitted",
    ),
  ];

  // Filter field controllers.
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _workOrderController = TextEditingController();
  String? _status;
  String? _workType;

  // Sum of every invoice's tech total.
  double get _grandTotal =>
      _invoices.fold(0.0, (sum, inv) => sum + inv.techTotal);

  @override
  void dispose() {
    _dateFromController.dispose();
    _dateToController.dispose();
    _workOrderController.dispose();
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

          // Page heading.
          const Text(
            "Filters",
            style: TextStyle(
              color: _kNavy,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Filters card.
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel("Date From"),
                _textField(
                  hint: "MM/DD/YYYY",
                  controller: _dateFromController,
                  suffixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _pickDate(_dateFromController),
                ),
                const SizedBox(height: 16),

                _fieldLabel("Date To"),
                _textField(
                  hint: "MM/DD/YYYY",
                  controller: _dateToController,
                  suffixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _pickDate(_dateToController),
                ),
                const SizedBox(height: 16),

                _fieldLabel("Work Order"),
                _textField(
                  hint: "Filters By Work Order",
                  controller: _workOrderController,
                ),
                const SizedBox(height: 16),

                _fieldLabel("Status"),
                _dropdown(
                  value: _status,
                  hint: "All Statuses",
                  items: const ["All Statuses", "Submitted", "Approved","Locked"],
                  onChanged: (value) => setState(() => _status = value),
                ),
                const SizedBox(height: 16),

                _fieldLabel("Work Type"),
                _dropdown(
                  value: _workType,
                  hint: "Select Work Type",
                  items: const [
                    "Upgrade",
                    "Downgrade",
                    "New Install",
                    "Re-connect",
                  ],
                  onChanged: (value) => setState(() => _workType = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Invoices table card.
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // The table is wider than the screen, so it scrolls sideways.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _invoiceTable(),
                ),
                const SizedBox(height: 16),

                // Grand total of every invoice.
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Grand Total:",
                      style: TextStyle(
                        color: _kNavy,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "\$${_grandTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: _kBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Export buttons.
          Row(
            children: [
              Expanded(
                child: _exportButton(
                  label: "Export XLSX",
                  filled: true,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _exportButton(
                  label: "Export PDF",
                  filled: false,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Builder helpers ----

  Widget _invoiceTable() {
    const TextStyle headStyle = TextStyle(
      color: _kNavy,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );
    const TextStyle cellStyle = TextStyle(color: _kNavy, fontSize: 13);

    return DataTable(
      headingTextStyle: headStyle,
      dataTextStyle: cellStyle,
      headingRowHeight: 44,
      dataRowMinHeight: 48,
      dataRowMaxHeight: 60,
      columnSpacing: 28,
      dividerThickness: 1,
      columns: const [
        DataColumn(label: Text("Id")),
        DataColumn(label: Text("Date")),
        DataColumn(label: Text("Work Order")),
        DataColumn(label: Text("Work Type")),
        DataColumn(label: Text("Address")),
        DataColumn(label: Text("Codes")),
        DataColumn(label: Text("Tech Total")),
        DataColumn(label: Text("Status")),
        DataColumn(label: Text("Actions")),
      ],
      rows: _invoices.map((inv) {
        return DataRow(
          cells: [
            DataCell(Text("${inv.id}")),
            DataCell(Text(inv.date)),
            DataCell(Text(inv.workOrder)),
            DataCell(Text(inv.workType)),
            DataCell(Text(inv.address)),
            DataCell(Text(inv.codes)),
            DataCell(
              Text(
                "\$${inv.techTotal.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataCell(_statusBadge(inv.status)),
            DataCell(_rowActions(inv)),
          ],
        );
      }).toList(),
    );
  }

  // Grey pill showing the invoice status.
  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _kFieldFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(color: _kGrey, fontSize: 12),
      ),
    );
  }

  // View / edit / delete icon buttons for a table row.
  Widget _rowActions(InvoiceRecord inv) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // View opens the invoice detail page.
        _actionIcon(
          Icons.visibility_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => InvoiceDetail(invoice: inv)),
          ),
        ),
        const SizedBox(width: 8),
        _actionIcon(Icons.edit_outlined),
        const SizedBox(width: 8),
        _actionIcon(Icons.delete_outline),
      ],
    );
  }

  Widget _actionIcon(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _kBorder),
        ),
        child: Icon(icon, size: 18, color: _kBlue),
      ),
    );
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
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14, color: _kNavy),
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon:
            suffixIcon == null ? null : Icon(suffixIcon, size: 20, color: _kGrey),
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

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _kGrey),
      hint: Text(hint, style: const TextStyle(fontSize: 14, color: _kGrey)),
      style: const TextStyle(fontSize: 14, color: _kNavy),
      decoration: _inputDecoration(""),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _exportButton({
    required String label,
    required bool filled,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.download_rounded,
          size: 20,
          color: filled ? Colors.white : _kNavy,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? _kBlue : Colors.white,
          foregroundColor: filled ? Colors.white : _kNavy,
          elevation: 0,
          side: filled ? null : const BorderSide(color: _kBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Shared input decoration for all filter fields.
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
