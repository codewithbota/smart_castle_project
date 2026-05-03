import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_castle/models/word.dart';
import 'package:smart_castle/repositories/word_repository.dart';
import 'package:smart_castle/services/srs_service.dart';

abstract class WordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WordInitial extends WordState {}
class WordLoading extends WordState {}
class WordError extends WordState {
  final String message;
  WordError(this.message);
  @override
  List<Object?> get props => [message];
}
class WordLoaded extends WordState {
  final List<Word> words;
  WordLoaded(this.words);
  @override
  List<Object?> get props => [words];
}

class WordCubit extends Cubit<WordState> {
  final WordRepository _repo;
  WordCubit(this._repo) : super(WordInitial());

  Future<void> loadWords(String deckId) async {
    emit(WordLoading());
    try {
      final words = await _repo.getWords(deckId);
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> addWord({
    required String deckId,
    required String word,
    required String translation,
    String? transcription,
    String? example,
  }) async {
    try {
      await _repo.addWord(
        deckId: deckId,
        word: word,
        translation: translation,
        transcription: transcription,
        example: example,
      );
      await loadWords(deckId);
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> updateWordAfterReview(Word word, String result) async {
    try {
      final updatedWord = SrsService.updateAfterReview(word, result);
      await _repo.updateWord(updatedWord);
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> updateWord(Word word) async {
    try {
      await _repo.updateWord(word);
      await loadWords(word.deckId);
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> deleteWord(String id, String deckId) async {
    try {
      await _repo.deleteWord(id);
      await loadWords(deckId);
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }
}