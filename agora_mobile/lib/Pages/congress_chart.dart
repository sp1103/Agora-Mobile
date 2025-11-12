import 'dart:math';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:agora_mobile/Types/politician.dart';
import 'package:provider/provider.dart';

class CongressChart extends StatefulWidget {
  final Map<Color, List<Politician>> partySeats;
  const CongressChart({super.key, required this.partySeats});

  @override
  State<CongressChart> createState() => _CongressChartState();
}

class _CongressChartState extends State<CongressChart> {
  int? tappedIndex;
  double scale = 1.0;
  Offset? tappedPos;
  TransformationController controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    final allSeats = widget.partySeats.values.expand((x) => x).toList();
    var appState = context.watch<AgoraAppState>();
    final canvasSize = Size(600, 400);

    return InteractiveViewer(
      transformationController: controller,
      panEnabled: true,
      scaleEnabled: true,
      minScale: 1,
      maxScale: 6,
      boundaryMargin: const EdgeInsets.all(0),
      onInteractionUpdate: (details) {
        setState(() => scale = controller.value.getMaxScaleOnAxis());
      },
      child: GestureDetector(
        onTapDown: (details) {
          // convert tap to chart-local coordinates accounting for pan/zoom
          final localPos = controller.toScene(details.localPosition);
          final seat = _HemicyclePainter.hitTestSeat(localPos, allSeats.length);
          if (seat != null) {
            setState(() {
              tappedIndex = seat.index;
              tappedPos = seat.position;
            });
          }
        },
        child: CustomPaint(
          size: canvasSize,
          painter: _HemicyclePainter(
            widget.partySeats,
            tappedIndex,
            allSeats,
            scale,
            tappedPos,
            appState,
          ),
        ),
      ),
    );
  }
}

class _HemicyclePainter extends CustomPainter {
  final Map<Color, List<Politician>> partySeats;
  final int? tappedIndex;
  final List<Politician> allSeats;
  final double zoomScale;
  final Offset? tappedPos;
  final AgoraAppState appState;

  _HemicyclePainter(
    this.partySeats,
    this.tappedIndex,
    this.allSeats,
    this.zoomScale,
    this.tappedPos,
    this.appState,
  );

  static final List<Offset> _lastSeatPositions = [];
  static final List<Color> _lastSeatColors = [];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height - 60);
    final seatRadius = 10.0;
    final minRowGap = seatRadius * 1.05;
    final seatSpacing = seatRadius * 2.1;

    canvas.drawCircle(center, 55, Paint()..color = Colors.white);

    // create a top-down, left-to-right color array
    final seatColors = <Color>[];
    int totalSeats = allSeats.length;
    final rows = (sqrt(totalSeats / 1.8)).ceil();
    double radius = 55 + seatRadius * 2;
    int seatIndex = 0;

    final rowCounts = <int>[];
    for (int r = 0; r < rows && seatIndex < totalSeats; r++) {
      final seatsInRow = max((pi * radius / seatSpacing).floor(), 1);
      rowCounts.add(seatsInRow);
      seatIndex += seatsInRow;
      radius += minRowGap + seatRadius * 0.9;
    }

    // assign colors top-down, left-right
    seatIndex = 0;
    radius = 55 + seatRadius * 2;
    _lastSeatPositions.clear();
    _lastSeatColors.clear();
    final partyList = partySeats.entries.toList();
    int colorIndex = 0;
    for (int r = 0; r < rowCounts.length; r++) {
      final seatsInRow = rowCounts[r];
      final angleStep = pi / (seatsInRow - 1);

      for (int i = 0; i < seatsInRow && seatIndex < totalSeats; i++) {
        final angle = pi - i * angleStep;
        final pos = Offset(
          center.dx + radius * cos(angle),
          center.dy - radius * sin(angle),
        );

        // pick color by sequentially going through party lists
        final colorEntry = partyList[colorIndex % partyList.length];
        final color = colorEntry.key;
        colorIndex++;
        seatColors.add(color);

        _lastSeatPositions.add(pos);
        _lastSeatColors.add(color);

        paint.color = color.withValues(alpha: seatIndex == tappedIndex ? 0.6 : 1.0);
        canvas.drawCircle(pos, seatRadius, paint);

        // label inside dot when zoomed
        if (zoomScale > 4.2) {
          final label = appState.formatPolticianName(allSeats[seatIndex].name);
          final textPainter = TextPainter(
            text: TextSpan(
              text: label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: seatRadius * 0.2,
                  fontWeight: FontWeight.bold),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(maxWidth: seatRadius * 2);
          final offset = pos -
              Offset(textPainter.width / 2, textPainter.height / 2);
          textPainter.paint(canvas, offset);
        }

        seatIndex++;
      }
      radius += minRowGap + seatRadius * 0.9;
    }
  }

  static _SeatHit? hitTestSeat(Offset tapPos, int totalSeats) {
    if (_lastSeatPositions.isEmpty) return null;
    for (int i = 0; i < _lastSeatPositions.length && i < totalSeats; i++) {
      if ((tapPos - _lastSeatPositions[i]).distance < 12.0) {
        return _SeatHit(i, _lastSeatPositions[i]);
      }
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SeatHit {
  final int index;
  final Offset position;
  _SeatHit(this.index, this.position);
}
