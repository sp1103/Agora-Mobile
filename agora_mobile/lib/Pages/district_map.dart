// AI GENERATED CODE START
import 'dart:convert';
import 'package:agora_mobile/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class DistrictMap extends StatefulWidget {
  const DistrictMap({super.key});

  @override
  State<DistrictMap> createState() => _DistrictMapState();
}

class _DistrictMapState extends State<DistrictMap> {
  final MapController _mapController = MapController();
  String? selectedState;
  List<Polygon> _districtPolygons = [];
  String? _selectedDistrict;

  final Map<String, Map<String, dynamic>> stateInfo = {
    "Alabama": {"center": LatLng(32.8067, -86.7911), "zoom": 6.5},
    "Alaska": {"center": LatLng(64.2008, -149.4937), "zoom": 3.8},
    "Arizona": {"center": LatLng(34.0489, -111.0937), "zoom": 6.3},
    "Arkansas": {"center": LatLng(34.9697, -92.3731), "zoom": 6.7},
    "California": {"center": LatLng(36.7783, -119.4179), "zoom": 5.5},
    "Colorado": {"center": LatLng(39.5501, -105.7821), "zoom": 6.0},
    "Connecticut": {"center": LatLng(41.6032, -73.0877), "zoom": 7.5},
    "Delaware": {"center": LatLng(38.9108, -75.5277), "zoom": 8.0},
    "District of Columbia": {"center": LatLng(38.9072, -77.0369), "zoom": 10.0},
    "Florida": {"center": LatLng(27.6648, -81.5158), "zoom": 6.0},
    "Georgia": {"center": LatLng(32.1656, -82.9001), "zoom": 6.5},
    "Hawaii": {"center": LatLng(19.8968, -155.5828), "zoom": 6.3},
    "Idaho": {"center": LatLng(44.0682, -114.7420), "zoom": 6.0},
    "Illinois": {"center": LatLng(40.6331, -89.3985), "zoom": 6.3},
    "Indiana": {"center": LatLng(40.2672, -86.1349), "zoom": 6.7},
    "Iowa": {"center": LatLng(41.8780, -93.0977), "zoom": 6.5},
    "Kansas": {"center": LatLng(39.0119, -98.4842), "zoom": 6.3},
    "Kentucky": {"center": LatLng(37.8393, -84.2700), "zoom": 6.7},
    "Louisiana": {"center": LatLng(30.9843, -91.9623), "zoom": 6.5},
    "Maine": {"center": LatLng(45.2538, -69.4455), "zoom": 6.0},
    "Maryland": {"center": LatLng(39.0458, -76.6413), "zoom": 7.3},
    "Massachusetts": {"center": LatLng(42.4072, -71.3824), "zoom": 7.2},
    "Michigan": {"center": LatLng(44.3148, -85.6024), "zoom": 6.0},
    "Minnesota": {"center": LatLng(46.7296, -94.6859), "zoom": 6.2},
    "Mississippi": {"center": LatLng(32.3547, -89.3985), "zoom": 6.7},
    "Missouri": {"center": LatLng(37.9643, -91.8318), "zoom": 6.5},
    "Montana": {"center": LatLng(46.8797, -110.3626), "zoom": 5.8},
    "Nebraska": {"center": LatLng(41.4925, -99.9018), "zoom": 6.5},
    "Nevada": {"center": LatLng(38.8026, -116.4194), "zoom": 6.0},
    "New Hampshire": {"center": LatLng(43.1939, -71.5724), "zoom": 7.0},
    "New Jersey": {"center": LatLng(40.0583, -74.4057), "zoom": 7.0},
    "New Mexico": {"center": LatLng(34.5199, -105.8701), "zoom": 6.0},
    "New York": {"center": LatLng(43.2994, -74.2179), "zoom": 6.3},
    "North Carolina": {"center": LatLng(35.7596, -79.0193), "zoom": 6.5},
    "North Dakota": {"center": LatLng(47.5515, -101.0020), "zoom": 6.2},
    "Ohio": {"center": LatLng(40.4173, -82.9071), "zoom": 6.5},
    "Oklahoma": {"center": LatLng(35.4676, -97.5164), "zoom": 6.5},
    "Oregon": {"center": LatLng(43.8041, -120.5542), "zoom": 6.0},
    "Pennsylvania": {"center": LatLng(41.2033, -77.1945), "zoom": 6.5},
    "Rhode Island": {"center": LatLng(41.5801, -71.4774), "zoom": 8.0},
    "South Carolina": {"center": LatLng(33.8361, -81.1637), "zoom": 6.8},
    "South Dakota": {"center": LatLng(43.9695, -99.9018), "zoom": 6.4},
    "Tennessee": {"center": LatLng(35.5175, -86.5804), "zoom": 6.5},
    "Texas": {"center": LatLng(31.9686, -99.9018), "zoom": 5.4},
    "Utah": {"center": LatLng(39.3200, -111.0937), "zoom": 6.0},
    "Vermont": {"center": LatLng(44.5588, -72.5778), "zoom": 7.0},
    "Virginia": {"center": LatLng(37.4316, -78.6569), "zoom": 6.6},
    "Washington": {"center": LatLng(47.7511, -120.7401), "zoom": 6.0},
    "West Virginia": {"center": LatLng(38.5976, -80.4549), "zoom": 6.8},
    "Wisconsin": {"center": LatLng(43.7844, -88.7879), "zoom": 6.3},
    "Wyoming": {"center": LatLng(43.0759, -107.2903), "zoom": 6.0},
  };

