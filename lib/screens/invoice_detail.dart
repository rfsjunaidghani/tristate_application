import 'package:flutter/material.dart';
import 'invoice.dart' show InvoiceRecord;

// Shared colors (matching the other screens).
const Color _kNavy = Color(0xFF0b1f3a);
const Color _kGrey = Color(0xFF6B7280);
const Color _kFieldFill = Color(0xFFF3F4F6);
const Color _kBorder = Color(0xFFE5E7EB);

/// A single line item in the Service Codes table.
class ServiceLineItem {
  final String code;
  final String description;
  final int quantity;
  final String perTechPrice; // display string, e.g. "$7" or "$0.15"
  final double total;

  const ServiceLineItem({
    required this.code,
    required this.description,
    required this.quantity,
    required this.perTechPrice,
    required this.total,
  });
}

class InvoiceDetail extends StatelessWidget {
  final InvoiceRecord invoice;

  const InvoiceDetail({super.key, required this.invoice});

  // Static service-code breakdown (matches the design).
  static const List<ServiceLineItem> _lineItems = [
    ServiceLineItem(
      code: "F1",
      description: "Trip Charge",
      quantity: 1,
      perTechPrice: "\$7",
      total: 7.00,
    ),
    ServiceLineItem(
      code: "F5",
      description: "Eero/Router New or Existing",
      quantity: 2,
      perTechPrice: "\$7",
      total: 14.00,
    ),
    ServiceLineItem(
      code: "F6E",
      description: "eStream Verify",
      quantity: 5,
      perTechPrice: "\$3",
      total: 15.00,
    ),
    ServiceLineItem(
      code: "F10",
      description: "Activation 2nd Phone Line",
      quantity: 1,
      perTechPrice: "\$7",
      total: 7.00,
    ),
    ServiceLineItem(
      code: "F12",
      description: "Custom Fiber Line",
      quantity: 1,
      perTechPrice: "\$15",
      total: 15.00,
    ),
    ServiceLineItem(
      code: "F14S",
      description: "Remove Old Coax Drop from Sub Poles",
      quantity: 1,
      perTechPrice: "\$7",
      total: 7.00,
    ),
    ServiceLineItem(
      code: "F15",
      description: "Conduit Fish Up 150'",
      quantity: 1,
      perTechPrice: "\$30",
      total: 30.00,
    ),
    ServiceLineItem(
      code: "F16",
      description: "Conduit Fish over 150' (Per Ft)",
      quantity: 200,
      perTechPrice: "\$0.15",
      total: 30.00,
    ),
    ServiceLineItem(
      code: "FD200",
      description: "New Up to 200ft Aerial Drop",
      quantity: 1,
      perTechPrice: "\$45",
      total: 45.00,
    ),
  ];

  static const String _comments =
      "Installed new ONT and ran a fresh aerial drop to the NID. "
      "Configured customer router, verified WiFi levels in all rooms, "
      "and confirmed service is active. No further action required.";

  // Sum of every line item's total.
  double get _techTotal =>
      _lineItems.fold(0.0, (sum, item) => sum + item.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // we use the in-body back button
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0x1F000000), height: 1.0),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Invoice Detail",
            style: TextStyle(
              color: _kNavy,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xffbdbdbd),
              child: Text(
                'J',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Native-style flat back button: leading chevron + label.
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              label: const Text("Back to Invoice"),
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

            // Main detail card.
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: work order + date on the left, status on the right.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invoice.workOrder,
                              style: const TextStyle(
                                color: _kNavy,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              invoice.date,
                              style: const TextStyle(
                                color: _kGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _statusBadge(invoice.status),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Service Address (left) + Work Order Number / Work Type (right).
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Service Address",
                              style: TextStyle(
                                color: _kNavy,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              invoice.address,
                              style: const TextStyle(
                                color: _kGrey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _labelValue(
                                "Work Order Number: ", invoice.workOrder),
                            const SizedBox(height: 6),
                            _labelValue("Work Type: ", invoice.workType),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Service Codes title + table.
                  const Text(
                    "Service Codes",
                    style: TextStyle(
                      color: _kNavy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _codesTable(),
                  ),
                  const SizedBox(height: 16),

                  // Tech total.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Tech Total :",
                        style: TextStyle(
                          color: _kNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "\$${_techTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: _kNavy,
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

            // Comments card.
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Comments",
                    style: TextStyle(
                      color: _kNavy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _kFieldFill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _kBorder),
                    ),
                    child: const Text(
                      _comments,
                      style: TextStyle(color: _kGrey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Builder helpers ----

  // "Label: value" line with a bold navy label and a grey value.
  Widget _labelValue(String label, String value) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: _kNavy,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: _kGrey,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _codesTable() {
    return DataTable(
      headingTextStyle: const TextStyle(
        color: _kNavy,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      dataTextStyle: const TextStyle(color: _kGrey, fontSize: 13),
      headingRowHeight: 44,
      dataRowMinHeight: 44,
      dataRowMaxHeight: 56,
      columnSpacing: 32,
      columns: const [
        DataColumn(label: Text("Code")),
        DataColumn(label: Text("Description")),
        DataColumn(label: Text("Quantity"), numeric: true),
        DataColumn(label: Text("Per Tech Price"), numeric: true),
        DataColumn(label: Text("Total"), numeric: true),
      ],
      rows: _lineItems.map((item) {
        return DataRow(
          cells: [
            DataCell(Text(item.code)),
            DataCell(Text(item.description)),
            DataCell(Text("${item.quantity}")),
            DataCell(Text(item.perTechPrice)),
            DataCell(Text("\$${item.total.toStringAsFixed(2)}")),
          ],
        );
      }).toList(),
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
