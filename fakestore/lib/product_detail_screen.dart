import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_cubit.dart';
import 'product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesCubit, bool>(
        (c) => c.state.contains(product.id));
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 220,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.image_not_supported, size: 96),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text('\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, color: Colors.green)),
            Text('Rating: ${product.rating} / 5'),
            Text('Category: ${product.category}'),
            const SizedBox(height: 12),
            Text(product.description),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
              label: Text(isFav ? 'Remove Favorite' : 'Add to Favorites'),
              onPressed: () =>
                  context.read<FavoritesCubit>().toggle(product.id),
            ),
          ],
        ),
      ),
    );
  }
}
