"""
Barka's Book — AI Voice & Sound Effects Audio Generator
Generates warm, melodic kindergarten teacher AI audio files for English, Urdu, and Maths lessons
using Microsoft Edge Neural TTS with slower teacher pacing, plus procedural musical sound effects.
"""

import asyncio
import io
import os
import shutil
import sys
import numpy as np
import wave

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
VOICE_URDU = "ur-PK-UzmaNeural"      # Warm Pakistani Urdu teacher voice
VOICE_ENGLISH = "en-US-AriaNeural"   # Expressive, cheerful, warm American nursery teacher
VOICE_TEACHER = "en-US-AriaNeural"   # Warm teacher voice

AUDIO_ENTRIES = [
    # English Phonics (Warm, slower pacing, joyful kindergarten phrasing)
    {
        "text": "Letter A! Ah, ah, Apple!",
        "voice": VOICE_ENGLISH,
        "rate": "-12%",
        "output": "assets/audio/english/phonics/a"
    },
    {
        "text": "Letter B! Buh, buh, Ball!",
        "voice": VOICE_ENGLISH,
        "rate": "-12%",
        "output": "assets/audio/english/phonics/b"
    },
    {
        "text": "Letter C! Cuh, cuh, Cat!",
        "voice": VOICE_ENGLISH,
        "rate": "-12%",
        "output": "assets/audio/english/phonics/c"
    },
    # English Vocabulary Words
    {"text": "Apple", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/apple"},
    {"text": "Ant", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/ant"},
    {"text": "Aeroplane", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/aeroplane"},
    {"text": "Ball", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/ball"},
    {"text": "Boy", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/boy"},
    {"text": "Butterfly", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/butterfly"},
    {"text": "Cat", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/cat"},
    {"text": "Car", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/car"},
    {"text": "Cup", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/english/words/cup"},

    # Urdu Phonics (Huruf-e-Tahajji - Slower, affectionate nursery pacing)
    {
        "text": "الف ... الف سے انار!",
        "voice": VOICE_URDU,
        "rate": "-14%",
        "output": "assets/audio/urdu/phonics/alif"
    },
    {
        "text": "بے ... بے سے بلی!",
        "voice": VOICE_URDU,
        "rate": "-14%",
        "output": "assets/audio/urdu/phonics/bay"
    },
    {
        "text": "پے ... پے سے پنکھا!",
        "voice": VOICE_URDU,
        "rate": "-14%",
        "output": "assets/audio/urdu/phonics/pay"
    },
    # Urdu Vocabulary Words
    {"text": "انار", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/anaar"},
    {"text": "انگور", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/angoor"},
    {"text": "اونٹ", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/oont"},
    {"text": "بلی", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/billi"},
    {"text": "بطخ", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/batakh"},
    {"text": "بستہ", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/basta"},
    {"text": "پنکھا", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/pankha"},
    {"text": "پتنگ", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/patang"},
    {"text": "پودا", "voice": VOICE_URDU, "rate": "-12%", "output": "assets/audio/urdu/words/pauda"},

    # Maths Numbers & Items
    {"text": "Number One! ایک!", "voice": VOICE_TEACHER, "rate": "-10%", "output": "assets/audio/maths/one"},
    {"text": "Number Two! دو!", "voice": VOICE_TEACHER, "rate": "-10%", "output": "assets/audio/maths/two"},
    {"text": "Number Three! تین!", "voice": VOICE_TEACHER, "rate": "-10%", "output": "assets/audio/maths/three"},
    {"text": "One shining sun!", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/maths/one_sun"},
    {"text": "Two flying birds!", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/maths/two_birds"},
    {"text": "Three red apples!", "voice": VOICE_ENGLISH, "rate": "-10%", "output": "assets/audio/maths/three_apples"},
]


SR = 44100

def write_wav(path, samples):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    samples = np.clip(samples, -0.95, 0.95)
    int_samples = (samples * 32767).astype(np.int16)
    with wave.open(path, 'w') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(SR)
        wf.writeframes(int_samples.tobytes())


def generate_sfx():
    print("🎵 Synthesizing 9 musical sound effects & chimes...")
    os.makedirs("assets/audio/sfx", exist_ok=True)

    # 1. Pop Chime: bubble pop + high marimba chime (0.28s)
    t1 = np.linspace(0, 0.28, int(SR * 0.28), False)
    pop = np.sin(2 * np.pi * np.linspace(300, 850, len(t1)) * t1) * np.exp(-t1 * 26)
    chime = np.sin(2 * np.pi * 1400 * t1) * np.exp(-t1 * 12) * 0.4
    sfx_pop = pop + chime

    # 2. Boing: cartoon spring wobble (0.45s)
    t2 = np.linspace(0, 0.45, int(SR * 0.45), False)
    mod = 120 * np.sin(2 * np.pi * 18 * t2)
    carrier_freq = np.linspace(180, 480, len(t2)) + mod
    sfx_boing = np.sin(2 * np.pi * carrier_freq * t2) * np.exp(-t2 * 6)

    # 3. Star Chime: celestial 5-note sparkle arpeggio (0.7s)
    t3 = np.linspace(0, 0.7, int(SR * 0.7), False)
    sfx_star = np.zeros_like(t3)
    notes = [1046.5, 1318.5, 1568.0, 2093.0, 2637.0] # C6, E6, G6, C7, E7
    for i, f in enumerate(notes):
        start = int(i * 0.08 * SR)
        dur = len(t3) - start
        if dur > 0:
            sub_t = np.linspace(0, dur / SR, dur, False)
            tone = np.sin(2 * np.pi * f * sub_t) * np.exp(-sub_t * 8) * 0.25
            tone += np.sin(4 * np.pi * f * sub_t) * np.exp(-sub_t * 14) * 0.08
            sfx_star[start:] += tone

    # 4. Page Flip: soft paper rustle (0.2s)
    t4 = np.linspace(0, 0.2, int(SR * 0.2), False)
    sfx_page = np.random.uniform(-1, 1, len(t4)) * np.sin(np.pi * t4 / 0.2) ** 2 * np.exp(-t4 * 10) * 0.35

    # 5. Whoosh: airy wind sweep (0.32s)
    t5 = np.linspace(0, 0.32, int(SR * 0.32), False)
    sweep = np.sin(2 * np.pi * np.linspace(200, 600, len(t5)) * t5) * np.sin(np.pi * t5 / 0.32) * 0.3
    sweep += np.random.uniform(-1, 1, len(t5)) * np.sin(np.pi * t5 / 0.32) ** 2 * 0.2
    sfx_whoosh = sweep

    # 6. Apple Crunch: crisp snappy bite (0.3s)
    t6 = np.linspace(0, 0.3, int(SR * 0.3), False)
    sfx_crunch = np.random.uniform(-1, 1, len(t6)) * (np.exp(-t6 * 20) + 0.5 * np.exp(-((t6 - 0.08)**2) * 2000)) * 0.4

    # 7. Cat Meow: cute kitten meow (0.5s)
    t7 = np.linspace(0, 0.5, int(SR * 0.5), False)
    pitch7 = 550 + 250 * np.sin(np.pi * t7 / 0.5) - 100 * t7
    sfx_cat = (np.sin(2 * np.pi * pitch7 * t7) + 0.4 * np.sin(4 * np.pi * pitch7 * t7)) * np.sin(np.pi * t7 / 0.5) * 0.5

    # 8. Cheer: celebratory victory fanfare chords (0.8s)
    t8 = np.linspace(0, 0.8, int(SR * 0.8), False)
    sfx_cheer = np.zeros_like(t8)
    for f in [523.25, 659.25, 783.99, 1046.5]:
        sfx_cheer += np.sin(2 * np.pi * f * t8) * np.exp(-t8 * 3.5) * 0.2
    sfx_cheer += np.sin(2 * np.pi * 1318.5 * t8) * np.exp(-t8 * 4.5) * 0.15

    # 9. Applause: celebratory victory chords with rhythmic clapping (0.8s)
    t9 = np.linspace(0, 0.8, int(SR * 0.8), False)
    sfx_applause = np.zeros_like(t9)
    for f in [698.46, 880.0, 1046.5, 1396.9]:
        sfx_applause += np.sin(2 * np.pi * f * t9) * np.exp(-t9 * 3.2) * 0.2
    claps = np.random.uniform(-1, 1, len(t9)) * (np.sin(2 * np.pi * 8 * t9)**4) * np.exp(-t9 * 2) * 0.25
    sfx_applause += claps

    sfx_dict = {
        "pop_chime": sfx_pop,
        "boing": sfx_boing,
        "star_chime": sfx_star,
        "page_flip": sfx_page,
        "whoosh": sfx_whoosh,
        "apple_crunch": sfx_crunch,
        "cat_meow": sfx_cat,
        "cheer": sfx_cheer,
        "applause": sfx_applause,
    }

    for name, samples in sfx_dict.items():
        base = f"assets/audio/sfx/{name}"
        wav_file = f"{base}.wav"
        mp3_file = f"{base}.mp3"
        ogg_file = f"{base}.ogg"

        write_wav(wav_file, samples)
        # Duplicate to mp3 and ogg filenames so players looking for any extension find it
        shutil.copyfile(wav_file, mp3_file)
        shutil.copyfile(wav_file, ogg_file)
        print(f"✨ Synthesized: {base}.(wav/mp3/ogg)")


async def generate_voices():
    print(f"\n🎙️ Generating {len(AUDIO_ENTRIES)} warm teacher AI voice files...")

    for item in AUDIO_ENTRIES:
        base = item["output"]
        os.makedirs(os.path.dirname(base), exist_ok=True)
        mp3_file = f"{base}.mp3"
        ogg_file = f"{base}.ogg"

        print(f"🔊 [{item['voice']} {item['rate']}] '{item['text']}' -> {mp3_file}")
        communicate = edge_tts.Communicate(item["text"], item["voice"], rate=item["rate"])
        await communicate.save(mp3_file)
        shutil.copyfile(mp3_file, ogg_file)

    print("\n✨ All voice files generated successfully with warm teacher pacing!")


async def main():
    generate_sfx()
    await generate_voices()
    print("\n🎉 Audio generation completed successfully!")


if __name__ == "__main__":
    asyncio.run(main())
