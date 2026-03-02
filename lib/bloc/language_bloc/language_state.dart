class LanguageState {
  final String language;

  const LanguageState({required this.language});

  LanguageState copyWith({String? language}) {
    return LanguageState(
      language: language ?? this.language,
    );
  }
}