r"""Draw EmoteRing's disc: addon/EmoteRing/disc.tga, a 64x64 moonlit disc with a silver rim, for each emote.

  python tools/emotering_textures.py
"""
import struct
from pathlib import Path

import numpy as np

OUT = Path(__file__).resolve().parents[1] / "addon" / "EmoteRing" / "disc.tga"
SIZE, SS = 64, 4


def main():
    n = SIZE * SS
    y, x = (np.mgrid[0:n, 0:n] + 0.5) / SS - SIZE / 2
    r = np.hypot(x, y) / (SIZE / 2 - 1)
    alpha = np.clip((1 - r) * SIZE / 2, 0, 1)
    # deep night violet, lighter towards the top-left like moonlight, and a silver rim
    light = np.clip(0.5 - (x + y) / SIZE, 0, 1)
    rgb = np.stack([0.10 + 0.10 * light, 0.07 + 0.08 * light, 0.20 + 0.16 * light], axis=-1)
    rim = np.exp(-((r - 0.9) / 0.05) ** 2)[..., None]
    rgb = rgb * (1 - rim) + np.array([0.78, 0.80, 0.92]) * rim
    rgb = rgb.reshape(SIZE, SS, SIZE, SS, 3).mean(axis=(1, 3))
    alpha = (alpha * 0.92).reshape(SIZE, SS, SIZE, SS).mean(axis=(1, 3))
    v = (np.clip(rgb, 0, 1) * 255).round().astype(np.uint8)
    a = (np.clip(alpha, 0, 1) * 255).round().astype(np.uint8)
    head = struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, SIZE, SIZE, 32, 0x28)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_bytes(head + np.dstack([v[..., 2], v[..., 1], v[..., 0], a]).tobytes())
    print(OUT)


if __name__ == "__main__":
    main()
