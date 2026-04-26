import 'package:dio/dio.dart';
import '../../data/lesson_catalogue.dart';
import '../../data/lesson_content.dart';
import '../../models/lesson.dart';
import '../../models/paginated_result.dart';
import '../connectivity_service.dart';
import '../storage/hive_storage.dart';
import 'api_client.dart';

/// Lesson data access.
///
/// Flow:
///   ONLINE  → fetch from API → cache result to Hive → return API data
///   OFFLINE → return Hive cache (if populated) → fall back to bundled data
class LessonService {
  LessonService._();

  // ── All lessons ───────────────────────────────────────────

  static Future<PaginatedResult<Lesson>> fetchPaginated({
    LessonCategory? category,
    int page = 1,
    int limit = 10,
  }) async {
    final online = await ConnectivityService.check();

    if (online) {
      try {
        final queryParams = {
          'page': page,
          'limit': limit,
          if (category != null) 'category': category.apiKey,
        };

        final res = await ApiClient.instance.get<Map<String, dynamic>>(
          '/lessons',
          queryParameters: queryParams,
        );

        final data = ApiClient.staticUnwrap<Map<String, dynamic>>(res);
        final result = PaginatedResult<Lesson>.fromJson(
          data,
          (item) => Lesson.fromJson(item),
        );

        // Cache the first page to Hive for offline landing
        if (page == 1) {
          await HiveStorage.saveLessons(result.data);
        }

        return result;
      } on DioException {
        // Fall through to cache
      }
    }

    // OFFLINE path: return cached lessons as a single page
    final cached = HiveStorage.loadLessons();
    final lessons = cached.isNotEmpty ? cached : kLessonCatalogue;

    return PaginatedResult(
      data: lessons,
      meta: PaginationMeta(
        totalItems: lessons.length,
        itemCount: lessons.length,
        itemsPerPage: lessons.length,
        totalPages: 1,
        currentPage: 1,
      ),
    );
  }

  /// Fetches every lesson across all pages. Falls back to cache when offline.
  static Future<List<Lesson>> fetchAll({LessonCategory? category}) async {
    final online = await ConnectivityService.check();

    if (online) {
      try {
        final all = <Lesson>[];
        int page = 1;
        int totalPages = 1;
        do {
          final res = await ApiClient.instance.get<Map<String, dynamic>>(
            '/lessons',
            queryParameters: {
              'page': page,
              'limit': 50,
              if (category != null) 'category': category.apiKey,
            },
          );
          final data = ApiClient.staticUnwrap<Map<String, dynamic>>(res);
          final result = PaginatedResult<Lesson>.fromJson(
              data, (item) => Lesson.fromJson(item));
          all.addAll(result.data);
          totalPages = result.meta.totalPages;
          page++;
        } while (page <= totalPages);

        // Persist full list for offline use
        await HiveStorage.saveLessons(all);
        return all;
      } on DioException {
        // Fall through to cache
      }
    }

    final cached = HiveStorage.loadLessons();
    return cached.isNotEmpty ? cached : kLessonCatalogue;
  }

  // ── Single lesson ─────────────────────────────────────────

  static Future<Lesson?> fetchOne(String idOrSlug) async {
    final online = await ConnectivityService.check();

    if (online) {
      try {
        final res = await ApiClient.instance
            .get<Map<String, dynamic>>('/lessons/$idOrSlug');
        final lesson =
            Lesson.fromJson(ApiClient.staticUnwrap<Map<String, dynamic>>(res));

        // Cache full content to Hive
        await HiveStorage.saveLesson(lesson);
        return lesson;
      } on DioException {
        // Fall through to cache
      }
    }

    // OFFLINE path: Hive cache → bundled fallback
    final cached = HiveStorage.loadLesson(idOrSlug);
    if (cached != null) return cached;

    // Search cached lessons by id OR slug (UUID vs human slug)
    final fromList = HiveStorage.loadLessons()
        .where((l) => l.id == idOrSlug || l.slug == idOrSlug)
        .cast<Lesson?>()
        .firstWhere((_) => true, orElse: () => null);
    if (fromList != null) return fromList;

    // Bundled content: try direct key first, then slug scan
    if (kLessonContent.containsKey(idOrSlug)) return kLessonContent[idOrSlug];
    return kLessonContent.values
        .where((l) => l.slug == idOrSlug || l.id == idOrSlug)
        .cast<Lesson?>()
        .firstWhere((_) => true, orElse: () => null);
  }
}
