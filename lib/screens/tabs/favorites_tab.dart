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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppTheme.screenPadding, 16, AppTheme.screenPadding, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorites',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textMain),
          ),
          const SizedBox(height: 4),
          const Text(
            'Followed Rwanda teams and bookmarked matches',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),

          if (isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.star_border_rounded, size: 48, color: AppTheme.textSecondary),
                    SizedBox(height: 10),
                    Text(
                      'No favorites added yet',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain, fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap the star icon on any match or team to add it here',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Followed Teams section
            if (favTeams.isNotEmpty) ...[
              const Text(
                'Followed Teams',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
              const SizedBox(height: 10),
              ...favTeams.map((t) => Card(
                    color: AppTheme.surfaceCard,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.filterBg,
                            radius: 18,
                            child: Text(
                              t.name.substring(0, 1),
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain, fontSize: 15),
                                ),
                                Text(
                                  '${t.city} • ${t.stadium}',
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                            icon: const Icon(Icons.star_rounded, color: AppTheme.primary, size: 22),
                            onPressed: () => _service.toggleFavoriteTeam(t.id),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 18),
            ],

            // Saved Matches grouped by Date
            if (favMatches.isNotEmpty) ...[
              const Text(
                'Saved Matches',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
              const SizedBox(height: 10),
              ...matchesByDate.entries.map((entry) {
                final date = entry.key;
                final list = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.filterBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...list.map((m) => Card(
                          color: AppTheme.surfaceCard,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.tournament,
                                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${m.teamA} vs ${m.teamB}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain, fontSize: 14),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${m.time} • ${m.stadium}',
                                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                if (m.score != null)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: AppTheme.filterBg, borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                      m.score!,
                                      style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                IconButton(
                                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                                  icon: const Icon(Icons.star_rounded, color: AppTheme.primary, size: 22),
                                  onPressed: () => _service.toggleFavoriteMatch(m.id),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ],
        ],
      ),
    );
  }
}
