import 'dart:math';
import 'package:agora_mobile/Types/politician.dart';
import 'package:flutter/material.dart';

class CongressChart extends StatefulWidget {
  final Map<Color, List<Politician>> partySeats; 
  final int rows;

  const CongressChart({
    super.key,
    required this.partySeats,
    this.rows = 5,
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

    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);

      final seatPositions = _calculateSeatPositions(size, widget.rows, allSeats.length);

      return InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        onInteractionUpdate: (details) {
          setState(() => scale = details.scale);
        },
        child: GestureDetector(
          onTapDown: (details) {
            final tapPos = details.localPosition;
            const tapRadius = 10.0;
            for (int i = 0; i < seatPositions.length; i++) {
              if ((seatPositions[i] - tapPos).distance <= tapRadius) {
                setState(() => tappedIndex = i);
                showModalBottomSheet(
                  context: context,
                  builder: (_) => _SeatDetails(politician: allSeats[i]),
                );
                break;
              }
            }
          },
          child: CustomPaint(
            painter: _HemicyclePainter(
              widget.partySeats,
              widget.rows,
              tappedIndex,
              seatPositions,
              allSeats,
              scale,
            ),
            size: size,
          ),
        ),
      );
    });
  }

  List<Offset> _calculateSeatPositions(Size size, int rows, int totalSeats) {
    final positions = <Offset>[];
    final radiusStep = size.height / rows;
    int seatIndex = 0;

    for (int r = 0; r < rows; r++) {
      final radius = (r + 1) * radiusStep;
      final seatsInRow = (pi * radius / 15).floor();
      final angleStep = pi / (seatsInRow - 1);

      for (int i = 0; i < seatsInRow && seatIndex < totalSeats; i++) {
        final angle = pi - i * angleStep;
        final x = size.width / 2 + radius * cos(angle);
        final y = size.height - radius * sin(angle);
        positions.add(Offset(x, y));
        seatIndex++;
      }
    }
    return positions;
  }
}

class _HemicyclePainter extends CustomPainter {
  final Map<Color, List<Politician>> partySeats;
  final int rows;
  final int? tappedIndex;
  final List<Offset> seatPositions;
  final List<Politician> allSeats;
  final double zoomScale;

  _HemicyclePainter(this.partySeats, this.rows, this.tappedIndex,
      this.seatPositions, this.allSeats, this.zoomScale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final seatColors = <Color>[];
    for (final entry in partySeats.entries) {
      seatColors.addAll(List.filled(entry.value.length, entry.key));
    }

    // Draw each seat
    for (int i = 0; i < seatPositions.length && i < allSeats.length; i++) {
      paint.color = seatColors[i].withValues(alpha: i == tappedIndex ? 0.6 : 1.0);
      canvas.drawCircle(seatPositions[i], 6, paint);

      // Only show labels if zoomed in enough
      if (zoomScale > 2.5) {
        final label = allSeats[i].name;
        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 8 * min(zoomScale, 3), // slightly grow with zoom
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          seatPositions[i] +
              Offset(-textPainter.width / 2, -textPainter.height - 6),
        );
      }
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
              // Navigate to their page here
            },
            child: const Text("View Member Page"),
          ),
        ],
      ),
    );
  }
}
