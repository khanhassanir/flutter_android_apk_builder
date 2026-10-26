class AssessmentOutput {
  final String diagnosis;
  final int confidence;
  final List<String> exerciseIds;

  const AssessmentOutput({
    required this.diagnosis,
    required this.confidence,
    required this.exerciseIds,
  });
}

class PainAssessmentEngine {
  static AssessmentOutput analyze({
    required String area,
    required String painType,
    required int intensity,
    required String duration,
    required int age,
  }) {
    switch (area) {
      case 'lower_back':
        return _lowerBack(painType, intensity, duration);
      case 'neck':
        return _neck(painType, intensity, duration);
      case 'shoulders':
        return _shoulders(painType, intensity, duration);
      case 'upper_back':
        return _upperBack(painType, intensity, duration);
      case 'hips':
        return _hips(painType, intensity, duration, age);
      case 'knees':
        return _knees(painType, intensity, duration, age);
      case 'ankles':
        return _ankles(painType, intensity, duration);
      default:
        return _generic();
    }
  }

  // ── LOWER BACK ────────────────────────────────────────────────
  static AssessmentOutput _lowerBack(
      String type, int intensity, String duration) {
    if (type == 'sharp' && intensity >= 7 && duration == 'today') {
      return const AssessmentOutput(
        diagnosis: 'Acute Lumbar Muscle Spasm',
        confidence: 87,
        exerciseIds: ['pelvic_tilts', 'knee_chest_stretch', 'supine_lumbar_rotation'],
      );
    }
    if (type == 'sharp' && (duration == 'weeks' || duration == 'months')) {
      return const AssessmentOutput(
        diagnosis: 'Lumbar Disc Irritation',
        confidence: 85,
        exerciseIds: ['prone_press_up', 'bird_dog', 'dead_bug'],
      );
    }
    if (type == 'stiffness' && intensity <= 5) {
      return const AssessmentOutput(
        diagnosis: 'Lumbar Muscle Tightness',
        confidence: 90,
        exerciseIds: ['cat_cow', 'pelvic_tilts', 'supine_lumbar_rotation'],
      );
    }
    if (type == 'stiffness' && intensity > 5) {
      return const AssessmentOutput(
        diagnosis: 'Facet Joint Irritation',
        confidence: 78,
        exerciseIds: ['knee_chest_stretch', 'cat_cow', 'childs_pose'],
      );
    }
    if (type == 'dull' && duration == 'months') {
      return const AssessmentOutput(
        diagnosis: 'Chronic Lower Back Strain',
        confidence: 82,
        exerciseIds: ['bird_dog', 'dead_bug', 'glute_bridges'],
      );
    }
    if (type == 'burning' || type == 'throbbing') {
      return const AssessmentOutput(
        diagnosis: 'Sciatic Nerve Irritation',
        confidence: 78,
        exerciseIds: ['prone_press_up', 'piriformis_stretch', 'bird_dog'],
      );
    }
    if (type == 'dull' && intensity <= 4) {
      return const AssessmentOutput(
        diagnosis: 'Postural Lower Back Strain',
        confidence: 84,
        exerciseIds: ['pelvic_tilts', 'cat_cow', 'standing_lumbar_extension'],
      );
    }
    return const AssessmentOutput(
      diagnosis: 'General Lower Back Pain',
      confidence: 72,
      exerciseIds: ['pelvic_tilts', 'cat_cow', 'knee_chest_stretch'],
    );
  }

