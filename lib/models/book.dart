class Rating {
  final double averageRating;
  final int ratingsCount;

  Rating({required this.averageRating, required this.ratingsCount});
}

class Order {
  final String currencyCode;
  final double amount;
  final String buyLink;

  Order(
      {required this.currencyCode,
      required this.amount,
      required this.buyLink});
}

class Book {
  final String id;
  final String title;
  final List<dynamic>? authors;
  final String? description;
  final Rating? rating;
  final String? imageUrl;
  final Order? order;
  final String? linkTo;

  Book({
    required this.id,
    required this.title,
    this.authors,
    this.description,
    this.rating,
    this.imageUrl,
    this.order,
    this.linkTo,
  });
}
