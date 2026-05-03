import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_castle/models/deck.dart';
import 'package:smart_castle/repositories/deck_repository.dart';

abstract class DeckState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeckInitial extends DeckState {}
class DeckLoading extends DeckState {}
class DeckError extends DeckState {
  final String message;
  DeckError(this.message);
  @override
  List<Object?> get props => [message];
}
class DeckLoaded extends DeckState {
  final List<Deck> decks;
  DeckLoaded(this.decks);
  @override
  List<Object?> get props => [decks];
}

class DeckCubit extends Cubit<DeckState> {
  final DeckRepository _repo;
  DeckCubit(this._repo) : super(DeckInitial());

  Future<void> loadDecks() async {
    emit(DeckLoading());
    try {
      final decks = await _repo.getDecks();
      emit(DeckLoaded(decks));
    } catch (e) {
      emit(DeckError(e.toString()));
    }
  }

  Future<void> createDeck(String name, String emoji) async {
    try {
      await _repo.createDeck(name, emoji);
      await loadDecks();
    } catch (e) {
      emit(DeckError(e.toString()));
    }
  }

  Future<void> deleteDeck(String id) async {
    try {
      await _repo.deleteDeck(id);
      await loadDecks();
    } catch (e) {
      emit(DeckError(e.toString()));
    }
  }
}