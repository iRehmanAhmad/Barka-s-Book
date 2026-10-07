# Barka's Book (Phase 1: Nursery / Playgroup) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a 100% offline, zero-cost, kid-friendly Android Flutter app ("Barka's Book") covering Barka Faral's Playgroup/Nursery syllabus for English Phonics, Urdu Qayda, and Early Maths with interactive motion illustrations, authentic Nastaliq typography, phonics audio, and embedded mini-games.

**Architecture:** Data-driven feature-first Flutter architecture where declarative JSON manifests drive a "Living Book" reader with touch-responsive animations (`flutter_animate`/Lottie), an audio controller with pre-cached sound effects, a canvas finger-tracing engine, and local offline progress tracking via `hive_flutter`.

**Tech Stack:** Flutter (Dart), `audioplayers`, `flutter_animate`, `lottie`, `hive_flutter`, `google_fonts` (Noto Nastaliq Urdu / Quicksand).

**Spec:** [architecture.md](../../../architecture.md)

## Global Constraints
- Target age: 3–4 years old (Playgroup / Nursery). Giant touch targets (minimum $64 \times 64$ dp), voiceover prompts, zero cluttered menus.
- $0 Developer Cost: No paid APIs, no cloud hosting bills, 100% local/offline execution.
- Bi-directional support: Native Right-to-Left (RTL) layout switching and authentic Nastaliq calligraphy for Urdu Qayda.
- Fully offline-first: Zero network calls required during runtime.

---

### Task 1: Project Scaffolding & Asset Configuration

**Files:**
- Create: `pubspec.yaml`
- Create: `lib/main.dart`
- Create: `assets/books/barka_nursery/english_manifest.json`
- Create: `assets/books/barka_nursery/urdu_manifest.json`
- Create: `assets/books/barka_nursery/maths_manifest.json`
- Test: `test/widget_test.dart`

**Interfaces:**
- Produces: Base Flutter application with configured dependencies, asset paths, and smoke test.

- [x] **Step 1: Create pubspec.yaml with required dependencies**
  Configure dependencies: `audioplayers: ^6.0.0`, `flutter_animate: ^4.5.0`, `lottie: ^3.1.0`, `hive_flutter: ^1.1.0`, `google_fonts: ^6.2.0`, asset directories (`assets/books/`, `assets/audio/`, `assets/animations/`, `assets/fonts/`).
- [x] **Step 2: Create starter starter manifests for English, Urdu, and Maths**
  Create valid JSON manifests in `assets/books/barka_nursery/` matching the schema defined in `architecture.md`.
- [x] **Step 3: Create base lib/main.dart with initialization**
  Initialize Flutter bindings and load theme.
- [x] **Step 4: Run flutter/widget smoke test**
  Verify configuration and test passes.
- [x] **Step 5: Commit scaffolding**
  `git commit -m "chore: scaffold Flutter project with dependencies and asset manifests"`

---

### Task 2: Content Domain Models & JSON Manifest Parsers

**Files:**
- Create: `lib/features/book_engine/data/models/book_manifest.dart`
- Create: `lib/features/book_engine/data/models/book_page.dart`
- Create: `lib/features/book_engine/data/models/hotspot_item.dart`
- Create: `lib/features/book_engine/data/models/vocabulary_word.dart`
- Create: `lib/features/book_engine/data/models/mini_game_config.dart`
- Create: `lib/features/book_engine/data/repositories/book_repository.dart`
- Test: `test/features/book_engine/book_manifest_test.dart`

**Interfaces:**
- Consumes: JSON files in `assets/books/barka_nursery/*.json`.
- Produces: `BookManifest BookRepository.loadManifest(String assetPath)` with full type-safe models for pages, audio paths, and mini-games.

- [x] **Step 1: Write failing unit test for BookManifest parser**
  Test loading and parsing `english_manifest.json` and `urdu_manifest.json` verifying RTL flag, page count, and mini-game configs.
- [x] **Step 2: Run test to confirm failure**
- [x] **Step 3: Implement data models with fromJson factories**
  Implement `BookManifest`, `BookPage`, `IllustrationHotspot`, `VocabularyWord`, and `MiniGameConfig`.
- [x] **Step 4: Implement BookRepository to read rootBundle JSON**
- [x] **Step 5: Run tests and ensure all pass**
- [x] **Step 6: Commit content parser module**
  `git commit -m "feat: implement book manifest data models and JSON repository"`

---