  Future<void> _loadStateGeoJson(String state) async {
  final String path = 'assets/States/$state.geojson';
  try {
    final String data = await rootBundle.loadString(path);
    final Map<String, dynamic> geojson = jsonDecode(data);

    List features = geojson['features'];
    List<Polygon> polygons = [];

    for (var feature in features) {
      final geometry = feature['geometry'];
      final type = geometry['type'];

      String district = (feature['properties']['NAMELSAD'] ??
              feature['properties']['CD119FP'] ??
              feature['properties']['DISTRICT'] ??
              feature['properties']['district'] ??
              feature['properties']['CD'] ??
              'Unknown')
          .toString();

      if (type == 'Polygon') {
        for (var ring in geometry['coordinates']) {
          List<LatLng> points = ring
              .map<LatLng>(
                  (coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
              .toList();

          polygons.add(
            Polygon(
              points: points,
              color: Colors.blue.withValues(alpha: 0.3),
              borderStrokeWidth: 2.0,
              borderColor: Colors.blueAccent,
              label: district,
            ),
          );
        }
      } else if (type == 'MultiPolygon') {
        for (var poly in geometry['coordinates']) {
          for (var ring in poly) {
            List<LatLng> points = ring
                .map<LatLng>(
                    (coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
                .toList();

            polygons.add(
              Polygon(
                points: points,
                color: Colors.blue.withValues(alpha: 0.3),
                borderStrokeWidth: 2.0,
                borderColor: Colors.blueAccent,
                label: district,
              ),
            );
          }
        }
      }
    }

    setState(() {
      _districtPolygons = polygons;
    });
  } catch (e) {
    debugPrint("Error loading $path: $e");
  }
}

void _onMapTap(TapPosition tapPosition, LatLng latlng) {
  for (final poly in _districtPolygons) {
    if (_isPointInPolygon(latlng, poly.points)) {
      String district = poly.label ?? 'Unknown';
      setState(() {
        _selectedDistrict = district;
        // Rebuild polygons to refresh colors
        _districtPolygons = _districtPolygons.map((p) {
          return Polygon(
            points: p.points,
            color: (p.label == _selectedDistrict)
                ? Colors.orange.withValues(alpha: 0.4)
                : Colors.blue.withValues(alpha: 0.3),
            borderStrokeWidth: 2.0,
            borderColor: (p.label == _selectedDistrict) 
                          ? Colors.orangeAccent
                          : Colors.blueAccent,
            label: p.label,
          );
        }).toList();
      });

      showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            "State: $selectedState\nDistrict: $district",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
      break;
    }
  }
}


 bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j = polygon.length - 1;
    bool inside = false;
    for (i = 0; i < polygon.length; j = i++) {
      if (((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        inside = !inside;
      }
    }
    return inside;
  }

  void _onStateSelected(String? state) {
    if (state == null) return;
    setState(() {
      selectedState = state;
      _districtPolygons = [];
    });
    _loadStateGeoJson(state);

    final info = stateInfo[state];
    if (info != null) {
      _mapController.move(info['center'], info['zoom']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AgoraAppState>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: appState.closeDetails, icon: Icon(Icons.arrow_back, color: Colors.black)),
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedState,
              hint: const Text('Select a State'),
              isExpanded: true,
              items: stateInfo.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: _onStateSelected,
            ),
          ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(37.8, -96.9),
                initialZoom: 4.0,
                minZoom: 3,
                onTap: (tapPosition, latlng) => _onMapTap(tapPosition, latlng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolygonLayer(polygons: _districtPolygons),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// AI GENERATED CODE END