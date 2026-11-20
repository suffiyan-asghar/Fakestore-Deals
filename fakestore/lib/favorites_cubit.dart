import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the ids of favourited products.
class FavoritesCubit extends Cubit<Set<int>> {
  FavoritesCubit() : super(<int>{});

  void toggle(int id) {
    emit(state.contains(id)
        ? ({...state}..remove(id))
        : {...state, id});
  }
}
