import 'package:flutter/material.dart';
import '../../services/rwanda_match_service.dart';
import '../../theme/app_theme.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final _service = RwandaMatchService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favMatchIds = _service.favoriteMatchIds;
    final favTeamIds = _service.favoriteTeamIds;

    final favMatches = _service.matches.where((m) => favMatchIds.contains(m.id)).toList();
    final favTeams = _service.teams.where((t) => favTeamIds.contains(t.id)).toList();

    // Group favorite matches by date
    final Map<String, List<RwandaMatch>> matchesByDate = {};
    for (var m in favMatches) {
      matchesByDate.putIfAbsent(m.date, () => []).add(m);
    }

    final isEmpty = favMatches.isEmpty && favTeams.isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('My Favorites', style: TextStyle(color: AppTheme.textMain, fontSize: 19, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.star_outline_rounded, size: 54, color: AppTheme.textSecondary),
                    SizedBox(height: 14),
                    Text(
                      'No Favorites Saved',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the star icon on any match or club to follow their schedule here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Followed Clubs Carousel
                  if (favTeams.isNotEmpty) ...[
                    const Text('Followed Clubs', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: favTeams.map((t) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.border.withValues(alpha: 0.4)),
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppTheme.primary,
                                  child: Text(t.name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.buttonTextDark)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  t.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  t.city,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],

                  // Saved Matches Grouped by Date
                  if (matchesByDate.isNotEmpty) ...[
                    const Text('Bookmarked Matches', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...matchesByDate.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(top: 6, bottom: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.filterBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              entry.key,
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          ...entry.value.map((m) => Card(
                                color: AppTheme.surfaceCard,
                                margin: const EdgeInsets.only(bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                                  side: BorderSide(color: AppTheme.border.withValues(alpha: 0.4)),
                                ),
                                child: ListTile(
                                  title: Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain, fontSize: 14)),
                                  subtitle: Text('${m.tournament} • ${m.time}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(m.score ?? m.status, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                      IconButton(
                                        icon: const Icon(Icons.star_rounded, color: AppTheme.primary),
                                        onPressed: () => _service.toggleFavoriteMatch(m.id),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      );
                    }),
                  ],
                ],
              ),
      ),
    );
  }
}
