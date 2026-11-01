import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MatchItem {
  final String id;
  final String tournament;
  final String teamA;
  final String teamB;
  final String time;
  final String? score;
  final bool isLive;
  final String date;
  final String stadium;

  const MatchItem({
    required this.id,
    required this.tournament,
    required this.teamA,
    required this.teamB,
    required this.time,
    this.score,
    this.isLive = false,
    required this.date,
    required this.stadium,
  });
}

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});
  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  String _activeTab = 'Today';
  final Set<String> _favs = {'rw_m1'};

  final List<MatchItem> _matches = const [
    MatchItem(
      id: 'rw_m1',
      tournament: 'Rwanda Premier League',
      teamA: 'APR FC',
      teamB: 'Rayon Sports',
      time: '15:30',
      score: '2 : 1',
      isLive: true,
      date: 'Today',
      stadium: 'Kigali Pelé Stadium',
    ),
    MatchItem(
      id: 'rw_m2',
      tournament: 'Rwanda Premier League',
      teamA: 'Kiyovu Sports',
      teamB: 'Police FC',
      time: '18:00',
      score: null,
      isLive: false,
      date: 'Today',
      stadium: 'Nyamirambo Regional Stadium',
    ),
    MatchItem(
      id: 'rw_m3',
      tournament: 'Peace Cup Rwanda',
      teamA: 'Mukura Victory',
      teamB: 'AS Kigali',
      time: '16:00',
      score: null,
      isLive: false,
      date: 'Tomorrow',
      stadium: 'Huye Stadium',
    ),
    MatchItem(
      id: 'rw_m4',
      tournament: 'Rwanda Premier League',
      teamA: 'Musanze FC',
      teamB: 'Gasogi United',
      time: '15:00',
      score: '1 : 1',
      isLive: false,
      date: 'Yesterday',
      stadium: 'Ubworoherane Stadium',
    ),
  ];

  void _openDetails(MatchItem m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(m.tournament, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
            const SizedBox(height: 12),
            if (m.score != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.filterBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Score: ${m.score}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary)),
              ),
              const SizedBox(height: 12),
            ],
            Text('Stadium: ${m.stadium}', style: const TextStyle(color: AppTheme.textSecondary)),
            Text('Status: ${m.isLive ? "LIVE In-Play" : (m.score != null ? "Finished" : "Scheduled (${m.time})")}', style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 16),
            const Text('Demo match data for Rwanda football fans.', style: TextStyle(color: AppTheme.border, fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _matches.where((m) {
      if (_activeTab == 'Today') return m.date == 'Today';
      if (_activeTab == 'Upcoming') return m.date == 'Tomorrow';
      return m.score != null;
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppTheme.screenPadding, 16, AppTheme.screenPadding, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Matches',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.filterBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Text('Rwanda RPL', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: ['Today', 'Upcoming', 'Results'].map((tab) {
              final active = _activeTab == tab;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(tab),
                  selected: active,
                  onSelected: (_) => setState(() => _activeTab = tab),
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.filterBg,
                  labelStyle: TextStyle(
                    color: active ? AppTheme.buttonTextDark : AppTheme.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ...filtered.map((m) {
            final isFav = _favs.contains(m.id);
            return Card(
              color: AppTheme.surfaceCard,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _openDetails(m),
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m.tournament, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          if (m.isLive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppTheme.accentRed, borderRadius: BorderRadius.circular(4)),
                              child: const Text('LIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            )
                          else
                            Text(m.time, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(m.teamA, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: AppTheme.filterBg, borderRadius: BorderRadius.circular(8)),
                            child: Text(m.score ?? 'VS', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                          ),
                          Expanded(child: Text(m.teamB, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m.stadium, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          IconButton(
                            icon: Icon(isFav ? Icons.star_rounded : Icons.star_outline_rounded, color: isFav ? AppTheme.primary : AppTheme.textSecondary, size: 20),
                            onPressed: () => setState(() => isFav ? _favs.remove(m.id) : _favs.add(m.id)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
