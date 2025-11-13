import 'dart:math';
import 'package:agora_mobile/Pages/Dynamic_Pages/dynamic_politician.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agora_mobile/app_state.dart';

/// Lightweight politician data for chart display
class ChartMember {
  final String bioId;
  final String name;
  final String chamber;
  final String party;
  final String state;
  final int? district;

  ChartMember({
    required this.bioId,
    required this.name,
    required this.chamber,
    required this.party,
    required this.state,
    this.district,
  });

  factory ChartMember.fromJson(Map<String, dynamic> json) {
    return ChartMember(
      bioId: json['bio_id'] ?? '',
      name: json['name'] ?? '',
      chamber: json['chamber'] ?? '',
      party: json['party'] ?? '',
      state: json['state'] ?? '',
      district: json['district'],
    );
  }

  factory ChartMember.vacant(int index) {
    return ChartMember(
      bioId: 'vacant_$index',
      name: 'Vacant',
      chamber: '',
      party: '',
      state: '',
    );
  }

  bool get isVacant => name == 'Vacant';
}

/// Creates a hemicycle chart for selected congress and chamber
class CongressChart extends StatefulWidget {
  final Map<Color, List<ChartMember>> partySeats;
  final int totalSeatsExpected;
  final int congress;
  
  const CongressChart({
    super.key,
    required this.partySeats,
    required this.totalSeatsExpected,
    required this.congress,
  });

  @override
  State<CongressChart> createState() => _CongressChartState();
}

class _CongressChartState extends State<CongressChart> {
  int? tappedIndex;
  Color? selectedGroupColor;
  double scale = 1.0;
  final TransformationController controller = TransformationController();
  final GlobalKey _paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.value = Matrix4.identity()..scale(0.7);
      setState(() => scale = 0.7);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AgoraAppState>();

    // Reorder to put independents in the middle: Democrats, Independents, Republicans
    final democrats = widget.partySeats[Colors.blue] ?? [];
    final independents = widget.partySeats[Colors.green] ?? [];
    final republicans = widget.partySeats[Colors.red] ?? [];
    
    final allSeats = [...democrats, ...independents, ...republicans];

    if (allSeats.length < widget.totalSeatsExpected) {
      final vacantCount = widget.totalSeatsExpected - allSeats.length;
      allSeats.addAll(List.generate(
        vacantCount,
        (i) => ChartMember.vacant(i),
      ));
    }

    if (allSeats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    const seatRadius = 12.0;
    const minRowGap = seatRadius * 1.05;
    final totalSeats = allSeats.length;
    final rows = (sqrt(totalSeats / 1.8)).ceil();

    double maxRadius = 55 + seatRadius * 2;
    for (int r = 0; r < rows; r++) {
      maxRadius += minRowGap + seatRadius * 0.9;
    }

    final canvasWidth = maxRadius * 2 + 200;
    final canvasHeight = maxRadius + 200;
    final canvasSize = Size(canvasWidth, canvasHeight);

    return InteractiveViewer(
      transformationController: controller,
      panEnabled: true,
      scaleEnabled: true,
      minScale: 0.4,
      maxScale: 6,
      boundaryMargin: const EdgeInsets.all(400),
      constrained: false,
      onInteractionUpdate: (_) =>
          setState(() => scale = controller.value.getMaxScaleOnAxis()),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {
          final RenderBox? paintBox =
              _paintKey.currentContext?.findRenderObject() as RenderBox?;
          if (paintBox == null) return;
          final localPos = paintBox.globalToLocal(details.globalPosition);
          final seat = _HemicyclePainter.hitTestSeat(localPos);

          // Tap outside — deselect
          if (seat == null) {
            setState(() {
              tappedIndex = null;
              selectedGroupColor = null;
            });
            return;
          }

          final member = allSeats[seat.index];

          if (member.isVacant) {
            setState(() {
              tappedIndex = null;
              selectedGroupColor = null;
            });
            return;
          }

          // Only allow group selection when zoomed out
          if (scale <= 2.5) {
            Color? groupColor;
            for (final entry in widget.partySeats.entries) {
              if (entry.value.contains(member)) {
                groupColor = entry.key;
                break;
              }
            }
            setState(() {
              selectedGroupColor = groupColor;
              tappedIndex = null;
            });
          }
        },
        onLongPressStart: (details) async {
          // Long press only works when zoomed in
          if (scale <= 2.5) return;

          final RenderBox? paintBox =
              _paintKey.currentContext?.findRenderObject() as RenderBox?;
          if (paintBox == null) return;
          final localPos = paintBox.globalToLocal(details.globalPosition);
          final seat = _HemicyclePainter.hitTestSeat(localPos);

          if (seat == null) return;

          final member = allSeats[seat.index];
          if (member.isVacant) return;

          setState(() {
            tappedIndex = seat.index;
            selectedGroupColor = null;
          });
          
          // Fetch full politician data and open details
          final politician = await appState.queryPoliticianByBioId(member.bioId);
          
          if (politician != null && mounted) {
            appState.openDetails(
              DynamicPolitician(politician: politician), 
              true, 
              false
            );
          }
        },
        child: Container(
          width: canvasSize.width,
          height: canvasSize.height,
          color: Colors.transparent,
          child: CustomPaint(
            key: _paintKey,
            size: canvasSize,
            painter: _HemicyclePainter(
              partySeats: widget.partySeats,
              tappedIndex: tappedIndex,
              selectedGroupColor: selectedGroupColor,
              allSeats: allSeats,
              zoomScale: scale,
              appState: appState,
            ),
          ),
        ),
      ),
    );
  }
}

