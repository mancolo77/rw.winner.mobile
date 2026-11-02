import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchEventItem {
  final int minute;
  final String type; // 'goal', 'yellow_card', 'red_card', 'sub'
  final String player;
  final String team;

  const MatchEventItem({
    required this.minute,
    required this.type,
    required this.player,
    required this.team,
  });

  Map<String, dynamic> toJson() => {
        'minute': minute,
        'type': type,
        'player': player,
        'team': team,
      };

  factory MatchEventItem.fromJson(Map<String, dynamic> json) => MatchEventItem(
        minute: json['minute'] as int,
        type: json['type'] as String,
        player: json['player'] as String,
        team: json['team'] as String,
      );
}

class RwandaMatch {
  final String id;
  final String tournament;
  final String teamA;
  final String teamB;
  final String date; // YYYY-MM-DD
  final String time;
  final String stadium;
  final String? score;
  final bool isLive;
  final String status;
  final List<MatchEventItem> events;

  const RwandaMatch({
    required this.id,
    required this.tournament,
    required this.teamA,
    required this.teamB,
    required this.date,
    required this.time,
    required this.stadium,
    this.score,
    this.isLive = false,
    required this.status,
    this.events = const [],
  });
}

class RwandaTeam {
  final String id;
  final String name;
  final String city;
  final String stadium;
  final int titles;
  final List<String> recentResults;
  final List<String> upcomingMatches;

  const RwandaTeam({
    required this.id,
    required this.name,
    required this.city,
    required this.stadium,
    required this.titles,
    required this.recentResults,
    required this.upcomingMatches,
  });
}

class RwandaMatchService with ChangeNotifier {
  static final RwandaMatchService _instance = RwandaMatchService._internal();
  factory RwandaMatchService() => _instance;
  RwandaMatchService._internal();

  final Set<String> _favoriteMatchIds = {'rw_m1'};
  final Set<String> _favoriteTeamIds = {'t_apr'};
  DateTime _lastUpdated = DateTime.now();

  Set<String> get favoriteMatchIds => Set.unmodifiable(_favoriteMatchIds);
  Set<String> get favoriteTeamIds => Set.unmodifiable(_favoriteTeamIds);
  DateTime get lastUpdated => _lastUpdated;

  final List<RwandaTeam> teams = const [
    RwandaTeam(
      id: 't_apr',
      name: 'APR FC',
      city: 'Kigali',
      stadium: 'Kigali Pelé Stadium',
      titles: 21,
      recentResults: ['W 2-0 vs Police', 'W 3-1 vs Mukura', 'D 1-1 vs Rayon'],
      upcomingMatches: ['vs Rayon Sports (Today 15:30)', 'vs AS Kigali (Nov 8)'],
    ),
    RwandaTeam(
      id: 't_rayon',
      name: 'Rayon Sports',
      city: 'Nyanza / Kigali',
      stadium: 'Kigali Pelé Stadium',
      titles: 9,
      recentResults: ['W 1-0 vs Kiyovu', 'L 1-2 vs APR FC', 'W 2-1 vs Gasogi'],
      upcomingMatches: ['vs APR FC (Today 15:30)', 'vs Musanze (Nov 9)'],
    ),
    RwandaTeam(
      id: 't_kiyovu',
      name: 'Kiyovu Sports',
      city: 'Kigali',
      stadium: 'Mumena Stadium',
      titles: 3,
      recentResults: ['D 0-0 vs Police', 'W 1-0 vs Bugesera', 'L 0-1 vs Rayon'],
      upcomingMatches: ['vs Police FC (Today 18:00)', 'vs Gorilla FC (Nov 8)'],
    ),
    RwandaTeam(
      id: 't_police',
      name: 'Police FC',
      city: 'Kibungo / Kigali',
      stadium: 'Kicukiro Stadium',
      titles: 1,
      recentResults: ['L 0-2 vs APR', 'D 0-0 vs Kiyovu', 'W 3-0 vs Marines'],
      upcomingMatches: ['vs Kiyovu Sports (Today 18:00)', 'vs Mukura (Nov 9)'],
    ),
    RwandaTeam(
      id: 't_mukura',
      name: 'Mukura Victory Sports',
      city: 'Huye',
      stadium: 'Huye Stadium',
      titles: 2,
      recentResults: ['W 2-1 vs AS Kigali', 'L 1-3 vs APR', 'W 1-0 vs Etincelles'],
      upcomingMatches: ['vs AS Kigali (Tomorrow 16:00)', 'vs Police FC (Nov 9)'],
    ),
    RwandaTeam(
      id: 't_askigali',
      name: 'AS Kigali',
      city: 'Kigali',
      stadium: 'Nyamirambo Stadium',
      titles: 1,
      recentResults: ['L 1-2 vs Mukura', 'W 2-0 vs Gorilla', 'D 1-1 vs Musanze'],
      upcomingMatches: ['vs Mukura Victory (Tomorrow 16:00)', 'vs APR FC (Nov 8)'],
    ),
    RwandaTeam(
      id: 't_musanze',
      name: 'Musanze FC',
      city: 'Musanze',
      stadium: 'Ubworoherane Stadium',
      titles: 0,
      recentResults: ['D 1-1 vs Gasogi', 'W 1-0 vs Bugesera', 'L 1-2 vs Rayon'],
      upcomingMatches: ['vs Bugesera (Nov 6)', 'vs Rayon Sports (Nov 9)'],
    ),
    RwandaTeam(
      id: 't_gasogi',
      name: 'Gasogi United',
      city: 'Kigali',
      stadium: 'Kigali Pelé Stadium',
      titles: 0,
      recentResults: ['D 1-1 vs Musanze', 'L 1-2 vs Rayon', 'W 2-0 vs Marines'],
      upcomingMatches: ['vs Gorilla FC (Nov 6)', 'vs Kiyovu (Nov 10)'],
    ),
  ];

