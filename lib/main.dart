import 'package:flutter/material.dart';

void main() {
  runApp(SARDisasterApp());
}

class SARDisasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAR Safe Route Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF0F172A),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedFrequency = 'L-Band';
  String selectedPolarization = 'Multi-Polarization (HH+HV+VV)';
  String selectedAnalysisMode = 'Multi-frequency Analysis';
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1024) {
                    return _buildDesktopLayout();
                  } else {
                    return _buildMobileLayout();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.blue.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.all(16),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.satellite_alt, size: 24),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAR Safe Route Finder',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'NASA Space Apps Challenge',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 4),
                Text(
                  'Live',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: _buildControlPanel(),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildMapView(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildControlPanel(),
          SizedBox(height: 16),
          SizedBox(
            height: 500,
            child: _buildMapView(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSARConfiguration(),
          SizedBox(height: 16),
          _buildHazardAlerts(),
          SizedBox(height: 16),
          _buildSafeRoutes(),
        ],
      ),
    );
  }

  Widget _buildSARConfiguration() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radio, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'SAR Configuration',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Frequency Band',
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildFrequencyButton('L-Band'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildFrequencyButton('C-Band'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildFrequencyButton('X-Band'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Polarization',
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPolarization,
                isExpanded: true,
                padding: EdgeInsets.symmetric(horizontal: 12),
                dropdownColor: Color(0xFF1E293B),
                items: [
                  DropdownMenuItem(
                    value: 'Multi-Polarization (HH+HV+VV)',
                    child: Text('Multi-Polarization (HH+HV+VV)'),
                  ),
                  DropdownMenuItem(
                    value: 'HH - Horizontal',
                    child: Text('HH - Horizontal'),
                  ),
                  DropdownMenuItem(
                    value: 'VV - Vertical',
                    child: Text('VV - Vertical'),
                  ),
                  DropdownMenuItem(
                    value: 'HV - Cross-pol',
                    child: Text('HV - Cross-pol'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedPolarization = value!;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'AI Analysis Mode',
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedAnalysisMode,
                isExpanded: true,
                padding: EdgeInsets.symmetric(horizontal: 12),
                dropdownColor: Color(0xFF1E293B),
                items: [
                  DropdownMenuItem(
                    value: 'Multi-frequency Analysis',
                    child: Text('Multi-frequency Analysis'),
                  ),
                  DropdownMenuItem(
                    value: 'Flood Detection',
                    child: Text('Flood Detection'),
                  ),
                  DropdownMenuItem(
                    value: 'Landslide Risk',
                    child: Text('Landslide Risk'),
                  ),
                  DropdownMenuItem(
                    value: 'Structural Damage',
                    child: Text('Structural Damage'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedAnalysisMode = value!;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Running AI Analysis...'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flash_on, size: 18),
                  SizedBox(width: 8),
                  Text('Run AI Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyButton(String label) {
    final isSelected = selectedFrequency == label;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFrequency = label;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Color(0xFF334155),
        padding: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildHazardAlerts() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text(
                'Active Hazards',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildHazardCard(
            'Flood Zone Detected',
            'Northeast sector - 2.3km radius',
            Colors.red,
          ),
          SizedBox(height: 8),
          _buildHazardCard(
            'Unstable Terrain',
            'Western ridge - moderate risk',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildHazardCard(String title, String subtitle, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: color, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeRoutes() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                'Recommended Routes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildRouteCard(
            'Route A',
            'Via Southern Bypass - 4.2km',
            'Safe',
            Colors.green,
          ),
          SizedBox(height: 8),
          _buildRouteCard(
            'Route B',
            'Via Eastern Highway - 5.8km',
            'Optimal',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(String title, String subtitle, String badge, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected $title')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildTabButton('SAR Map', 0),
                    SizedBox(width: 8),
                    _buildTabButton('Layers', 1),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.navigation, size: 16),
                  label: Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF334155),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF0F172A),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 64, color: Colors.blue),
                        SizedBox(height: 16),
                        Text(
                          'SAR Map View',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Real-time satellite data visualization',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SAR Coverage',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Region: 25km²',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Last Update: 2 min ago',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildLegendItem(Colors.red, 'Hazard'),
                          SizedBox(width: 16),
                          _buildLegendItem(Colors.green, 'Safe Route'),
                          SizedBox(width: 16),
                          _buildLegendItem(Colors.blue, 'Alternative'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTab == index;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTab = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Color(0xFF334155),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}