  // ── NECK ──────────────────────────────────────────────────────────
  static AssessmentOutput _neck(String type, int intensity, String duration) {
    if (type == 'sharp' && intensity >= 7) {
      return const AssessmentOutput(
        diagnosis: 'Acute Cervical Strain',
        confidence: 84,
        exerciseIds: ['neck_tilt', 'chin_tucks', 'suboccipital_release'],
      );
    }
    if (type == 'sharp' && intensity < 7) {
      return const AssessmentOutput(
        diagnosis: 'Cervical Muscle Spasm',
        confidence: 80,
        exerciseIds: ['neck_rotation', 'scalene_stretch', 'upper_trap_stretch'],
      );
    }
    if (type == 'stiffness' && duration == 'today') {
      return const AssessmentOutput(
        diagnosis: 'Acute Torticollis (Wry Neck)',
        confidence: 83,
        exerciseIds: ['neck_rotation', 'neck_tilt', 'suboccipital_release'],
      );
    }
    if (type == 'stiffness' && (duration == 'weeks' || duration == 'months')) {
      return const AssessmentOutput(
        diagnosis: 'Chronic Cervical Tightness',
        confidence: 88,
        exerciseIds: ['chin_tucks', 'neck_isometric', 'levator_stretch'],
      );
    }
    if (type == 'burning' || type == 'throbbing') {
      return const AssessmentOutput(
        diagnosis: 'Cervical Nerve Root Irritation',
        confidence: 76,
        exerciseIds: ['chin_tucks', 'neck_tilt', 'scalene_stretch'],
      );
    }
    if (type == 'dull') {
      return const AssessmentOutput(
        diagnosis: 'Tension Headache & Neck Tightness',
        confidence: 86,
        exerciseIds: ['neck_rotation', 'chin_tucks', 'upper_trap_stretch'],
      );
    }
    return const AssessmentOutput(
      diagnosis: 'Cervicogenic Neck Pain',
      confidence: 74,
      exerciseIds: ['neck_tilt', 'neck_rotation', 'chin_tucks'],
    );
  }

  // ── SHOULDERS ─────────────────────────────────────────────────────
  static AssessmentOutput _shoulders(
      String type, int intensity, String duration) {
    if (type == 'sharp' && intensity >= 7) {
      return const AssessmentOutput(
        diagnosis: 'Rotator Cuff Acute Strain',
        confidence: 84,
        exerciseIds: ['pendulum_swings', 'shoulder_rolls', 'cross_body_stretch'],
      );
    }
    if (type == 'sharp' && intensity < 7 && duration == 'today') {
      return const AssessmentOutput(
        diagnosis: 'Shoulder Muscle Spasm',
        confidence: 80,
        exerciseIds: ['shoulder_rolls', 'levator_stretch', 'cross_body_stretch'],
      );
    }
    if (type == 'stiffness' && duration == 'months') {
      return const AssessmentOutput(
        diagnosis: 'Frozen Shoulder (Adhesive Capsulitis)',
        confidence: 82,
        exerciseIds: ['pendulum_swings', 'shoulder_external_rotation', 'door_chest_stretch'],
      );
    }
    if (type == 'stiffness' && duration == 'weeks') {
      return const AssessmentOutput(
        diagnosis: 'Early Capsular Tightness',
        confidence: 77,
        exerciseIds: ['pendulum_swings', 'cross_body_stretch', 'shoulder_external_rotation'],
      );
    }
    if (type == 'burning') {
      return const AssessmentOutput(
        diagnosis: 'Shoulder Impingement Syndrome',
        confidence: 81,
        exerciseIds: ['wall_angels', 'scapular_retraction', 'pec_minor_stretch'],
      );
    }
    if (type == 'dull') {
      return const AssessmentOutput(
        diagnosis: 'Subacromial Bursitis',
        confidence: 75,
        exerciseIds: ['shoulder_rolls', 'wall_angels', 'prone_y_raise'],
      );
    }
    return const AssessmentOutput(
      diagnosis: 'Shoulder Muscle Strain',
      confidence: 74,
      exerciseIds: ['shoulder_rolls', 'cross_body_stretch', 'wall_angels'],
    );
  }