  final List<RwandaMatch> matches = const [
    RwandaMatch(
      id: 'rw_m1',
      tournament: 'Rwanda Premier League',
      teamA: 'APR FC',
      teamB: 'Rayon Sports',
      date: 'Today',
      time: '15:30',
      stadium: 'Kigali Pelé Stadium',
      score: '2 : 1',
      isLive: true,
      status: 'In-Play (78\')',
      events: [
        MatchEventItem(minute: 14, type: 'goal', player: 'V. Omborenga', team: 'APR FC'),
        MatchEventItem(minute: 38, type: 'yellow_card', player: 'K. Muhire', team: 'Rayon Sports'),
        MatchEventItem(minute: 54, type: 'goal', player: 'L. Esomba', team: 'Rayon Sports'),
        MatchEventItem(minute: 71, type: 'goal', player: 'G. Mugisha', team: 'APR FC'),
        MatchEventItem(minute: 75, type: 'sub', player: 'A. Nshuti in / P. Bizimana out', team: 'APR FC'),
      ],
    ),
    RwandaMatch(
      id: 'rw_m2',
      tournament: 'Rwanda Premier League',
      teamA: 'Kiyovu Sports',
      teamB: 'Police FC',
      date: 'Today',
      time: '18:00',
      stadium: 'Mumena Stadium',
      score: null,
      isLive: false,
      status: 'Scheduled',
      events: [],
    ),
    RwandaMatch(
      id: 'rw_m3',
      tournament: 'Peace Cup Rwanda',
      teamA: 'Mukura Victory',
      teamB: 'AS Kigali',
      date: 'Tomorrow',
      time: '16:00',
      stadium: 'Huye Stadium',
      score: null,
      isLive: false,
      status: 'Upcoming',
      events: [],
    ),
    RwandaMatch(
      id: 'rw_m4',
      tournament: 'Rwanda Premier League',
      teamA: 'Musanze FC',
      teamB: 'Gasogi United',
      date: 'Yesterday',
      time: '15:00',
      stadium: 'Ubworoherane Stadium',
      score: '1 : 1',
      isLive: false,
      status: 'Full Time',
      events: [
        MatchEventItem(minute: 29, type: 'goal', player: 'P. Munyeshyaka', team: 'Musanze FC'),
        MatchEventItem(minute: 62, type: 'yellow_card', player: 'E. Kaneza', team: 'Gasogi United'),
        MatchEventItem(minute: 83, type: 'goal', player: 'C. Herron', team: 'Gasogi United'),
      ],
    ),
    RwandaMatch(
      id: 'rw_m5',
      tournament: 'Rwanda Premier League',
      teamA: 'Police FC',
      teamB: 'Marines FC',
      date: 'Yesterday',
      time: '17:30',
      stadium: 'Kicukiro Stadium',
      score: '3 : 0',
      isLive: false,
      status: 'Full Time',
      events: [
        MatchEventItem(minute: 12, type: 'goal', player: 'D. Usengimana', team: 'Police FC'),
        MatchEventItem(minute: 44, type: 'goal', player: 'M. Sibomana', team: 'Police FC'),
        MatchEventItem(minute: 88, type: 'goal', player: 'A. Hakizimana', team: 'Police FC'),
      ],
    ),
    RwandaMatch(
      id: 'rw_m6',
      tournament: 'Peace Cup Rwanda',
      teamA: 'Gorilla FC',
      teamB: 'Bugesera FC',
      date: 'Tomorrow',
      time: '18:30',
      stadium: 'Kigali Pelé Stadium',
      score: null,
      isLive: false,
      status: 'Upcoming',
      events: [],
    ),
  ];

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favMatches = prefs.getStringList('fav_matches_rw');
      if (favMatches != null) {
        _favoriteMatchIds.clear();
        _favoriteMatchIds.addAll(favMatches);
      }
      final favTeams = prefs.getStringList('fav_teams_rw');
      if (favTeams != null) {
        _favoriteTeamIds.clear();
        _favoriteTeamIds.addAll(favTeams);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_matches_rw', _favoriteMatchIds.toList());
      await prefs.setStringList('fav_teams_rw', _favoriteTeamIds.toList());
    } catch (_) {}
  }

  void toggleFavoriteMatch(String id) {
    if (_favoriteMatchIds.contains(id)) {
      _favoriteMatchIds.remove(id);
    } else {
      _favoriteMatchIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleFavoriteTeam(String id) {
    if (_favoriteTeamIds.contains(id)) {
      _favoriteTeamIds.remove(id);
    } else {
      _favoriteTeamIds.add(id);
    }
    _save();
    notifyListeners();
  }

  Future<void> refresh() => refreshData();

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _lastUpdated = DateTime.now();
    notifyListeners();
  }
}
