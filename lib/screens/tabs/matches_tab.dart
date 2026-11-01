import 'package:flutter/material.dart';
import '../../services/rwanda_match_service.dart';
import '../../theme/app_theme.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> {
  final _service = RwandaMatchService();
  String _activeTab = 'Today'; // 'Today', 'Upcoming', 'Finished'
  String _selectedTournament = 'All Tournaments';

  final List<String> _tournaments = [
    'All Tournaments',
    'Rwanda Premier League',
    'Peace Cup Rwanda',
  ];

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

  void _openDetails(RwandaMatch m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: SingleChildScrollView(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    m.tournament,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.filterBg,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Text('Demo', style: TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Teams & Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.filterBg,
                          radius: 18,
                          child: Text(
                            m.teamA.substring(0, 1),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m.teamA,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                          ),
                        ),
                        if (m.score != null)
                          Text(
                            m.score!.split(':')[0].trim(),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.filterBg,
                          radius: 18,
                          child: Text(
                            m.teamB.substring(0, 1),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m.teamB,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                          ),
                        ),
                        if (m.score != null)
                          Text(
                            m.score!.split(':')[1].trim(),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Match Info
              Text('Stadium: ${m.stadium}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 4),
              Text('Date & Kick-off: ${m.date} • ${m.time}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Status: ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  if (m.isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.accentRed, borderRadius: BorderRadius.circular(4)),
                      child: const Text('LIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    )
                  else
                    Text(m.status, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 16),

              // Events: Goals, Cards, Substitutions
              const Text('Match Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
              const SizedBox(height: 8),
              if (m.events.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text('No match events recorded yet for this fixture.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ),
                )
              else
                ...m.events.map((ev) {
                  IconData icon;
                  Color iconColor;
                  if (ev.type == 'goal') {
                    icon = Icons.sports_soccer_rounded;
                    iconColor = AppTheme.primary;
                  } else if (ev.type == 'yellow_card') {
                    icon = Icons.crop_portrait_rounded;
                    iconColor = AppTheme.primary;
                  } else if (ev.type == 'red_card') {
                    icon = Icons.crop_portrait_rounded;
                    iconColor = AppTheme.accentRed;
                  } else {
                    icon = Icons.swap_horiz_rounded;
                    iconColor = AppTheme.textSecondary;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36,
                          child: Text('${ev.minute}\'', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 13)),
                        ),
                        Icon(icon, size: 16, color: iconColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${ev.player} (${ev.team})',
                            style: const TextStyle(color: AppTheme.textMain, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = _service.matches;
    final filtered = matches.where((m) {
      if (_selectedTournament != 'All Tournaments' && m.tournament != _selectedTournament) {
        return false;
      }
      if (_activeTab == 'Today') return m.date == 'Today';
      if (_activeTab == 'Upcoming') return m.date == 'Tomorrow';
      if (_activeTab == 'Finished') return m.score != null && !m.isLive;
      return true;
    }).toList();

    return RefreshIndicator(
      color: AppTheme.primary,
      backgroundColor: AppTheme.surfaceCard,
      onRefresh: _service.refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(AppTheme.screenPadding, 16, AppTheme.screenPadding, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Matches',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textMain),
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
            const SizedBox(height: 12),

            // Tournament Filter Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedTournament,
              dropdownColor: AppTheme.surfaceCard,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: AppTheme.surfaceCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
              ),
              items: _tournaments
                  .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13, color: AppTheme.textMain))))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedTournament = val);
              },
            ),
            const SizedBox(height: 12),

            // Tabs: Today, Upcoming, Finished
            Row(
              children: ['Today', 'Upcoming', 'Finished'].map((tab) {
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
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            if (filtered.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.sports_soccer_rounded, size: 40, color: AppTheme.textSecondary),
                      const SizedBox(height: 8),
                      Text(
                        'No matches found for $_activeTab',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pull down to refresh or switch filters',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filtered.map((m) {
                final isFav = _service.favoriteMatchIds.contains(m.id);
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
                              Expanded(
                                child: Text(m.teamA, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: AppTheme.filterBg, borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  m.score ?? 'VS',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  m.teamB,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m.stadium, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                              IconButton(
                                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                                icon: Icon(
                                  isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: isFav ? AppTheme.primary : AppTheme.textSecondary,
                                  size: 22,
                                ),
                                onPressed: () => _service.toggleFavoriteMatch(m.id),
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
      ),
    );
  }
}
