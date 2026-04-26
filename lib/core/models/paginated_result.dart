class PaginatedResult<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResult({
    required this.data,
    required this.meta,
  });

  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final rawItems =
        (json['items'] ?? json['data'] ?? <dynamic>[]) as List<dynamic>;
    final rawMeta =
        (json['meta'] ?? <String, dynamic>{}) as Map<String, dynamic>;

    final normalizedMeta = {
      'totalItems':
          rawMeta['totalItems'] ?? rawMeta['total'] ?? rawItems.length,
      'itemCount': rawMeta['itemCount'] ?? rawItems.length,
      'itemsPerPage':
          rawMeta['itemsPerPage'] ?? rawMeta['limit'] ?? rawItems.length,
      'totalPages': rawMeta['totalPages'] ?? 1,
      'currentPage': rawMeta['currentPage'] ?? rawMeta['page'] ?? 1,
    };

    return PaginatedResult(
      data: rawItems
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(normalizedMeta),
    );
  }
}

class PaginationMeta {
  final int totalItems;
  final int itemCount;
  final int itemsPerPage;
  final int totalPages;
  final int currentPage;

  PaginationMeta({
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      totalItems: json['totalItems'] as int,
      itemCount: json['itemCount'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
    );
  }
}
