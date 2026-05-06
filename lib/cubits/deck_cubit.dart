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
  final List<Deck> previousDecks; 
  DeckError(this.message, {this.previousDecks = const []});
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
    if (state is DeckInitial) {
      emit(DeckLoading());
    }
    try {
      final decks = await _repo.getDecks();
      emit(DeckLoaded(decks));
    } catch (e) {
      final prev = state is DeckLoaded ? (state as DeckLoaded).decks : <Deck>[];
      emit(DeckError(e.toString(), previousDecks: prev));
    }
  }

  Future<void> createDeck(String name, String emoji) async {
    try {
      await _repo.createDeck(name, emoji);
      await loadDecks();
    } catch (e) {
      final prev = state is DeckLoaded ? (state as DeckLoaded).decks : <Deck>[];
      emit(DeckError(e.toString(), previousDecks: prev));
      await Future.delayed(const Duration(milliseconds: 500));
      await loadDecks();
    }
  }

  Future<void> deleteDeck(String id) async {
    try {
      await _repo.deleteDeck(id);
      await loadDecks();
    } catch (e) {
      final prev = state is DeckLoaded ? (state as DeckLoaded).decks : <Deck>[];
      emit(DeckError(e.toString(), previousDecks: prev));
      await Future.delayed(const Duration(milliseconds: 500));
      await loadDecks();
    }
  }
}