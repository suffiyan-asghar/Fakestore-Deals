abstract class ProductEvent {}

/// Fetch products and categories from the API.
class LoadProducts extends ProductEvent {}

/// Show only one category; `null` means "All".
class FilterByCategory extends ProductEvent {
  final String? category;
  FilterByCategory(this.category);
}

/// Filter by text typed into the search field.
class SearchProducts extends ProductEvent {
  final String query;
  SearchProducts(this.query);
}
