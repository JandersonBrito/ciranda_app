import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ciranda_button.dart';
import '../../../../models/festival_model.dart';

class FestivalMapSection extends StatefulWidget {
  const FestivalMapSection({super.key, required this.festival});

  final FestivalModel festival;

  @override
  State<FestivalMapSection> createState() => _FestivalMapSectionState();
}

class _FestivalMapSectionState extends State<FestivalMapSection> {
  GoogleMapController? _mapController;

  LatLng get _position => LatLng(
        widget.festival.latitude,
        widget.festival.longitude,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mapa
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _position,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId(widget.festival.id),
                position: _position,
                infoWindow: InfoWindow(
                  title: widget.festival.nome,
                  snippet: widget.festival.endereco,
                ),
              ),
            },
            onMapCreated: (controller) =>
                setState(() => _mapController = controller),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            mapToolbarEnabled: false,
            style: _darkMapStyle,
          ),
        ),

        // Ações
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.surfaceDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.festival.endereco,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CirandaButton.primary(
                      label: 'Google Maps',
                      icon: Icons.map_rounded,
                      onPressed: () => _openMaps('google'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CirandaButton.teal(
                      label: 'Waze',
                      icon: Icons.navigation_rounded,
                      onPressed: () => _openMaps('waze'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openMaps(String app) async {
    final lat = widget.festival.latitude;
    final lng = widget.festival.longitude;

    final url = app == 'waze'
        ? Uri.parse('waze://?ll=$lat,$lng&navigate=yes')
        : Uri.parse('https://maps.google.com?q=$lat,$lng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (app == 'waze') {
      // Fallback para web do Waze
      final webUrl = Uri.parse(
          'https://waze.com/ul?ll=$lat,$lng&navigate=yes');
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  // Estilo escuro para o mapa
  static const String _darkMapStyle = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#212121"}]},
  {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#212121"}]},
  {"featureType": "administrative", "elementType": "geometry", "stylers": [{"color": "#757575"}]},
  {"featureType": "administrative.country", "elementType": "labels.text.fill", "stylers": [{"color": "#9e9e9e"}]},
  {"featureType": "administrative.land_parcel", "stylers": [{"visibility": "off"}]},
  {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#bdbdbd"}]},
  {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
  {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#181818"}]},
  {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#616161"}]},
  {"featureType": "poi.park", "elementType": "labels.text.stroke", "stylers": [{"color": "#1b1b1b"}]},
  {"featureType": "road", "elementType": "geometry.fill", "stylers": [{"color": "#2c2c2c"}]},
  {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#8a8a8a"}]},
  {"featureType": "road.arterial", "elementType": "geometry", "stylers": [{"color": "#373737"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#3c3c3c"}]},
  {"featureType": "road.highway.controlled_access", "elementType": "geometry", "stylers": [{"color": "#4e4e4e"}]},
  {"featureType": "road.local", "elementType": "labels.text.fill", "stylers": [{"color": "#616161"}]},
  {"featureType": "transit", "elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#000000"}]},
  {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#3d3d3d"}]}
]
''';
}
