import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_cubit.dart';
import 'product.dart';
import 'product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesCubit, bool>(
        (c) => c.state.contains(product.id));
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.image_not_supported, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green)),
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : null),
                    onPressed: () =>
                        context.read<FavoritesCubit>().toggle(product.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
