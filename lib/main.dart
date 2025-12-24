import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const SARDisasterApp());
}

class SARDisasterApp extends StatelessWidget {
  const SARDisasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String frequency = 'L-Band';
  String polarization = 'Multi-Polarization (HH+HV+VV)';
  String analysisMode = 'Multi-frequency Analysis';
  int selectedTab = 0;

  GoogleMapController? _mapController;

  /// ---------------- AI ANALYSIS FLOW ----------------
  void runAIAnalysis() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _LoadingDialog(),
    );

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (_) => const _ResultDialog(),
    );
  }

  void navigatePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigation Started (Demo)')),
    );
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _header(),
            Expanded(child: _content()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('SAR Safe Route Finder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 10),
                SizedBox(width: 6),
                Text('Live', style: TextStyle(color: Colors.green)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _sarConfig(),
          const SizedBox(height: 16),
          _hazards(),
          const SizedBox(height: 16),
          _routes(),
          const SizedBox(height: 16),
          _mapSection(),
        ],
      ),
    );
  }

  /// ---------------- SAR CONFIG ----------------
  Widget _sarConfig() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SAR Configuration',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          /// Frequency
          const Text('Frequency Band'),
          const SizedBox(height: 8),
          Row(
            children: [
              _freqBtn('L-Band'),
              _freqBtn('C-Band'),
              _freqBtn('X-Band'),
            ],
          ),

          const SizedBox(height: 16),

          /// Polarization
          const Text('Polarization'),
          const SizedBox(height: 8),
          _dropdown(
            polarization,
            [
              'Multi-Polarization (HH+HV+VV)',
              'HH - Horizontal',
              'VV - Vertical',
              'HV - Cross-pol',
            ],
                (v) => setState(() => polarization = v),
          ),

          const SizedBox(height: 16),

          /// AI Mode
          const Text('AI Analysis Mode'),
          const SizedBox(height: 8),
          _dropdown(
            analysisMode,
            [
              'Multi-frequency Analysis',
              'Flood Detection',
              'Landslide Risk',
              'Structural Damage',
            ],
                (v) => setState(() => analysisMode = v),
          ),

          const SizedBox(height: 16),

          /// Run AI
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flash_on),
              label: const Text('Run AI Analysis'),
              onPressed: runAIAnalysis,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- HAZARDS ----------------
  Widget _hazards() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Active Hazards',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _Hazard(
            title: 'Flood Zone Detected',
            sub: 'Northeast sector - 2.3km radius',
            color: Colors.red,
          ),
          SizedBox(height: 8),
          _Hazard(
            title: 'Unstable Terrain',
            sub: 'Western ridge - moderate risk',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  /// ---------------- ROUTES ----------------
  Widget _routes() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Recommended Routes',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _RouteCard(
            title: 'Route A',
            sub: 'Via Southern Bypass - 4.2km',
            badge: 'Safe',
            color: Colors.green,
          ),
          SizedBox(height: 8),
          _RouteCard(
            title: 'Route B',
            sub: 'Via Eastern Highway - 5.8km',
            badge: 'Optimal',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  /// ---------------- MAP ----------------
  Widget _mapSection() {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _tab('SAR Map', 0),
              _tab('Layers', 1),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: navigatePressed,
                icon: const Icon(Icons.navigation),
                label: const Text('Navigate'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(20.5937, 78.9629),
                zoom: 6,
              ),
              onMapCreated: (c) => _mapController = c,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- HELPERS ----------------
  Widget _freqBtn(String v) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          frequency == v ? Colors.blue : Colors.grey.shade800,
        ),
        onPressed: () => setState(() => frequency = v),
        child: Text(v),
      ),
    ),
  );

  Widget _dropdown(String value, List<String> items, Function(String) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF1E293B),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v!),
    );
  }

  Widget _tab(String t, int i) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTab == i
            ? Colors.blue
            : Colors.grey.shade800,
      ),
      onPressed: () => setState(() => selectedTab = i),
      child: Text(t),
    ),
  );

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}

/// ---------------- DIALOGS ----------------
class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      backgroundColor: Color(0xFF0F172A),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Analyzing SAR Data...'),
        ],
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F172A),
      title: const Text('AI Analysis Complete'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Flood Risk Detected (72%)',
              style: TextStyle(color: Colors.red)),
          Text('Landslide Probability: 6%',
              style: TextStyle(color: Colors.green)),
          Text('Structural Damage: 69%',
              style: TextStyle(color: Colors.orange)),
          SizedBox(height: 8),
          Text('Suggested Route: Eastern Highway - Avoid',
              style: TextStyle(color: Colors.red)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('OK'),
        )
      ],
    );
  }
}

/// ---------------- SMALL WIDGETS ----------------
class _Hazard extends StatelessWidget {
  final String title, sub;
  final Color color;

  const _Hazard(
      {required this.title, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: color)),
        Text(sub),
      ]),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final String title, sub, badge;
  final Color color;

  const _RouteCard(
      {required this.title,
        required this.sub,
        required this.badge,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color)),
                Text(sub),
              ],
            ),
          ),
          Chip(label: Text(badge)),
        ],
      ),
    );
  }
}
