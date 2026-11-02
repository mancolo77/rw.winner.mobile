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
                  width: 44,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.filterBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      m.tournament,
                      style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (m.isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    Text(
                      m.status,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Match Scoreboard Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppTheme.filterBg,
                            child: Text(
                              _getInitials(m.teamA),
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            m.teamA,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMain),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          if (m.score != null)
                            Text(
                              m.score!,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.primary),
                            )
                          else
                            Text(
                              m.time,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            m.date,
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppTheme.filterBg,
                            child: Text(
                              _getInitials(m.teamB),
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            m.teamB,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMain),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(m.stadium, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 24),
              const Text(
                'Match Events & Timeline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textMain),
              ),
              const SizedBox(height: 12),
              if (m.events.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'No timeline events available for this fixture yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                )
              else
                ...m.events.map((e) {
                  IconData iconData = Icons.sports_soccer;
                  Color iconColor = Colors.white;
                  if (e.type == 'yellow_card') {
                    iconData = Icons.square;
                    iconColor = Colors.amber;
                  } else if (e.type == 'red_card') {
                    iconData = Icons.square;
                    iconColor = AppTheme.accentRed;
                  } else if (e.type == 'sub') {
                    iconData = Icons.swap_horiz;
                    iconColor = AppTheme.primary;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.filterBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${e.minute}'",
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(iconData, size: 16, color: iconColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.player,
                            style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                        Text(
                          e.team,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.substring(0, name.length >= 3 ? 3 : name.length).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    var matches = _service.matches;

    // Filter by tab
    if (_activeTab == 'Today') {
      matches = matches.where((m) => m.date == 'Today' || m.isLive).toList();
    } else if (_activeTab == 'Upcoming') {
      matches = matches.where((m) => m.date != 'Today' && !m.isLive && m.score == null).toList();
    } else if (_activeTab == 'Finished') {
      matches = matches.where((m) => m.score != null && !m.isLive).toList();
    }

    // Filter by tournament
    if (_selectedTournament != 'All Tournaments') {
      matches = matches.where((m) => m.tournament == _selectedTournament).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rwanda Match Center',
              style: TextStyle(color: AppTheme.textMain, fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Text(
              'Updated ${_service.lastUpdated.hour.toString().padLeft(2, '0')}:${_service.lastUpdated.minute.toString().padLeft(2, '0')} • Local Time',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Demo',
                style: TextStyle(color: AppTheme.buttonTextDark, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _service.refresh,
        color: AppTheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Tab Control [ Today | Upcoming | Finished ]
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: ['Today', 'Upcoming', 'Finished'].map((tab) {
                    final isSel = _activeTab == tab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeTab = tab),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSel ? AppTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isSel ? AppTheme.buttonTextDark : AppTheme.textSecondary,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Tournament Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _tournaments.map((tour) {
                    final isSel = _selectedTournament == tour;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tour),
                        selected: isSel,
                        selectedColor: AppTheme.filterBg,
                        backgroundColor: AppTheme.background,
                        side: BorderSide(color: isSel ? AppTheme.primary : AppTheme.border.withValues(alpha: 0.5)),
                        labelStyle: TextStyle(
                          color: isSel ? AppTheme.primary : AppTheme.textSecondary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _selectedTournament = tour),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Matches List
              if (matches.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.sports_soccer_outlined, size: 48, color: AppTheme.textSecondary),
                      SizedBox(height: 12),
                      Text(
                        'No matches found for this selection.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                )
              else
                ...matches.map((m) => _buildMatchCard(m)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(RwandaMatch m) {
    final isFav = _service.favoriteMatchIds.contains(m.id);
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        side: BorderSide(color: AppTheme.border.withValues(alpha: 0.4)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () => _openDetails(m),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // Tournament header & LIVE / Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    m.tournament,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      if (m.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            m.status,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        )
                      else
                        Text(
                          m.status,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _service.toggleFavoriteMatch(m.id),
                        child: Icon(
                          isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: isFav ? AppTheme.primary : AppTheme.textSecondary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 18),

              // VS Scoreboard row
              Row(
                children: [
                  // Team A
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(
                            _getInitials(m.teamA),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          m.teamA,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMain),
                        ),
                      ],
                    ),
                  ),

                  // Center Score or Time Box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        children: [
                          if (m.score != null)
                            Text(
                              m.score!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primary,
                              ),
                            )
                          else
                            Text(
                              m.time,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            m.date,
                            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Team B
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(
                            _getInitials(m.teamB),
                            style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          m.teamB,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMain),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Stadium footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      m.stadium,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
