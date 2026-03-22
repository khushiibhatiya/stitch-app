import 'package:flutter/material.dart' show BuildContext;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stitch/core/models/booking.dart';

class PdfTicketService {
  static Future<void> generateAndShowTicket(
      BuildContext context, Booking booking) async {
    final pdf = pw.Document();

    // All solid colors — no alpha to avoid PdfColor.withOpacity issues
    const cBlue       = PdfColor(0.118, 0.376, 0.969);
    const cBlueDark   = PdfColor(0.071, 0.259, 0.682);
    const cGreen      = PdfColor(0.063, 0.725, 0.506);
    const cIndigo     = PdfColor(0.388, 0.400, 0.945);
    const cIndigoLight= PdfColor(0.878, 0.882, 0.988);
    const cPink       = PdfColor(0.925, 0.282, 0.600);
    const cPinkLight  = PdfColor(0.988, 0.871, 0.937);
    const cPurple     = PdfColor(0.545, 0.361, 0.965);
    const cPurpleLight= PdfColor(0.906, 0.878, 0.996);
    const cTeal       = PdfColor(0.078, 0.722, 0.651);
    const cTealLight  = PdfColor(0.827, 0.949, 0.933);
    const cWhite      = PdfColor(1.000, 1.000, 1.000);
    const cWhiteSoft  = PdfColor(0.941, 0.957, 1.000);
    const cGray       = PdfColor(0.973, 0.976, 0.984);
    const cGrayBorder = PdfColor(0.878, 0.906, 0.937);
    const cTextDark   = PdfColor(0.059, 0.090, 0.165);
    const cTextMid    = PdfColor(0.392, 0.455, 0.545);
    const cBlueLight  = PdfColor(0.827, 0.886, 0.996);

    final dateStr =
        '${booking.date.day}/${booking.date.month}/${booking.date.year}';
    final bookingId = (booking.id.length > 8
            ? booking.id.substring(0, 8)
            : booking.id)
        .toUpperCase();
    final now = DateTime.now();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context ctx) {
          return pw.Container(
            color: cWhite,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // ── Blue Header ─────────────────────────────────────────────
                pw.Container(
                  padding: const pw.EdgeInsets.fromLTRB(24, 24, 24, 20),
                  color: cBlue,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Restaurant row
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          // Restaurant initial box
                          pw.Container(
                            width: 48,
                            height: 48,
                            decoration: pw.BoxDecoration(
                              color: cBlueDark,
                              borderRadius: pw.BorderRadius.circular(10),
                            ),
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              booking.restaurantName.isNotEmpty
                                  ? booking.restaurantName[0].toUpperCase()
                                  : 'R',
                              style: pw.TextStyle(
                                color: cWhite,
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 12),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  booking.restaurantName,
                                  style: pw.TextStyle(
                                    color: cWhite,
                                    fontSize: 18,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text(
                                  'Booking Confirmation PDF',
                                  style: const pw.TextStyle(
                                    color: cWhiteSoft,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 14),
                      // Confirmed badge
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: pw.BoxDecoration(
                          color: cGreen,
                          borderRadius: pw.BorderRadius.circular(16),
                        ),
                        child: pw.Text(
                          'CONFIRMED',
                          style: pw.TextStyle(
                            color: cWhite,
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Top border line ──────────────────────────────────────────
                pw.Container(height: 1, color: cGrayBorder),

                // ── Guest info ───────────────────────────────────────────────
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(24, 18, 24, 0),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 44,
                        height: 44,
                        decoration: pw.BoxDecoration(
                          color: cBlueLight,
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          booking.userName.isNotEmpty
                              ? booking.userName[0].toUpperCase()
                              : 'U',
                          style: pw.TextStyle(
                            color: cBlue,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            booking.userName,
                            style: pw.TextStyle(
                              color: cTextDark,
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            'Booking ID: #$bookingId',
                            style: const pw.TextStyle(
                              color: cTextMid,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 16),
                pw.Container(
                  height: 1,
                  margin: const pw.EdgeInsets.symmetric(horizontal: 24),
                  color: cGrayBorder,
                ),
                pw.SizedBox(height: 16),

                // ── 2x2 Detail Grid ──────────────────────────────────────────
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: _box(
                              label: 'DATE',
                              value: dateStr,
                              fg: cIndigo,
                              bg: cIndigoLight,
                              border: cIndigo,
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                            child: _box(
                              label: 'TIME',
                              value: booking.time,
                              fg: cPink,
                              bg: cPinkLight,
                              border: cPink,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: _box(
                              label: 'GUESTS',
                              value: '${booking.guests} People',
                              fg: cPurple,
                              bg: cPurpleLight,
                              border: cPurple,
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                            child: _box(
                              label: 'TABLE',
                              value: booking.tableName,
                              fg: cTeal,
                              bg: cTealLight,
                              border: cTeal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),

                // ── Footer ───────────────────────────────────────────────────
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: cGray,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: cGrayBorder),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Present this PDF at the restaurant entrance.',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            color: cTextMid,
                            fontSize: 10,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Generated on ${now.day}/${now.month}/${now.year}',
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            color: cTextMid,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Ticket_${booking.restaurantName.replaceAll(' ', '_')}_$dateStr.pdf',
    );
  }

  static pw.Widget _box({
    required String label,
    required String value,
    required PdfColor fg,
    required PdfColor bg,
    required PdfColor border,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(11),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: border, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: fg,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: fg,
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