### Task 3: Low-Latency Audio Subsystem

**Files:**
- Create: `lib/core/audio/audio_controller.dart`
- Create: `lib/core/audio/sound_effects.dart`
- Test: `test/core/audio/audio_controller_test.dart`

**Interfaces:**
- Consumes: Audio asset paths (`audio/sfx/*`, `audio/english/*`, `audio/urdu/*`).
- Produces:
  - `Future<void> AudioController.playSfx(String sfxName)`
  - `Future<void> AudioController.speakPhonics(String audioPath)`
  - `Future<void> AudioController.stopAll()`

- [x] **Step 1: Write unit test for AudioController methods and state**
  Mock audio player backend and verify concurrent SFX playback and voiceover channel prioritization.
- [x] **Step 2: Run test to confirm failure**
- [x] **Step 3: Implement AudioController with AudioPlayer instances**
  Create dedicated SFX player and voiceover player to prevent sound cutting.
- [x] **Step 4: Implement SoundEffects registry with pre-cached audio keys**
  Define keys: `pop`, `cheer`, `applause`, `ding`, `pageFlip`, `starChime`.
- [x] **Step 5: Run tests and verify passing**
- [x] **Step 6: Commit audio subsystem**
  `git commit -m "feat: add low-latency dual-channel audio controller"`

---

