import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'models/exercise_plan.dart';

/// 8 clinically-phased recovery plans covering the most-searched pain areas.
/// Each plan follows a Phase 1 → 2 → 3 progression (Pain Relief → Recovery → Strengthening)
/// with rest days every 3–4 days.
final List<ExercisePlan> planData = [
  // ═══════════════════════════════════════════════════════════════
  // 1. LOWER BACK PAIN RELIEF — 7 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'lower_back_7d',
    name: 'Lower Back Pain Relief',
    description:
        'The #1 searched pain globally. This gentle 7-day program starts '
        'with pain-relieving stretches and progresses to core stabilization '
        'exercises trusted by physiotherapists worldwide.',
    targetArea: 'Lower Back',
    durationDays: 7,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Gentle mobility, zero load',
          startDay: 1,
          endDay: 3),
      PlanPhase(
          name: 'Recovery',
          description: 'Light activation',
          startDay: 4,
          endDay: 5),
      PlanPhase(
          name: 'Strengthening',
          description: 'Core stabilization',
          startDay: 6,
          endDay: 7),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['knee_chest_stretch', 'pelvic_tilts', 'childs_pose'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['cat_cow', 'knee_chest_stretch', 'pelvic_tilts'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: [
          'pelvic_tilts',
          'cat_cow',
          'hip_flexor_stretch',
          'childs_pose'
        ],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['knee_chest_stretch', 'glute_bridges', 'bird_dog'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['bird_dog', 'dead_bug', 'glute_bridges', 'hip_hinge'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: ['childs_pose', 'cat_cow', 'pelvic_tilts'],
        estimatedMinutes: 12,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 2. NECK & DESK WORKER RELEASE — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'neck_desk_14d',
    name: 'Neck & Desk Worker Release',
    description: 'Designed for remote workers and screen-heavy lifestyles. '
        'This 14-day program releases tension from prolonged sitting, '
        'opens the chest, and strengthens postural muscles.',
    targetArea: 'Neck',
    durationDays: 14,
    difficulty: 'active',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Gentle neck & shoulder release',
          startDay: 1,
          endDay: 4),
      PlanPhase(
          name: 'Recovery',
          description: 'Mobility restoration',
          startDay: 5,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Postural endurance',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['neck_tilt', 'neck_rotation', 'chin_tucks'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['neck_flexion', 'levator_stretch', 'shoulder_rolls'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['neck_tilt', 'chin_tucks', 'levator_stretch'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['neck_rotation', 'shoulder_rolls', 'cross_body_stretch'],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['chin_tucks', 'door_chest_stretch', 'thoracic_extension'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['neck_tilt', 'levator_stretch', 'wall_angels'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['neck_flexion', 'cross_body_stretch', 'shoulder_rolls'],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: [
          'wall_angels',
          'door_chest_stretch',
          'thoracic_extension'
        ],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: ['chin_tucks', 'levator_stretch', 'seated_row'],
        estimatedMinutes: 20,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: [
          'wall_angels',
          'thoracic_extension',
          'door_chest_stretch',
          'chin_tucks'
        ],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 3. SCIATICA RELIEF PROGRAM — 7 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'sciatica_7d',
    name: 'Sciatica Relief Program',
    description:
        'Targeted relief for sciatic nerve pain. Focuses on piriformis '
        'release, hip mobility, and core activation to reduce nerve '
        'compression and restore comfortable movement.',
    targetArea: 'Lower Back · Hips',
    durationDays: 7,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Nerve decompression',
          startDay: 1,
          endDay: 3),
      PlanPhase(
          name: 'Recovery',
          description: 'Hip mobility restoration',
          startDay: 4,
          endDay: 5),
      PlanPhase(
          name: 'Strengthening',
          description: 'Core stabilization',
          startDay: 6,
          endDay: 7),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: [
          'knee_chest_stretch',
          'piriformis_stretch',
          'childs_pose'
        ],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: [
          'pelvic_tilts',
          'hip_flexor_stretch',
          'piriformis_stretch'
        ],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: [
          'piriformis_stretch',
          'glute_bridges',
          'cat_cow',
          'hip_flexor_stretch'
        ],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['knee_chest_stretch', 'bird_dog', 'hip_circles'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['glute_bridges', 'bird_dog', 'dead_bug', 'hip_hinge'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: ['childs_pose', 'piriformis_stretch', 'cat_cow'],
        estimatedMinutes: 12,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 4. KNEE STRENGTHENING — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'knee_14d',
    name: 'Knee Strengthening',
    description:
        'Progressive knee rehabilitation for sports injuries and age-related '
        'weakness. Builds quad and hamstring strength without stressing '
        'the joint, using physio-trusted protocols.',
    targetArea: 'Knees',
    durationDays: 14,
    difficulty: 'active',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Gentle activation',
          startDay: 1,
          endDay: 4),
      PlanPhase(
          name: 'Recovery',
          description: 'Joint-friendly loading',
          startDay: 5,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Progressive resistance',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['quad_sets', 'straight_leg_raise', 'ankle_circles'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['hamstring_curl', 'calf_raises', 'quad_sets'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['straight_leg_raise', 'quad_sets', 'hamstring_curl'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['quad_sets', 'wall_squats', 'calf_raises'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['straight_leg_raise', 'hamstring_curl', 'hip_circles'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['wall_squats', 'glute_bridges', 'quad_sets'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['hamstring_curl', 'calf_raises', 'straight_leg_raise'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: [
          'wall_squats',
          'glute_bridges',
          'quad_sets',
          'calf_raises'
        ],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: ['hamstring_curl', 'straight_leg_raise', 'hip_circles'],
        estimatedMinutes: 20,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: [
          'wall_squats',
          'glute_bridges',
          'quad_sets',
          'hamstring_curl'
        ],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 5. POSTURE CORRECTION — 21 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'posture_21d',
    name: 'Posture Correction',
    description: 'A comprehensive 21-day program to reverse the effects of '
        'prolonged sitting. Targets rounded shoulders, forward head, '
        'and weak mid-back with progressive postural training.',
    targetArea: 'Full Body',
    durationDays: 21,
    difficulty: 'active',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Posture awareness & gentle release',
          startDay: 1,
          endDay: 6),
      PlanPhase(
          name: 'Recovery',
          description: 'Active mobility drills',
          startDay: 7,
          endDay: 14),
      PlanPhase(
          name: 'Strengthening',
          description: 'Postural endurance building',
          startDay: 15,
          endDay: 21),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['chin_tucks', 'thoracic_extension', 'shoulder_rolls'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['neck_tilt', 'door_chest_stretch', 'cat_cow'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['chin_tucks', 'cross_body_stretch', 'childs_pose'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['thoracic_extension', 'shoulder_rolls', 'neck_rotation'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: ['wall_angels', 'chin_tucks', 'thoracic_extension'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['door_chest_stretch', 'cat_cow', 'levator_stretch'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: [
          'wall_angels',
          'cross_body_stretch',
          'thoracic_extension'
        ],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['chin_tucks', 'shoulder_rolls', 'cat_cow'],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: ['wall_angels', 'door_chest_stretch', 'levator_stretch'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['thoracic_extension', 'seated_row', 'childs_pose'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 15,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 16,
        exerciseIds: ['wall_angels', 'seated_row', 'bird_dog'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 17,
        exerciseIds: ['door_chest_stretch', 'thoracic_extension', 'dead_bug'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 18,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 19,
        exerciseIds: [
          'wall_angels',
          'seated_row',
          'glute_bridges',
          'chin_tucks'
        ],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 20,
        exerciseIds: ['thoracic_extension', 'bird_dog', 'cat_cow'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 21,
        exerciseIds: [
          'wall_angels',
          'door_chest_stretch',
          'chin_tucks',
          'childs_pose'
        ],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 6. SHOULDER & ROTATOR CUFF — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'shoulder_14d',
    name: 'Shoulder & Rotator Cuff',
    description: 'The second most common pain area after back. This program '
        'rehabilitates shoulder impingement and rotator cuff strain '
        'with progressive scapular stabilization exercises.',
    targetArea: 'Shoulders',
    durationDays: 14,
    difficulty: 'active',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Gentle pendular & stretch',
          startDay: 1,
          endDay: 4),
      PlanPhase(
          name: 'Recovery',
          description: 'Range of motion',
          startDay: 5,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Scapular stabilization',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: [
          'pendulum_swings',
          'shoulder_rolls',
          'cross_body_stretch'
        ],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: [
          'door_chest_stretch',
          'levator_stretch',
          'shoulder_rolls'
        ],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['pendulum_swings', 'cross_body_stretch', 'childs_pose'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['shoulder_rolls', 'door_chest_stretch', 'wall_angels'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: [
          'pendulum_swings',
          'cross_body_stretch',
          'levator_stretch'
        ],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['wall_angels', 'door_chest_stretch', 'shoulder_rolls'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: [
          'cross_body_stretch',
          'levator_stretch',
          'thoracic_extension'
        ],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['wall_angels', 'seated_row', 'door_chest_stretch'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [
          'pendulum_swings',
          'cross_body_stretch',
          'thoracic_extension'
        ],
        estimatedMinutes: 20,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: [
          'wall_angels',
          'seated_row',
          'door_chest_stretch',
          'shoulder_rolls'
        ],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 7. HIP FLEXOR & CORE RELEASE — 21 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'hip_core_21d',
    name: 'Hip Flexor & Core Release',
    description: 'The silent epidemic of sitting culture. This 21-day program '
        'unlocks tight hip flexors, releases piriformis tension, and '
        'builds deep core stability for lasting relief.',
    targetArea: 'Hips · Core',
    durationDays: 21,
    difficulty: 'active',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Hip opening & gentle release',
          startDay: 1,
          endDay: 6),
      PlanPhase(
          name: 'Recovery',
          description: 'Active mobilization',
          startDay: 7,
          endDay: 14),
      PlanPhase(
          name: 'Strengthening',
          description: 'Core & glute activation',
          startDay: 15,
          endDay: 21),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['hip_flexor_stretch', 'hip_circles', 'childs_pose'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['piriformis_stretch', 'pelvic_tilts', 'cat_cow'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: [
          'hip_flexor_stretch',
          'piriformis_stretch',
          'hip_circles'
        ],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['pelvic_tilts', 'childs_pose', 'cat_cow'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: ['hip_flexor_stretch', 'glute_bridges', 'bird_dog'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['piriformis_stretch', 'hip_circles', 'pelvic_tilts'],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: ['glute_bridges', 'hip_flexor_stretch', 'cat_cow'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['piriformis_stretch', 'bird_dog', 'hip_circles'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: ['glute_bridges', 'hip_flexor_stretch', 'dead_bug'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['piriformis_stretch', 'cat_cow', 'pelvic_tilts'],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 15,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 16,
        exerciseIds: ['glute_bridges', 'bird_dog', 'dead_bug', 'hip_hinge'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 17,
        exerciseIds: [
          'hip_flexor_stretch',
          'piriformis_stretch',
          'hip_circles'
        ],
        estimatedMinutes: 18,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 18,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 19,
        exerciseIds: ['glute_bridges', 'dead_bug', 'hip_hinge', 'bird_dog'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 20,
        exerciseIds: ['piriformis_stretch', 'hip_flexor_stretch', 'cat_cow'],
        estimatedMinutes: 18,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 21,
        exerciseIds: [
          'glute_bridges',
          'bird_dog',
          'dead_bug',
          'hip_hinge',
          'childs_pose'
        ],
        estimatedMinutes: 28,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 8. FULL BODY MOBILITY STARTER — 7 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'full_body_7d',
    name: 'Full Body Mobility Starter',
    description:
        'The perfect entry point for beginners. A gentle 7-day introduction '
        'to mobility covering every major joint. No equipment needed, '
        'no experience required.',
    targetArea: 'Full Body',
    durationDays: 7,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Joint-by-joint release',
          startDay: 1,
          endDay: 3),
      PlanPhase(
          name: 'Recovery',
          description: 'Full-chain mobility',
          startDay: 4,
          endDay: 5),
      PlanPhase(
          name: 'Strengthening',
          description: 'Active integration',
          startDay: 6,
          endDay: 7),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['neck_tilt', 'shoulder_rolls', 'cat_cow', 'hip_circles'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: [
          'chin_tucks',
          'cross_body_stretch',
          'pelvic_tilts',
          'ankle_circles'
        ],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: [
          'childs_pose',
          'hip_flexor_stretch',
          'thoracic_extension',
          'calf_raises'
        ],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: [
          'cat_cow',
          'door_chest_stretch',
          'quad_sets',
          'hip_circles'
        ],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: [
          'wall_angels',
          'glute_bridges',
          'bird_dog',
          'calf_raises'
        ],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [
          'childs_pose',
          'neck_tilt',
          'shoulder_rolls',
          'hip_circles'
        ],
        estimatedMinutes: 15,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 9. PLANTAR FASCIITIS RECOVERY — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'plantar_fasciitis_14d',
    name: 'Plantar Fasciitis Recovery',
    description:
        'Structured 14-day program targeting the tight calves and weak foot '
        'muscles that drive plantar fasciitis. Combines daily calf stretching '
        'with progressive foot strengthening and eccentric loading.',
    targetArea: 'Foot · Calves',
    durationDays: 14,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Calf release & foot mobility',
          startDay: 1,
          endDay: 5),
      PlanPhase(
          name: 'Recovery',
          description: 'Strengthening & load tolerance',
          startDay: 6,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Eccentric loading & balance',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['gastrocnemius_stretch', 'soleus_stretch', 'ankle_circles'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['towel_scrunches', 'gastrocnemius_stretch', 'calf_raises'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['soleus_stretch', 'towel_scrunches', 'ankle_dorsiflexion_stretch'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['gastrocnemius_stretch', 'alphabet_ankle', 'calf_raises'],
        estimatedMinutes: 18,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['gastrocnemius_stretch', 'soleus_stretch', 'towel_scrunches', 'calf_raises'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['ankle_dorsiflexion_stretch', 'towel_scrunches', 'single_leg_balance'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['gastrocnemius_stretch', 'soleus_stretch', 'calf_raises'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: ['towel_scrunches', 'alphabet_ankle', 'ankle_circles'],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['eccentric_calf_raise', 'gastrocnemius_stretch', 'soleus_stretch'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: ['eccentric_calf_raise', 'single_leg_balance', 'towel_scrunches'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['eccentric_calf_raise', 'gastrocnemius_stretch', 'soleus_stretch', 'single_leg_balance'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 10. ANKLE SPRAIN RECOVERY — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'ankle_recovery_14d',
    name: 'Ankle Sprain Recovery',
    description:
        'Evidence-based 14-day ankle rehabilitation following a sprain. '
        'Progresses from gentle mobility through calf strengthening to '
        'proprioception training — the step most people skip that causes re-injury.',
    targetArea: 'Ankles',
    durationDays: 14,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Gentle mobility & circulation',
          startDay: 1,
          endDay: 4),
      PlanPhase(
          name: 'Recovery',
          description: 'Range of motion & strength',
          startDay: 5,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Proprioception & functional load',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['ankle_circles', 'alphabet_ankle'],
        estimatedMinutes: 10,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['ankle_circles', 'ankle_dorsiflexion_stretch', 'towel_scrunches'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['alphabet_ankle', 'gastrocnemius_stretch', 'ankle_circles'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['calf_raises', 'soleus_stretch', 'ankle_dorsiflexion_stretch'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['gastrocnemius_stretch', 'towel_scrunches', 'ankle_circles'],
        estimatedMinutes: 15,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['calf_raises', 'single_leg_balance', 'gastrocnemius_stretch'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['ankle_dorsiflexion_stretch', 'towel_scrunches', 'soleus_stretch'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: ['heel_to_toe_walk', 'calf_raises', 'ankle_circles'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['single_leg_balance', 'eccentric_calf_raise', 'gastrocnemius_stretch'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: ['star_excursion_balance', 'eccentric_calf_raise', 'heel_to_toe_walk'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['single_leg_balance', 'star_excursion_balance', 'eccentric_calf_raise', 'towel_scrunches'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 11. HAMSTRING REHABILITATION — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'hamstring_14d',
    name: 'Hamstring Rehabilitation',
    description:
        'A 14-day phased program for hamstring strain or chronic tightness. '
        'Builds from gentle stretching to progressive strengthening with '
        'eccentric loading — the most effective approach for hamstring injuries.',
    targetArea: 'Hamstrings',
    durationDays: 14,
    difficulty: 'active',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Gentle flexibility restoration',
          startDay: 1,
          endDay: 4),
      PlanPhase(
          name: 'Recovery',
          description: 'Strength & endurance',
          startDay: 5,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Eccentric loading',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['supine_hamstring_stretch', 'seated_hamstring_stretch'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['supine_hamstring_stretch', 'glute_bridges', 'pelvic_tilts'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['standing_hamstring_stretch', 'seated_hamstring_stretch', 'glute_bridges'],
        estimatedMinutes: 18,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['hamstring_curl', 'supine_hamstring_stretch', 'glute_bridges'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['standing_hamstring_stretch', 'bird_dog', 'seated_hamstring_stretch'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['hamstring_curl', 'glute_bridges', 'supine_hamstring_stretch'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['standing_hamstring_stretch', 'bird_dog', 'dead_bug'],
        estimatedMinutes: 22,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: ['hamstring_curl', 'seated_hamstring_stretch', 'glute_bridges'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['nordic_curl', 'standing_hamstring_stretch', 'glute_bridges'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: ['nordic_curl', 'hamstring_curl', 'supine_hamstring_stretch'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['nordic_curl', 'glute_bridges', 'standing_hamstring_stretch', 'bird_dog'],
        estimatedMinutes: 28,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 12. WRIST & ELBOW RECOVERY — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'wrist_elbow_14d',
    name: 'Wrist & Elbow Recovery',
    description:
        'A 14-day program for tennis elbow, golfer\'s elbow, carpal tunnel, '
        'and general wrist/forearm pain. Uses evidence-based eccentric loading '
        'alongside targeted stretching to restore pain-free function.',
    targetArea: 'Wrists · Elbows',
    durationDays: 14,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Gentle mobility & stretch',
          startDay: 1,
          endDay: 4),
      PlanPhase(
          name: 'Recovery',
          description: 'Tendon loading',
          startDay: 5,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Progressive resistance',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['wrist_circles', 'wrist_flexor_stretch', 'wrist_extensor_stretch'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['finger_extension', 'wrist_flexor_stretch', 'wrist_circles'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['wrist_extensor_stretch', 'forearm_pronation_supination', 'wrist_circles'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['wrist_eccentric_curl', 'wrist_flexor_stretch', 'wrist_extensor_stretch'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['grip_strengthening', 'forearm_pronation_supination', 'wrist_circles'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['wrist_eccentric_curl', 'wrist_extensor_stretch', 'finger_extension'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['forearm_pronation_supination', 'grip_strengthening', 'wrist_flexor_stretch'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: ['wrist_eccentric_curl', 'wrist_circles', 'finger_extension'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['wrist_eccentric_curl', 'forearm_pronation_supination', 'grip_strengthening'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: ['wrist_eccentric_curl', 'grip_strengthening', 'wrist_extensor_stretch'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['wrist_eccentric_curl', 'forearm_pronation_supination', 'grip_strengthening', 'wrist_circles'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 13. FROZEN SHOULDER REHABILITATION — 21 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'frozen_shoulder_21d',
    name: 'Frozen Shoulder Rehabilitation',
    description:
        'A carefully paced 21-day program for adhesive capsulitis (frozen shoulder). '
        'Starts with gravity-assisted pendulum work and progresses through '
        'range-of-motion and scapular stabilisation to restore full function.',
    targetArea: 'Shoulders',
    durationDays: 21,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Passive mobility & gentle release',
          startDay: 1,
          endDay: 7),
      PlanPhase(
          name: 'Recovery',
          description: 'Active range of motion',
          startDay: 8,
          endDay: 14),
      PlanPhase(
          name: 'Strengthening',
          description: 'Scapular stabilisation',
          startDay: 15,
          endDay: 21),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['pendulum_swings', 'shoulder_rolls'],
        estimatedMinutes: 10,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['pendulum_swings', 'cross_body_stretch', 'shoulder_rolls'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['pendulum_swings', 'shoulder_external_rotation', 'door_chest_stretch'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['pendulum_swings', 'cross_body_stretch', 'levator_stretch'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: ['pendulum_swings', 'shoulder_rolls', 'door_chest_stretch'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['pendulum_swings', 'cross_body_stretch', 'wall_angels'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['shoulder_external_rotation', 'door_chest_stretch', 'shoulder_rolls'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['pendulum_swings', 'wall_angels', 'cross_body_stretch'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: ['door_chest_stretch', 'levator_stretch', 'shoulder_external_rotation'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['wall_angels', 'cross_body_stretch', 'thoracic_extension'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 15,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 16,
        exerciseIds: ['scapular_retraction', 'band_pull_apart', 'wall_angels'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 17,
        exerciseIds: ['prone_y_raise', 'door_chest_stretch', 'cross_body_stretch'],
        estimatedMinutes: 20,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 18,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 19,
        exerciseIds: ['scapular_retraction', 'band_pull_apart', 'seated_row'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 20,
        exerciseIds: ['prone_y_raise', 'wall_angels', 'shoulder_external_rotation'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 21,
        exerciseIds: ['scapular_retraction', 'band_pull_apart', 'prone_y_raise', 'pendulum_swings'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 14. BALANCE & FALL PREVENTION — 14 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'balance_fall_14d',
    name: 'Balance & Fall Prevention',
    description:
        'A progressive 14-day balance program — ideal for older adults, '
        'post-injury rehabilitation, or anyone wanting to reduce fall risk. '
        'Systematically challenges and improves all three balance systems.',
    targetArea: 'Full Body',
    durationDays: 14,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Foundation stability',
          startDay: 1,
          endDay: 4),
      PlanPhase(
          name: 'Recovery',
          description: 'Dynamic balance challenge',
          startDay: 5,
          endDay: 10),
      PlanPhase(
          name: 'Strengthening',
          description: 'Functional integration',
          startDay: 11,
          endDay: 14),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['calf_raises', 'tandem_stance', 'squat_to_stand'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['single_leg_balance', 'heel_to_toe_walk', 'ankle_circles'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['glute_bridges', 'tandem_stance', 'calf_raises'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['single_leg_balance', 'heel_to_toe_walk', 'squat_to_stand'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: ['star_excursion_balance', 'glute_bridges', 'standing_march'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['single_leg_balance', 'lateral_band_walk', 'calf_raises'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['heel_to_toe_walk', 'squat_to_stand', 'tandem_stance'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: ['star_excursion_balance', 'standing_march', 'glute_bridges'],
        estimatedMinutes: 20,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['single_leg_balance', 'step_ups', 'lateral_band_walk'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: ['star_excursion_balance', 'step_ups', 'squat_to_stand'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['single_leg_balance', 'star_excursion_balance', 'step_ups', 'squat_to_stand'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

  // ═══════════════════════════════════════════════════════════════
  // 15. ACTIVE AGEING & JOINT HEALTH — 21 days
  // ═══════════════════════════════════════════════════════════════
  ExercisePlan(
    id: 'active_ageing_21d',
    name: 'Active Ageing & Joint Health',
    description:
        'A comprehensive 21-day program designed for adults 50+ or anyone '
        'managing multiple joint conditions. Low-impact, evidence-based exercises '
        'covering every major joint with rest built in for safe progression.',
    targetArea: 'Full Body',
    durationDays: 21,
    difficulty: 'gentle',
    phases: const [
      PlanPhase(
          name: 'Pain Relief',
          description: 'Joint-by-joint gentle mobility',
          startDay: 1,
          endDay: 7),
      PlanPhase(
          name: 'Recovery',
          description: 'Whole-body strengthening',
          startDay: 8,
          endDay: 14),
      PlanPhase(
          name: 'Strengthening',
          description: 'Functional movement & balance',
          startDay: 15,
          endDay: 21),
    ],
    days: const [
      PlanDay(
        dayNumber: 1,
        exerciseIds: ['neck_tilt', 'shoulder_rolls', 'cat_cow'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 2,
        exerciseIds: ['hip_circles', 'ankle_circles', 'calf_raises'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 3,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 4,
        exerciseIds: ['chin_tucks', 'cross_body_stretch', 'pelvic_tilts'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 5,
        exerciseIds: ['quad_sets', 'seated_hamstring_stretch', 'ankle_circles'],
        estimatedMinutes: 15,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 6,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 7,
        exerciseIds: ['shoulder_rolls', 'cat_cow', 'hip_circles'],
        estimatedMinutes: 12,
        phaseName: 'Pain Relief',
      ),
      PlanDay(
        dayNumber: 8,
        exerciseIds: ['glute_bridges', 'quad_sets', 'calf_raises'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 9,
        exerciseIds: ['straight_leg_raise', 'supine_hamstring_stretch', 'pelvic_tilts'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 10,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 11,
        exerciseIds: ['glute_bridges', 'hip_flexor_stretch', 'ankle_circles'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 12,
        exerciseIds: ['wall_angels', 'scapular_retraction', 'chin_tucks'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 13,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 14,
        exerciseIds: ['diaphragmatic_breathing', 'glute_bridges', 'calf_raises'],
        estimatedMinutes: 18,
        phaseName: 'Recovery',
      ),
      PlanDay(
        dayNumber: 15,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 16,
        exerciseIds: ['squat_to_stand', 'single_leg_balance', 'glute_bridges'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 17,
        exerciseIds: ['standing_march', 'calf_raises', 'seated_hamstring_stretch'],
        estimatedMinutes: 20,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 18,
        exerciseIds: [],
        estimatedMinutes: 0,
        isRest: true,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 19,
        exerciseIds: ['squat_to_stand', 'heel_to_toe_walk', 'wall_angels'],
        estimatedMinutes: 22,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 20,
        exerciseIds: ['glute_bridges', 'standing_march', 'diaphragmatic_breathing'],
        estimatedMinutes: 20,
        phaseName: 'Strengthening',
      ),
      PlanDay(
        dayNumber: 21,
        exerciseIds: ['squat_to_stand', 'single_leg_balance', 'cat_cow', 'diaphragmatic_breathing'],
        estimatedMinutes: 25,
        phaseName: 'Strengthening',
      ),
    ],
  ),

];

/// Find a plan by its ID.
ExercisePlan? findPlanById(String id) {
  try {
    return planData.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}

/// Returns the card color for a plan, consistent with PlansBrowseView cycling.
Color planCardColor(String planId) {
  const colors = [
    AppColors.recentSessionCard,
    AppColors.aiSugesstionCard,
    AppColors.dailyAssessment,
    AppColors.socialCard,
  ];
  final idx = planData.indexWhere((p) => p.id == planId);
  return idx < 0 ? AppColors.recentSessionCard : colors[idx % 4];
}
