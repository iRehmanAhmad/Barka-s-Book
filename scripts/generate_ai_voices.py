"""
Barka's Book — AI Voice Audio Generator
Generates studio-grade, warm neural AI audio files for English, Urdu, and Maths lessons
using Microsoft Edge Neural TTS (100% Free, zero API key required).
"""

import asyncio
import io
import os
import sys

# Ensure UTF-8 stdout on Windows
if sys.platform == "win32":
    try:
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
    except Exception:
        pass

try:
    import edge_tts
except ImportError:
    print("Please install edge-tts first: pip install edge-tts")
    sys.exit(1)

# High-quality neural voices
VOICE_URDU = "ur-PK-UzmaNeural"      # Warm Pakistani Urdu female teacher voice
VOICE_ENGLISH = "en-US-AnaNeural"    # Cheerful, clear child voice
VOICE_TEACHER = "en-US-JennyNeural"  # Clear American English teacher voice

AUDIO_ENTRIES = [
    # English Phonics
    {
        "text": "A. Ah. Apple.",
        "voice": VOICE_ENGLISH,
        "output": "assets/audio/english/phonics/a.ogg"
    },
    {
        "text": "B. Buh. Ball.",
        "voice": VOICE_ENGLISH,
        "output": "assets/audio/english/phonics/b.ogg"
    },
    {
        "text": "C. Cuh. Cat.",
        "voice": VOICE_ENGLISH,
        "output": "assets/audio/english/phonics/c.ogg"
    },
    # English Vocabulary Words
    {"text": "Apple", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/apple.ogg"},
    {"text": "Ant", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/ant.ogg"},
    {"text": "Aeroplane", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/aeroplane.ogg"},
    {"text": "Ball", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/ball.ogg"},
    {"text": "Boy", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/boy.ogg"},
    {"text": "Butterfly", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/butterfly.ogg"},
    {"text": "Cat", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/cat.ogg"},
    {"text": "Car", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/car.ogg"},
    {"text": "Cup", "voice": VOICE_ENGLISH, "output": "assets/audio/english/words/cup.ogg"},

    # Urdu Phonics (Huruf-e-Tahajji)
    {
        "text": "الف۔ الف سے انار۔",
        "voice": VOICE_URDU,
        "output": "assets/audio/urdu/phonics/alif.ogg"
    },
    {
        "text": "بے۔ بے سے بلی۔",
        "voice": VOICE_URDU,
        "output": "assets/audio/urdu/phonics/bay.ogg"
    },
    {
        "text": "پے۔ پے سے پنکھا۔",
        "voice": VOICE_URDU,
        "output": "assets/audio/urdu/phonics/pay.ogg"
    },
    # Urdu Vocabulary Words
    {"text": "انار", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/anaar.ogg"},
    {"text": "انگور", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/angoor.ogg"},
    {"text": "اونٹ", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/oont.ogg"},
    {"text": "بلی", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/billi.ogg"},
    {"text": "بطخ", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/batakh.ogg"},
    {"text": "بستہ", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/basta.ogg"},
    {"text": "پنکھا", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/pankha.ogg"},
    {"text": "پتنگ", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/patang.ogg"},
    {"text": "پودا", "voice": VOICE_URDU, "output": "assets/audio/urdu/words/pauda.ogg"},

    # Maths Numbers & Items
    {"text": "One. ایک.", "voice": VOICE_TEACHER, "output": "assets/audio/maths/one.ogg"},
    {"text": "Two. دو.", "voice": VOICE_TEACHER, "output": "assets/audio/maths/two.ogg"},
    {"text": "Three. تین.", "voice": VOICE_TEACHER, "output": "assets/audio/maths/three.ogg"},
    {"text": "One Shining Sun!", "voice": VOICE_ENGLISH, "output": "assets/audio/maths/one_sun.ogg"},
    {"text": "Two Flying Birds!", "voice": VOICE_ENGLISH, "output": "assets/audio/maths/two_birds.ogg"},
    {"text": "Three Red Apples!", "voice": VOICE_ENGLISH, "output": "assets/audio/maths/three_apples.ogg"},

    # Sound Effects (SFX)
    {"text": "Pop!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/pop_chime.ogg"},
    {"text": "Yay! Super! Great job!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/cheer.ogg"},
    {"text": "Hooray! Bravo! Wonderful!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/applause.ogg"},
    {"text": "Boing! Bounce!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/boing.ogg"},
    {"text": "Next page! Let us go!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/page_flip.ogg"},
    {"text": "Twinkle star! Sparkle!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/star_chime.ogg"},
    {"text": "Crunch, crunch! Yummy!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/apple_crunch.ogg"},
    {"text": "Meow! Sweet kitty!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/cat_meow.ogg"},
    {"text": "Whoosh! Zoom!", "voice": VOICE_ENGLISH, "output": "assets/audio/sfx/whoosh.ogg"},
]


async def generate_audio():
    import shutil
    print(f"🎙️ Generating {len(AUDIO_ENTRIES)} AI voice & SFX files for Barka's Book...")

    for item in AUDIO_ENTRIES:
        out_ogg = item["output"]
        out_mp3 = out_ogg.rsplit(".", 1)[0] + ".mp3"
        os.makedirs(os.path.dirname(out_ogg), exist_ok=True)

        print(f"🔊 Generating: [{item['voice']}] '{item['text']}' -> {out_mp3} & {out_ogg}")
        communicate = edge_tts.Communicate(item["text"], item["voice"])
        await communicate.save(out_mp3)
        shutil.copyfile(out_mp3, out_ogg)

    print("\n✨ All AI voice and SFX files generated successfully in assets/audio/ (both .mp3 and .ogg)!")


if __name__ == "__main__":
    asyncio.run(generate_audio())