  // ── UPPER BACK ────────────────────────────────────────────────────
  static AssessmentOutput _upperBack(
      String type, int intensity, String duration) {
    if (type == 'sharp' && intensity >= 7) {
      return const AssessmentOutput(
        diagnosis: 'Thoracic Muscle Spasm',
        confidence: 87,
        exerciseIds: ['childs_pose', 'supine_lumbar_rotation', 'cat_cow'],
      );
    }
    if (type == 'sharp') {
      return const AssessmentOutput(
        diagnosis: 'Upper Back Muscle Spasm',
        confidence: 84,
        exerciseIds: ['childs_pose', 'thoracic_extension', 'prone_cobra'],
      );
    }
    if (type == 'stiffness' && (duration == 'weeks' || duration == 'months')) {
      return const AssessmentOutput(
        diagnosis: 'Thoracic Hypomobility',
        confidence: 86,
        exerciseIds: ['thoracic_extension', 'cat_cow', 'wall_angels'],
      );
    }
    if (type == 'stiffness' && duration == 'today') {
      return const AssessmentOutput(
        diagnosis: 'Postural Upper Back Tension',
        confidence: 85,
        exerciseIds: ['cat_cow', 'shoulder_rolls', 'scapular_retraction'],
      );
    }
    if (type == 'dull') {
      return const AssessmentOutput(
        diagnosis: 'Chronic Postural Upper Back Strain',
        confidence: 83,
        exerciseIds: ['cat_cow', 'prone_cobra', 'band_pull_apart'],
      );
    }
    if (type == 'burning' || type == 'throbbing') {
      return const AssessmentOutput(
        diagnosis: 'Thoracic Nerve Root Irritation',
        confidence: 74,
        exerciseIds: ['thoracic_extension', 'childs_pose', 'scapular_retraction'],
      );
    }
    return const AssessmentOutput(
      diagnosis: 'Postural Upper Back Pain',
      confidence: 79,
      exerciseIds: ['cat_cow', 'thoracic_extension', 'wall_angels'],
    );
  }

  // ── HIPS ──────────────────────────────────────────────────────────
  static AssessmentOutput _hips(
      String type, int intensity, String duration, int age) {
    if (type == 'sharp' && intensity >= 7) {
      return const AssessmentOutput(
        diagnosis: 'Hip Flexor / Adductor Strain',
        confidence: 82,
        exerciseIds: ['hip_flexor_stretch', 'supine_hamstring_stretch', 'glute_bridges'],
      );
    }
    if (type == 'sharp' && intensity < 7) {
      return const AssessmentOutput(
        diagnosis: 'Hip Labral Irritation',
        confidence: 72,
        exerciseIds: ['hip_circles', 'hip_90_90_stretch', 'frog_stretch'],
      );
    }
    if ((type == 'dull' || type == 'stiffness') && age >= 55) {
      return const AssessmentOutput(
        diagnosis: 'Hip Osteoarthritis',
        confidence: 80,
        exerciseIds: ['hip_circles', 'glute_bridges', 'clamshells'],
      );
    }
    if ((type == 'dull' || type == 'stiffness') && age >= 40) {
      return const AssessmentOutput(
        diagnosis: 'Early Hip Joint Degeneration',
        confidence: 73,
        exerciseIds: ['hip_circles', 'piriformis_stretch', 'glute_bridges'],
      );
    }
    if (type == 'burning' || type == 'throbbing') {
      return const AssessmentOutput(
        diagnosis: 'Greater Trochanteric Bursitis',
        confidence: 76,
        exerciseIds: ['it_band_stretch', 'side_lying_abduction', 'hip_circles'],
      );
    }
    if (type == 'stiffness' && duration == 'today') {
      return const AssessmentOutput(
        diagnosis: 'Hip Flexor & Piriformis Tightness',
        confidence: 85,
        exerciseIds: ['hip_flexor_stretch', 'piriformis_stretch', 'frog_stretch'],
      );
    }
    return const AssessmentOutput(
      diagnosis: 'Hip Muscle Tightness',
      confidence: 78,
      exerciseIds: ['hip_flexor_stretch', 'piriformis_stretch', 'hip_90_90_stretch'],
    );
  }

