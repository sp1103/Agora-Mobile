import 'dart:math';
import 'package:flutter/material.dart';
import 'package:agora_mobile/Types/politician.dart';

class CongressChart extends StatefulWidget {
  final Map<Color, List<Politician>> partySeats;
  final double width;
  final double height;

  const CongressChart({
    super.key,
    required this.partySeats,
    this.width = 400,
    this.height = 500,
  });

  @override
  State<CongressChart> createState() => _CongressChartState();
}

class _CongressChartState extends State<CongressChart> {
  int? tappedIndex;
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final allSeats = widget.partySeats.values.expand((x) => x).toList();

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        minScale: 1,
        maxScale: 5,
        onInteractionUpdate: (details) {
          setState(() {
            scale = details.scale;
          });
        },
        child: LayoutBuilder(builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          final seatPositions = _calculateSeatPositions(size, allSeats.length);

          return GestureDetector(
            onTapDown: (details) {
              final tapPos = details.localPosition;
              const tapRadius = 12.0;

              for (int i = 0; i < seatPositions.length; i++) {
                if ((seatPositions[i] - tapPos).distance <= tapRadius) {
                  setState(() => tappedIndex = i);
                  final pol = allSeats[i];

                  if (scale > 2.5) {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => _SeatDetails(politician: pol),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${pol.name} selected!")),
                    );
                  }
                  break;
                }
              }
            },
            child: CustomPaint(
              painter: _HemicyclePainter(
                widget.partySeats,
                tappedIndex,
                seatPositions,
                allSeats,
                scale,
              ),
              size: size,
            ),
          );
        }),
      ),
    );
  }

  /// Calculate seat positions for a balanced semicircular arrangement.
  List<Offset> _calculateSeatPositions(Size size, int totalSeats) {
    final positions = <Offset>[];

    final center = Offset(size.width / 2, size.height - 40);
    const innerRadius = 50.0;
    const centerGap = 10.0;
    const minRowGap = 2.0;

    int rows = (sqrt(totalSeats * 0.6)).ceil();
    double maxRadius = size.height - 60;

    double radiusStep =
        (maxRadius - innerRadius - centerGap - 10) / rows;

    int seatIndex = 0;

    for (int r = 0; r < rows; r++) {
      final radius = innerRadius + centerGap + r * (radiusStep + minRowGap);
      final seatsInRow = max((pi * radius / 28).floor(), 2);
      final angleStep = pi / (seatsInRow - 1);

      for (int i = 0; i < seatsInRow && seatIndex < totalSeats; i++) {
        final angle = pi - i * angleStep;
        final x = center.dx + radius * cos(angle);
        final y = center.dy - radius * sin(angle);
        positions.add(Offset(x, y));
        seatIndex++;
      }
    }

    // Sort to paint columns top-down
    positions.sort((a, b) {
      int cmpX = a.dx.compareTo(b.dx);
      if (cmpX == 0) return a.dy.compareTo(b.dy);
      return cmpX;
    });

    return positions;
  }
}

class _HemicyclePainter extends CustomPainter {
  final Map<Color, List<Politician>> partySeats;
  final int? tappedIndex;
  final List<Offset> seatPositions;
  final List<Politician> allSeats;
  final double zoomScale;

  _HemicyclePainter(
    this.partySeats,
    this.tappedIndex,
    this.seatPositions,
    this.allSeats,
    this.zoomScale,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height - 40);

    // dynamic seat radius based on seat count (smaller for larger chambers)
    final seatRadius = max(6.0, 14.0 - allSeats.length / 100.0);

    // draw center
    canvas.drawCircle(center, 50, Paint()..color = Colors.white);

    // flatten party color order
    final seatColors = <Color>[];
    for (final entry in partySeats.entries) {
      seatColors.addAll(List.filled(entry.value.length, entry.key));
    }

    // draw seats
    for (int i = 0; i < seatPositions.length && i < allSeats.length; i++) {
      paint.color = seatColors[i].withValues(alpha: i == tappedIndex ? 0.6 : 1.0);
      canvas.drawCircle(seatPositions[i], seatRadius, paint);

      // show individual names only when zoomed in enough
      if (zoomScale > 2.5) {
        final label = allSeats[i].name;
        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 9 * min(zoomScale, 3),
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          seatPositions[i] + Offset(-textPainter.width / 2, -textPainter.height - 6),
        );
      }
    }

    // === SHOW PARTY GROUP COUNTS WHEN ZOOMED OUT ===
    if (zoomScale <= 2.5) {
      double midY = size.height / 2.4;

      // Calculate approximate label positions for each color group
      final textPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      double textY = midY;

      partySeats.forEach((color, list) {
        String label;
        if (color == Colors.red) {
          label = "Republican (${list.length})";
        } else if (color == Colors.blue) {
          label = "Democrat (${list.length})";
        } else if (color == Colors.green) {
          label = "Independent (${list.length})";
        } else {
          label = "Other (${list.length})";
        }

        textPainter.text = TextSpan(
          text: label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(center.dx - textPainter.width / 2, textY),
        );
        textY += textPainter.height + 8;
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SeatDetails extends StatelessWidget {
  final Politician politician;
  const _SeatDetails({required this.politician});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(politician.name, style: Theme.of(context).textTheme.titleLarge),
          Text("${politician.party} — ${politician.state}"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // navigate to politician page
            },
            child: const Text("View Member Page"),
          ),
        ],
      ),
    );
  }
}
