# EmoteRing

### Kneel, pray or smile in the middle of a scene without typing a word: hold one key, let go on the emote.

## What you get

- **The emotes roleplay leans on, one gesture away.** Hold your Emote ring key and eight emotes open round the
  cursor: Kneel, Pray, Bow, Wave, Nod, Thank, Curtsey and Smile, clockwise from the top. Let go over one and your
  character does it.
- **Aimed where you mean it.** With a target, the emote goes to them, as a typed one would.
- **Tap or hold, as you like.** A quick tap leaves the ring open so you can click an emote instead; Escape, a click
  outside the emotes or the key again closes it.
- **Quiet on screen.** Nothing shows until you call it: moonlit discs with a silver rim, lit under the cursor.
- **No key needed to try it.** `/er` or `/emotering` opens the ring to click.

## Why

Roleplay happens in the pauses between lines, and that is where the game makes you stop and type. Kneeling before a
priest, bowing out of a conversation or smiling at a friend means breaking off to type `/kneel` or `/bow` while the
moment passes. EmoteRing puts the gestures a scene needs under one key, so your character can answer as fast as you
can.

## Download

1. Download `EmoteRing-vX.Y.Z.zip` from the [latest release](https://github.com/rainbowpusheenthe3rd/emotering/releases/latest).
2. Unzip the `EmoteRing` folder into `World of Warcraft\_forever_\Interface\AddOns`.
3. Log in and set a key in Key Bindings, under AddOns, Emote ring.

Commands: `/er` or `/emotering` opens the ring to click.

<details>
<summary>Art and development</summary>

The disc behind each emote is drawn in code by `tools/emotering_textures.py`, which writes `disc.tga`.

For development, link the game's folder to this repo (a directory junction, run once):

```powershell
New-Item -ItemType Junction -Path "<WoW folder>\_forever_\Interface\AddOns\EmoteRing" -Target "<this repo>"
```

`tests/` holds its smoke test, which runs the addon against a stubbed game (`uv run --with lupa --with pytest pytest tests/`).

</details>
