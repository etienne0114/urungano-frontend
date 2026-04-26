import '../models/lesson.dart';

/// Summary-only lesson catalogue for Home and Library screens.
/// Contains metadata (id, title, category, duration) but no chapter narration
/// or hotspots — those live in [kLessonContent] and the backend API.
/// IDs must match backend `lesson.seed.ts` and [kLessonContent] keys.
const List<Lesson> kLessonCatalogue = [
  Lesson(
    id: 'your_cycle',
    title: 'Your cycle, explained',
    localizedTitle: {
      'en': 'Your cycle, explained',
      'fr': 'Votre cycle, expliqué',
      'rw': 'Incurane yawe, isobanurwa',
    },
    category: LessonCategory.menstrualHealth,
    durationMinutes: 8,
    chapters: [],
  ),
  Lesson(
    id: 'hiv_prevention',
    title: 'How HIV works & prevention',
    localizedTitle: {
      'en': 'How HIV works & prevention',
      'fr': 'Comment fonctionne le VIH et la prévention',
      'rw': "Uko VIH ikora n'uburyo bwo kwirinda",
    },
    category: LessonCategory.hivSti,
    durationMinutes: 12,
    chapters: [],
  ),
  Lesson(
    id: 'anatomy_101',
    title: 'Reproductive anatomy 101',
    localizedTitle: {
      'en': 'Reproductive anatomy 101',
      'fr': 'Anatomie reproductive 101',
      'rw': 'Imiterere y’imyanya myibarukiro 101',
    },
    category: LessonCategory.anatomy,
    durationMinutes: 10,
    chapters: [],
  ),
  Lesson(
    id: 'cramps_flow',
    title: 'Tracking cramps & flow',
    localizedTitle: {
      'en': 'Tracking cramps & flow',
      'fr': 'Suivre les crampes et les flux',
      'rw': "Gukurikirana ububabare n'ubwinshi bw'imihango",
    },
    category: LessonCategory.menstrualHealth,
    durationMinutes: 6,
    chapters: [],
  ),
  Lesson(
    id: 'getting_tested',
    title: 'Getting tested: what happens',
    localizedTitle: {
      'en': 'Getting tested: what happens',
      'fr': 'Se faire dépister : que se passe-t-il ?',
      'rw': 'Kwipimisha: uko bikorwa',
    },
    category: LessonCategory.hivSti,
    durationMinutes: 5,
    chapters: [],
  ),
  Lesson(
    id: 'puberty_changes',
    title: 'Puberty & body changes',
    localizedTitle: {
      'en': 'Puberty & body changes',
      'fr': 'Puberté et changements corporels',
      'rw': "Ubugimbi n’ubwangavu: impinduka z'umubiri",
    },
    category: LessonCategory.anatomy,
    durationMinutes: 9,
    chapters: [],
  ),
];
