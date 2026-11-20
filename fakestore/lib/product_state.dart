import 'package:equatable/equatable.dart';

import 'product.dart';

// Re-exported so tests that import product_state.dart can use Product.
export 'product.dart';

class ProductState extends Equatable {
  final bool loading;
  final List<Product> allProducts;
  final List<String> categories;
  final String? selectedCategory; // null = All
  final String query;
  final String? error;

  const ProductState({
    this.loading = false,
    this.allProducts = const [],
    this.categories = const [],
    this.selectedCategory,
    this.query = '',
    this.error,
  });

  /// Products after applying the category chip and the search text.
  List<Product> get visibleProducts {
    final q = query.trim().toLowerCase();
    return allProducts
        .where((p) =>
            selectedCategory == null || p.category == selectedCategory)
        .where((p) => q.isEmpty || p.title.toLowerCase().contains(q))
        .toList();
  }

  ProductState copyWith({
    bool? loading,
    List<Product>? allProducts,
    List<String>? categories,
    String? Function()? selectedCategory,
    String? query,
    String? Function()? error,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      allProducts: allProducts ?? this.allProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory != null
          ? selectedCategory()
          : this.selectedCategory,
      query: query ?? this.query,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props =>
      [loading, allProducts, categories, selectedCategory, query, error];
}
