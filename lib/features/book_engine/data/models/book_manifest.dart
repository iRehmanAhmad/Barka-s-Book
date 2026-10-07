import 'book_page.dart';

class BookManifest {
  final String bookId;
  final String title;
  final String subject;
  final String grade;
  final bool isRtl;
  final List<BookPage> pages;

  const BookManifest({
    required this.bookId,
    required this.title,
    required this.subject,
    required this.grade,
    required this.isRtl,
    required this.pages,
  });

  factory BookManifest.fromJson(Map<String, dynamic> json) {
    var rawPages = json['pages'] as List? ?? [];
    var pageList = rawPages
        .map((p) => BookPage.fromJson(p as Map<String, dynamic>))
        .toList();

    return BookManifest(
      bookId: json['bookId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      grade: json['grade'] as String? ?? 'nursery',
      isRtl: json['isRtl'] as bool? ?? false,
      pages: pageList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'subject': subject,
      'grade': grade,
      'isRtl': isRtl,
      'pages': pages.map((p) => p.toJson()).toList(),
    };
  }
}
