import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TeamData {
  final String name;
  final String city;
  final String stadium;
  final int titles;
  const TeamData({required this.name, required this.city, required this.stadium, required this.titles});
}

class TeamsTab extends StatefulWidget {
  const TeamsTab({super.key});
  @override
  State<TeamsTab> createState() => _TeamsTabState();
}

class _TeamsTabState extends State<TeamsTab> {
  String _search = '';
  final Set<String> _favTeams = {'APR FC'};

  final List<TeamData> _teams = const [
    TeamData(name: 'APR FC', city: 'Kigali', stadium: 'Kigali Pelé Stadium', titles: 21),
    TeamData(name: 'Rayon Sports', city: 'Nyanza / Kigali', stadium: 'Kigali Pelé Stadium', titles: 9),
    TeamData(name: 'Kiyovu Sports', city: 'Kigali', stadium: 'Mumena Stadium', titles: 3),
    TeamData(name: 'Police FC', city: 'Kibungo', stadium: 'Kicukiro Stadium', titles: 1),
    TeamData(name: 'Mukura Victory', city: 'Huye', stadium: 'Huye Stadium', titles: 2),
    TeamData(name: 'AS Kigali', city: 'Kigali', stadium: 'Nyamirambo Stadium', titles: 1),
    TeamData(name: 'Musanze FC', city: 'Musanze', stadium: 'Ubworoherane Stadium', titles: 0),
    TeamData(name: 'Gasogi United', city: 'Kigali', stadium: 'Kigali Pelé Stadium', titles: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _teams.where((t) => t.name.toLowerCase().contains(_search.toLowerCase())).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppTheme.screenPadding, 16, AppTheme.screenPadding, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Teams', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
          const SizedBox(height: 12),
          TextField(
            style: const TextStyle(color: AppTheme.textMain),
            decoration: InputDecoration(
              hintText: 'Search club...',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
              prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
              filled: true,
              fillColor: AppTheme.surfaceCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius), borderSide: BorderSide.none),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
          const SizedBox(height: 16),
          ...filtered.map((t) {
            final isFav = _favTeams.contains(t.name);
            return Card(
              color: AppTheme.surfaceCard,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.filterBg,
                  child: Text(t.name.substring(0, 1), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                ),
                title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                subtitle: Text('${t.city} • ${t.stadium}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.star_rounded : Icons.star_outline_rounded, color: isFav ? AppTheme.primary : AppTheme.textSecondary),
                  onPressed: () => setState(() => isFav ? _favTeams.remove(t.name) : _favTeams.add(t.name)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