  // ── KNEES ─────────────────────────────────────────────────────────
  static AssessmentOutput _knees(
      String type, int intensity, String duration, int age) {
    if (type == 'sharp' && intensity >= 8) {
      return const AssessmentOutput(
        diagnosis: 'Possible Ligament / Meniscus Injury',
        confidence: 79,
        exerciseIds: ['quad_sets', 'straight_leg_raise', 'ankle_circles'],
      );
    }
    if (type == 'sharp' && intensity < 8) {
      return const AssessmentOutput(
        diagnosis: 'Patellofemoral Pain Syndrome',
        confidence: 80,
        exerciseIds: ['quad_sets', 'terminal_knee_extension', 'clamshells'],
      );
    }
    if (type == 'stiffness' && age >= 50) {
      return const AssessmentOutput(
        diagnosis: 'Knee Osteoarthritis',
        confidence: 82,
        exerciseIds: ['quad_sets', 'straight_leg_raise', 'mini_squat'],
      );
    }
    if (type == 'stiffness' && age >= 35) {
      return const AssessmentOutput(
        diagnosis: 'Early Knee Degeneration',
        confidence: 74,
        exerciseIds: ['quad_sets', 'hamstring_curl', 'lateral_band_walk'],
      );
    }
    if (type == 'dull' && (duration == 'weeks' || duration == 'months')) {
      return const AssessmentOutput(
        diagnosis: 'Patellar Tendinopathy',
        confidence: 78,
        exerciseIds: ['quad_sets', 'wall_squats', 'terminal_knee_extension'],
      );
    }
    if (type == 'burning') {
      return const AssessmentOutput(
        diagnosis: 'Pes Anserine Bursitis',
        confidence: 72,
        exerciseIds: ['straight_leg_raise', 'quad_sets', 'seated_hamstring_stretch'],
      );
    }
    if (type == 'throbbing') {
      return const AssessmentOutput(
        diagnosis: 'Knee Joint Inflammation',
        confidence: 74,
        exerciseIds: ['quad_sets', 'ankle_circles', 'straight_leg_raise'],
      );
    }
    return const AssessmentOutput(
      diagnosis: 'Knee Muscle Strain',
      confidence: 75,
      exerciseIds: ['quad_sets', 'hamstring_curl', 'mini_squat'],
    );
  }

  // ── ANKLES ────────────────────────────────────────────────────────
  static AssessmentOutput _ankles(String type, int intensity, String duration) {
    if (type == 'sharp' && intensity >= 7) {
      return const AssessmentOutput(
        diagnosis: 'Acute Ankle Sprain',
        confidence: 87,
        exerciseIds: ['ankle_circles', 'alphabet_ankle', 'towel_scrunches'],
      );
    }
    if (type == 'sharp' && intensity < 7) {
      return const AssessmentOutput(
        diagnosis: 'Ankle Ligament Irritation',
        confidence: 80,
        exerciseIds: ['ankle_circles', 'ankle_dorsiflexion_stretch', 'calf_raises'],
      );
    }
    if (type == 'stiffness' && duration == 'today') {
      return const AssessmentOutput(
        diagnosis: 'Morning Ankle Stiffness',
        confidence: 82,
        exerciseIds: ['ankle_circles', 'gastrocnemius_stretch', 'alphabet_ankle'],
      );
    }
    if (type == 'stiffness' && (duration == 'weeks' || duration == 'months')) {
      return const AssessmentOutput(
        diagnosis: 'Chronic Ankle Hypomobility',
        confidence: 79,
        exerciseIds: ['ankle_dorsiflexion_stretch', 'alphabet_ankle', 'single_leg_balance'],
      );
    }
    if (type == 'burning') {
      return const AssessmentOutput(
        diagnosis: 'Achilles Tendinopathy',
        confidence: 78,
        exerciseIds: ['eccentric_calf_raise', 'gastrocnemius_stretch', 'soleus_stretch'],
      );
    }
    if (type == 'dull' && duration == 'today') {
      return const AssessmentOutput(
        diagnosis: 'Plantar Fasciitis Signs',
        confidence: 75,
        exerciseIds: ['gastrocnemius_stretch', 'soleus_stretch', 'towel_scrunches'],
      );
    }
    if (type == 'dull' && (duration == 'weeks' || duration == 'months')) {
      return const AssessmentOutput(
        diagnosis: 'Peroneal Tendinopathy',
        confidence: 73,
        exerciseIds: ['eccentric_calf_raise', 'ankle_dorsiflexion_stretch', 'single_leg_balance'],
      );
    }
    return const AssessmentOutput(
      diagnosis: 'Ankle Discomfort',
      confidence: 70,
      exerciseIds: ['ankle_circles', 'towel_scrunches', 'gastrocnemius_stretch'],
    );
  }

  static AssessmentOutput _generic() => const AssessmentOutput(
        diagnosis: 'General Musculoskeletal Pain',
        confidence: 65,
        exerciseIds: ['cat_cow', 'diaphragmatic_breathing', 'hip_circles'],
      );
}
