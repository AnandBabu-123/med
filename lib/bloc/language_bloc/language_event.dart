abstract class LanguageEvent {}

class LoadLanguage extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final String language;

  ChangeLanguage(this.language);
}