### Task 4: Design System, RTL Directionality & Nastaliq Typography

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_text_styles.dart`
- Create: `lib/core/widgets/bouncy_button.dart`
- Create: `lib/core/localization/rtl_helper.dart`
- Test: `test/core/widgets/bouncy_button_test.dart`

**Interfaces:**
- Produces:
  - `AppColors` (Sunny Yellow, Sky Blue, Apple Red, Grass Green, Star Gold).
  - `AppTextStyles` configured with Noto Nastaliq Urdu for Urdu script and Quicksand for English/Maths.
  - `BouncyButton`: Kid-friendly touch button with shrink-on-press and sound feedback.

- [x] **Step 1: Write widget test for BouncyButton**
  Verify animation scale trigger on tap-down, tap-up, and callback execution.
- [x] **Step 2: Run test to confirm failure**
- [x] **Step 3: Implement AppColors and AppTextStyles**
- [x] **Step 4: Implement BouncyButton using AnimatedScale and AudioController integration**
- [x] **Step 5: Run tests and verify passing**
- [x] **Step 6: Commit design system components**
  `git commit -m "feat: implement kid-friendly design system, typography and bouncy button"`

---

### Task 5: The "Living Book" Page Engine

**Files:**
- Create: `lib/features/book_engine/presentation/screens/book_reader_screen.dart`
- Create: `lib/features/book_engine/presentation/widgets/animated_hotspot.dart`
- Create: `lib/features/book_engine/presentation/widgets/word_speech_badge.dart`
- Create: `lib/features/book_engine/presentation/widgets/page_turner.dart`
- Test: `test/features/book_engine/book_reader_screen_test.dart`

**Interfaces:**
- Consumes: `BookManifest`, `AudioController`.
- Produces: Interactive page viewport with touch-animated illustrations, tap-to-pronounce word badges, and horizontal page navigation.

- [x] **Step 1: Write widget test for BookReaderScreen**
  Verify page rendering, letter display, and interaction triggers when hotspot is tapped.
- [x] **Step 2: Run test to confirm failure**
- [x] **Step 3: Implement AnimatedHotspot widget**
  Provide bounce, squish, and shake animations (`flutter_animate`) coupled with tap audio.
- [x] **Step 4: Implement WordSpeechBadge widget**
  Pill badge displaying vocabulary word that speaks pronunciation on tap.
- [x] **Step 5: Implement PageTurner with RTL swipe detection**
  Seamless page transitions respecting Urdu Right-to-Left orientation.
- [x] **Step 6: Run tests and verify passing**
- [x] **Step 7: Commit living book reader engine**
  `git commit -m "feat: implement living book reader screen with interactive animated hotspots"`

---

### Task 6: Mini-Games Engine — Finger Tracing Canvas

**Files:**
- Create: `lib/features/games/tracing/presentation/screens/tracing_screen.dart`
- Create: `lib/features/games/tracing/presentation/widgets/tracing_canvas.dart`
- Create: `lib/features/games/tracing/domain/tracing_detector.dart`
- Test: `test/features/games/tracing_detector_test.dart`

**Interfaces:**
- Consumes: `MiniGameConfig` with guide points.
- Produces: Interactive canvas where a child traces letters/Huruf/numbers, displays particle glitter trails, and detects completion ($>80\%$).

- [x] **Step 1: Write unit test for TracingDetector**
  Verify proximity calculation against ordered checkpoints and completion percentage trigger.
- [x] **Step 2: Run test to confirm failure**
- [x] **Step 3: Implement TracingDetector checkpoint algorithm**
- [x] **Step 4: Implement TracingCanvas CustomPainter**
  Draw guide paths, touched points, and celebratory star particles.
- [x] **Step 5: Implement TracingScreen with celebration fanfare**
- [x] **Step 6: Run tests and verify passing**
- [x] **Step 7: Commit tracing mini-game**
  `git commit -m "feat: implement finger tracing mini-game with stroke detection and sparkle effects"`

---

### Task 7: Mini-Games Engine — Drag & Match + Balloon Pop Quiz

**Files:**
- Create: `lib/features/games/matching/presentation/screens/matching_game_screen.dart`
- Create: `lib/features/games/balloon_pop/presentation/screens/balloon_pop_screen.dart`
- Create: `lib/features/games/balloon_pop/presentation/widgets/floating_balloon.dart`
- Test: `test/features/games/matching_game_test.dart`
- Test: `test/features/games/balloon_pop_test.dart`

**Interfaces:**
- Consumes: Vocabulary lists and target phonetic sounds.
- Produces:
  - `MatchingGameScreen`: Drag-and-drop letter-to-picture activity.
  - `BalloonPopScreen`: Audio-prompted balloon pop phonics game.

- [ ] **Step 1: Write widget test for MatchingGameScreen**
  Test dragging item to correct target, trigger success sound and score update.
- [ ] **Step 2: Write widget test for BalloonPopScreen**
  Test tapping correct balloon, pop animation, and score increment.
- [ ] **Step 3: Implement MatchingGameScreen using Draggable and DragTarget**
- [ ] **Step 4: Implement BalloonPopScreen with animated floating balloons**
- [ ] **Step 5: Run tests and ensure all pass**
- [ ] **Step 6: Commit matching and balloon pop games**
  `git commit -m "feat: implement drag-and-match and balloon pop phonics mini-games"`

---

### Task 8: Local Progress & "Barka's Sticker Album"

**Files:**
- Create: `lib/core/storage/progress_repository.dart`
- Create: `lib/features/rewards/presentation/screens/sticker_album_screen.dart`
- Create: `lib/features/rewards/data/models/sticker_item.dart`
- Test: `test/core/storage/progress_repository_test.dart`

**Interfaces:**
- Produces:
  - `ProgressRepository`: Offline persistence of completed pages, earned stars, and unlocked stickers.
  - `StickerAlbumScreen`: Barka's interactive Toy Box displaying collected badges and reward stickers.

- [ ] **Step 1: Write unit test for ProgressRepository**
  Verify saving/loading stars, marking lessons complete, and unlocking stickers offline.
- [ ] **Step 2: Run test to confirm failure**
- [ ] **Step 3: Implement ProgressRepository with Hive storage**
- [ ] **Step 4: Implement StickerAlbumScreen with interactive wiggle stickers**
- [ ] **Step 5: Run tests and verify passing**
- [ ] **Step 6: Commit reward system and local storage**
  `git commit -m "feat: implement offline progress repository and Barka's sticker album"`

---

### Task 9: Home Dashboard & Complete Integration

**Files:**
- Create: `lib/features/home/presentation/screens/home_screen.dart`
- Create: `lib/features/home/presentation/widgets/subject_card.dart`
- Modify: `lib/main.dart`
- Test: `test/features/home/home_screen_test.dart`

**Interfaces:**
- Produces: Main interactive dashboard featuring Barka Faral, subject selector (English, Urdu Qayda, Maths), Sticker Album button, and parental settings gate.

- [ ] **Step 1: Write integration test for HomeScreen navigation**
  Verify tapping English, Urdu, Maths, or Album launches the respective screens.
- [ ] **Step 2: Run test to confirm failure**
- [ ] **Step 3: Implement HomeScreen with animated character illustration and colorful cards**
- [ ] **Step 4: Connect main.dart to HomeScreen**
- [ ] **Step 5: Run all unit and widget tests across the entire project**
- [ ] **Step 6: Commit integration and complete Phase 1 deliverable**
  `git commit -m "feat: integrate home dashboard and finalize Phase 1 living book engine"`
