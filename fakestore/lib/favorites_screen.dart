import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_cubit.dart';
import 'product_bloc.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favIds = context.watch<FavoritesCubit>().state;
    final all = context.watch<ProductBloc>().state.allProducts;
    final favs = all.where((p) => favIds.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favs.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (_, i) {
                final p = favs[i];
                return ListTile(
                  leading: Image.network(
                    p.image,
                    width: 48,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.image_not_supported),
                  ),
                  title: Text(p.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        context.read<FavoritesCubit>().toggle(p.id),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(p)),
                  ),
                );
              },
            ),
    );
  }
}