class _HemicyclePainter extends CustomPainter {
  final Map<Color, List<ChartMember>> partySeats;
  final Map<Color, String> parties = {
    Colors.blue: "\nDemocrats", 
    Colors.red: "\nRepublicans", 
    Colors.green: "\nIndependents"
  };
  final int? tappedIndex;
  final Color? selectedGroupColor;
  final List<ChartMember> allSeats;
  final double zoomScale;
  final AgoraAppState appState;

  static final List<_SeatHit> _seatHits = [];

  _HemicyclePainter({
    required this.partySeats,
    required this.tappedIndex,
    required this.selectedGroupColor,
    required this.allSeats,
    required this.zoomScale,
    required this.appState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height - 100);
    const seatRadius = 12.0;
    const minRowGap = seatRadius * 1.05;
    const seatSpacing = seatRadius * 2.1;
    _seatHits.clear();

    // Center circle
    canvas.drawCircle(center, 55, Paint()..color = Colors.white);

    // Group count
    if (selectedGroupColor != null) {
      final count = partySeats[selectedGroupColor]?.length ?? 0;
      final text = "$count${parties[selectedGroupColor]!}";

      const maxRadius = 55;
      double fontSize = 32;
      TextPainter tp;

      do {
        tp = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: selectedGroupColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout();

        fontSize -= 1;
      } while ((tp.width > maxRadius * 1.8 || tp.height > maxRadius * 1.8) && fontSize > 4);

      tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
    }

    final totalSeats = allSeats.length;
    final rows = (sqrt(totalSeats / 1.8)).ceil();

    // Compute positions
    double radius = 55 + seatRadius * 2;
    final rowCounts = <int>[];
    int remainingSeats = totalSeats;
    for (int r = 0; r < rows && remainingSeats > 0; r++) {
      final baseSeatsInRow = max((pi * radius / seatSpacing).floor(), 1);
      final seatsInRow = min(baseSeatsInRow, remainingSeats);
      rowCounts.add(seatsInRow);
      remainingSeats -= seatsInRow;
      radius += minRowGap + seatRadius * 0.9;
    }

    final seatPositions = <Offset>[];
    radius = 55 + seatRadius * 2;
    for (int r = 0; r < rowCounts.length; r++) {
      final seatsInRow = rowCounts[r];
      final angleStep = seatsInRow > 1 ? pi / (seatsInRow - 1) : pi / 2;
      for (int i = 0; i < seatsInRow; i++) {
        final angle = pi - i * angleStep;
        seatPositions.add(Offset(
          center.dx + radius * cos(angle),
          center.dy - radius * sin(angle),
        ));
      }
      radius += minRowGap + seatRadius * 0.9;
    }

    // Sort by x (column order)
    seatPositions.sort((a, b) {
      int cmpX = a.dx.compareTo(b.dx);
      if (cmpX != 0) return cmpX;
      return a.dy.compareTo(b.dy);
    });

    // Draw seats
    for (int i = 0; i < seatPositions.length && i < totalSeats; i++) {
      final pos = seatPositions[i];
      final member = allSeats[i];
      Color color = Colors.grey;
      bool inSelectedGroup = false;

      if (member.isVacant) {
        color = Colors.grey.shade700;
      } else {
        for (final entry in partySeats.entries) {
          if (entry.value.contains(member)) {
            color = entry.key;
            if (selectedGroupColor == entry.key) inSelectedGroup = true;
            break;
          }
        }
      }

      double opacity = 1.0;
      if (tappedIndex == i) {
        opacity = 0.6;
      } else if (selectedGroupColor != null && !inSelectedGroup) {
        opacity = 0.3;
      }

      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(pos, seatRadius, paint);
      _seatHits.add(_SeatHit(i, pos));

      // Label when zoomed in
      if (zoomScale > 2.5) {
        final label = member.isVacant
            ? "Vacant"
            : _formatName(member.name);
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.white,
              fontSize: seatRadius * 0.35,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        )..layout(maxWidth: seatRadius * 2);
        tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
      }
    }
  }

  String _formatName(String name) {
    // Format "Last, First" to "First Last"
    if (name.contains(',')) {
      final parts = name.split(',');
      final last = parts[0].trim();
      final first = parts.length > 1 ? parts[1].trim() : '';
      return first.isNotEmpty ? '$first $last' : last;
    }
    return name;
  }

  static _SeatHit? hitTestSeat(Offset tapPos) {
    for (final seat in _seatHits) {
      if ((tapPos - seat.position).distance < 18.0) return seat;
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant _HemicyclePainter oldDelegate) => true;
}

class _SeatHit {
  final int index;
  final Offset position;
  _SeatHit(this.index, this.position);
}