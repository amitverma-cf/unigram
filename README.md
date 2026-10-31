# Unigram

TikTok-style learning. Swipe up through a vertical feed where every card is a
quiz question you actually answer: instant feedback, an explanation, XP,
combos and a daily streak.

## Features
- Full-screen vertical swipe feed of multiple-choice questions
- Right/wrong feedback with explanations
- XP (with combo bonus), accuracy, daily streak, persisted locally
- Endless feed: more questions load as you near the end
- Backend-agnostic: UI depends only on `QuestionRepository` and `ProgressStore`

## Structure
```
lib/
  models/    Question
  data/      QuestionRepository, ProgressStore, mock questions
  state/     Progress (XP, streak, combo)
  screens/   FeedScreen
  widgets/   QuestionCard, StatsBar
```

## Run
```
flutter pub get
flutter run        # or: flutter run -d chrome
flutter test
```

## Backend roadmap
Planned: Supabase (Postgres + auth + storage). Implement `QuestionRepository`
and `ProgressStore` against it and swap them in `lib/main.dart`; no UI changes
needed. Suggested tables: `topics`, `questions`, `profiles`, `answers`.

## License
MIT
