"""
Barka's Book — AI Voice Audio Generator
Generates studio-grade, warm neural AI audio files for English, Urdu, and Maths lessons
using Microsoft Edge Neural TTS (100% Free, zero API key required).
"""

import asyncio
import os
import sys

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
]


async def generate_audio():
    print(f"🎙️ Generating {len(AUDIO_ENTRIES)} AI voice files for Barka's Book...")

    for item in AUDIO_ENTRIES:
        out_path = item["output"]
        os.makedirs(os.path.dirname(out_path), exist_ok=True)

        print(f"🔊 Generating: [{item['voice']}] '{item['text']}' -> {out_path}")
        communicate = edge_tts.Communicate(item["text"], item["voice"])
        await communicate.save(out_path)

    print("\n✨ All AI voice files generated successfully in assets/audio/!")


if __name__ == "__main__":
    asyncio.run(generate_audio())
