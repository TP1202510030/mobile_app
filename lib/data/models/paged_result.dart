class PagedResult<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;
  final bool isLast;
  final bool isFirst;

  PagedResult({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.isLast,
    required this.isFirst,
  });

  factory PagedResult.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PagedResult<T>(
      content: (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
      size: json['size'] as int,
      number: json['number'] as int,
      isLast: json['last'] as bool,
      isFirst: json['first'] as bool,
    );
  }

  factory PagedResult.empty() {
    return PagedResult<T>(
      content: [],
      totalPages: 0,
      totalElements: 0,
      size: 0,
      number: 0,
      isLast: true,
      isFirst: true,
    );
  }
}
