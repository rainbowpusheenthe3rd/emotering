-- EmoteRing against a stubbed game: hold and release over an emote, tap then click, release over nothing.
local dir = ...
local ok = 0
local function check(c, msg) assert(c, msg); ok = ok + 1 end
local now, done, over = 0, {}, nil
function GetTime() return now end
function GetCursorPosition() return 500, 400 end
function DoEmote(t) done[#done + 1] = t end
UISpecialFrames = {}
SlashCmdList = {}
local function region()
    local r = { shown = false }
    for _, m in ipairs({ "SetSize", "SetPoint", "ClearAllPoints", "SetAllPoints", "SetTexture", "SetBlendMode",
                         "SetVertexColor", "SetFrameStrata", "EnableMouse", "SetText", "SetFont" }) do r[m] = function() end end
    function r:Show() self.shown = true end
    function r:Hide() self.shown = false end
    function r:IsShown() return self.shown end
    function r:GetFont() return "Fonts\\FRIZQT__.TTF", 12 end
    return r
end
UIParent = region(); function UIParent:GetEffectiveScale() return 1 end
local made = {}
function CreateFrame(kind)
    local f = region()
    f.scripts = {}
    function f:SetScript(k, fn) self.scripts[k] = fn end
    function f:CreateTexture() return region() end
    function f:CreateFontString() return region() end
    function f:IsMouseOver() return over == self end
    if kind == "Button" then made[#made + 1] = f end
    return f
end

local ns = {}
assert(loadfile(dir .. "/EmoteRing.lua"))("EmoteRing", ns)
check(ns.EMOTES[1][1] == "KNEEL" and ns.EMOTES[2][1] == "PRAY" and ns.EMOTES[8][1] == "SMILE", "kneel, pray and smile at the top")

EmoteRing_Key("down"); check(#made == 8, "key down opens a ring of eight")
over = made[1]; now = 1; EmoteRing_Key("up")
check(done[1] == "KNEEL", "hold, release over Kneel: kneels")

now = 2; EmoteRing_Key("down"); over = nil; now = 2.1; EmoteRing_Key("up")
check(#done == 1, "a tap does nothing yet")
made[8].scripts.OnClick(); check(done[2] == "SMILE", "and stays open to click Smile")

now = 3; EmoteRing_Key("down"); now = 4; EmoteRing_Key("up")
check(#done == 2, "a long hold released over nothing does nothing")
SlashCmdList.EMOTERING(""); made[2].scripts.OnClick(); check(done[3] == "PRAY", "/er opens it to click: Pray")
return ok
