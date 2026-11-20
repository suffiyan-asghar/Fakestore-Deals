import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_screen.dart';
import 'product_bloc.dart';
import 'product_card.dart';
import 'product_event.dart';
import 'product_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${state.error}',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProductBloc>().add(LoadProducts()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          final products = state.visibleProducts;
          return Column(
            children: [
              // Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search products',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (q) =>
                      context.read<ProductBloc>().add(SearchProducts(q)),
                ),
              ),
              // Category chips
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [null, ...state.categories].map((cat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat ?? 'All'),
                        selected: state.selectedCategory == cat,
                        onSelected: (_) => context
                            .read<ProductBloc>()
                            .add(FilterByCategory(cat)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Product grid
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (_, i) =>
                            ProductCard(product: products[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
