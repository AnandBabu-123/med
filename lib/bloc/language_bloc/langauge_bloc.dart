import 'package:bloc/bloc.dart';
import '../../utils/session_manager.dart';
import 'language_event.dart';
import 'language_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageBloc
    extends Bloc<LanguageEvent, LanguageState> {

  LanguageBloc()
      : super(const LanguageState(language: "en")) {

    on<LoadLanguage>(_load);
    on<ChangeLanguage>(_change);
  }

  /// LOAD SAVED LANGUAGE
  Future<void> _load(
      LoadLanguage event,
      Emitter<LanguageState> emit,
      ) async {

    final lang = await SessionManager.getLanguage();
    emit(state.copyWith(language: lang));
  }

  /// CHANGE LANGUAGE
  Future<void> _change(
      ChangeLanguage event,
      Emitter<LanguageState> emit,
      ) async {

    /// save locally
    await SessionManager.saveLanguage(event.language);

    emit(state.copyWith(language: event.language));
  }
}