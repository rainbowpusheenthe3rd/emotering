from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]


def test_emotering_harness():
    """Hold and release, tap then click, and the slash command, against a stubbed game."""
    lua51 = pytest.importorskip("lupa.lua51")
    run = lua51.LuaRuntime().eval("function(p, d) return assert(loadfile(p))(d) end")
    assert run(str(ROOT / "tests/lua/emotering_harness.lua"), str(ROOT)) == 7
