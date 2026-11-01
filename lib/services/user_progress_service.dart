import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProgressService with ChangeNotifier {
  static final UserProgressService _instance = UserProgressService._internal();
  factory UserProgressService() => _instance;
  UserProgressService._internal();

  int _points = 130;
  final Set<String> _savedArticleIds = {};
  final Set<String> _favoriteMatchIds = {};
  final Set<String> _unlockedBadges = {'badge_starter'};
  bool _dailyBonusClaimedToday = false;
  int _quizzesCompleted = 0;

  int get points => _points;
  Set<String> get savedArticleIds => _savedArticleIds;
  Set<String> get favoriteMatchIds => _favoriteMatchIds;
  Set<String> get unlockedBadges => _unlockedBadges;
  bool get dailyBonusClaimedToday => _dailyBonusClaimedToday;
  int get quizzesCompleted => _quizzesCompleted;

  String get levelName {
    if (_points >= 700) return ' ';
    if (_points >= 300) return '';
    return '';
  }

  int get levelNumber {
    if (_points >= 700) return 3;
    if (_points >= 300) return 2;
    return 1;
  }

  double get levelProgress {
    if (_points >= 700) return 1.0;
    if (_points >= 300) return (_points - 300) / 400.0;
    return _points / 300.0;
  }

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _points = prefs.getInt('user_points') ?? 130;
      _quizzesCompleted = prefs.getInt('quizzes_completed') ?? 0;

      final savedArticles = prefs.getStringList('saved_articles') ?? [];
      _savedArticleIds.addAll(savedArticles);

      final favMatches = prefs.getStringList('favorite_matches') ?? [];
      _favoriteMatchIds.addAll(favMatches);

      final badges = prefs.getStringList('unlocked_badges') ?? ['badge_starter'];
      _unlockedBadges.addAll(badges);

      final lastVisitDate = prefs.getString('last_visit_date') ?? '';
      final todayDate = DateTime.now().toIso8601String().substring(0, 10);
      _dailyBonusClaimedToday = (lastVisitDate == todayDate);

      if (!_dailyBonusClaimedToday) {
        _points += 50;
        _dailyBonusClaimedToday = true;
        await prefs.setString('last_visit_date', todayDate);
        await prefs.setInt('user_points', _points);
      }

      _checkBadges();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_points', _points);
      await prefs.setInt('quizzes_completed', _quizzesCompleted);
      await prefs.setStringList('saved_articles', _savedArticleIds.toList());
      await prefs.setStringList('favorite_matches', _favoriteMatchIds.toList());
      await prefs.setStringList('unlocked_badges', _unlockedBadges.toList());
    } catch (_) {}
  }

  void addPoints(int amount) {
    _points += amount;
    _checkBadges();
    _save();
    notifyListeners();
  }

  void recordQuizCompleted(int earnedPoints) {
    _quizzesCompleted++;
    _points += earnedPoints;
    _checkBadges();
    _save();
    notifyListeners();
  }

  void toggleSaveArticle(String id) {
    if (_savedArticleIds.contains(id)) {
      _savedArticleIds.remove(id);
    } else {
      _savedArticleIds.add(id);
    }
    _checkBadges();
    _save();
    notifyListeners();
  }

  void toggleFavoriteMatch(String id) {
    if (_favoriteMatchIds.contains(id)) {
      _favoriteMatchIds.remove(id);
    } else {
      _favoriteMatchIds.add(id);
    }
    _checkBadges();
    _save();
    notifyListeners();
  }

  void _checkBadges() {
    if (_quizzesCompleted >= 1) _unlockedBadges.add('badge_quiz_1');
    if (_savedArticleIds.isNotEmpty) _unlockedBadges.add('badge_reader');
    if (_points >= 300) _unlockedBadges.add('badge_amateur');
    if (_points >= 700) _unlockedBadges.add('badge_expert');
    if (_favoriteMatchIds.length >= 2) _unlockedBadges.add('badge_fan');
  }
}

