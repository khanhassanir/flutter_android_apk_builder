import 'package:flutter/foundation.dart';
import '../data/hive_boxes/hive_service.dart';
import '../data/models/assessment_result.dart';
import '../engine/pain_assessment_engine.dart';

class AssessmentProvider extends ChangeNotifier {
  int _step = 0;
  String? _selectedArea;
  String? _selectedPainType;
  int _intensity = 5;
  String? _duration;
  AssessmentResult? _result;
  bool _isAnalyzing = false;

  int get step => _step;
  String? get selectedArea => _selectedArea;
  String? get selectedPainType => _selectedPainType;
  int get intensity => _intensity;
  String? get duration => _duration;
  AssessmentResult? get result => _result;
  bool get isAnalyzing => _isAnalyzing;

  bool get canProceedStep0 => _selectedArea != null;
  bool get canProceedStep1 => _selectedPainType != null;
  bool get canProceedStep2 => _duration != null;

  void selectArea(String area) {
    _selectedArea = area;
    notifyListeners();
  }

  void selectPainType(String type) {
    _selectedPainType = type;
    notifyListeners();
  }

  void setIntensity(int value) {
    _intensity = value;
    notifyListeners();
  }

  void setDuration(String d) {
    _duration = d;
    notifyListeners();
  }

  void nextStep() {
    if (_step < 4) {
      _step++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_step > 0) {
      _step--;
      notifyListeners();
    }
  }

  Future<void> analyze(int userAge) async {
    _isAnalyzing = true;
    notifyListeners();

    // Simulate AI processing delay for UX effect
    await Future.delayed(const Duration(milliseconds: 2500));

    final output = PainAssessmentEngine.analyze(
      area: _selectedArea!,
      painType: _selectedPainType!,
      intensity: _intensity,
      duration: _duration!,
      age: userAge,
    );

    final now = DateTime.now();
    _result = AssessmentResult(
      id: '${now.millisecondsSinceEpoch}',
      date: now,
      area: _selectedArea!,
      painType: _selectedPainType!,
      intensity: _intensity,
      duration: _duration!,
      diagnosis: output.diagnosis,
      confidence: output.confidence,
      exerciseIds: output.exerciseIds,
      source: 'ai',
    );

    await _saveResult(_result!);
    _isAnalyzing = false;
    if (_step == 3) _step = 4;
    notifyListeners();
  }

  Future<void> _saveResult(AssessmentResult result) async {
    await HiveService.assessmentsBox.add(result);
    HiveService.assessmentCount = HiveService.assessmentCount + 1;
  }

  void reset() {
    _step = 0;
    _selectedArea = null;
    _selectedPainType = null;
    _intensity = 5;
    _duration = null;
    _result = null;
    _isAnalyzing = false;
    notifyListeners();
  }

  List<AssessmentResult> get allAssessments {
    return HiveService.assessmentsBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  AssessmentResult? get lastAssessment {
    final all = allAssessments;
    return all.isEmpty ? null : all.first;
  }

  void refresh() => notifyListeners();
}
