import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_service.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService api;

  ProductBloc(this.api) : super(const ProductState()) {
    on<LoadProducts>(_onLoad);
    on<FilterByCategory>((e, emit) =>
        emit(state.copyWith(selectedCategory: () => e.category)));
    on<SearchProducts>(
        (e, emit) => emit(state.copyWith(query: e.query)));
  }

  Future<void> _onLoad(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(loading: true, error: () => null));
    try {
      final results = await Future.wait([
        api.fetchAllProducts(),
        api.fetchCategories(),
      ]);
      emit(state.copyWith(
        loading: false,
        allProducts: results[0] as List<Product>,
        categories: results[1] as List<String>,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: () => e.toString()));
    }
  }
}
