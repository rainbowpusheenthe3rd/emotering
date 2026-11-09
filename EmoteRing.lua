-- EmoteRing: hold its key and a ring of emotes opens round the cursor; let go over one to do it (at your target,
-- if you have one). A quick tap leaves the ring open to click instead; Escape or a click outside closes it.
-- Bind the key under Options > Keybindings > AddOns > Emote ring. /emotering (or /er) opens it too.
local ADDON, ns = ...
local DIR = "Interface\\AddOns\\EmoteRing\\"
-- the top three for roleplay first, from the top of the ring clockwise, so Smile sits top-left beside Kneel
ns.EMOTES = {
    { "KNEEL", "Kneel" }, { "PRAY", "Pray" }, { "BOW", "Bow" }, { "WAVE", "Wave" },
    { "NOD", "Nod" }, { "THANK", "Thank" }, { "CURTSEY", "Curtsey" }, { "SMILE", "Smile" },
}
local RADIUS, DISC, TAP = 78, 54, 0.25
local ring, buttons, openedAt, sticky = nil, {}, 0, false

local function Do(token)
    if DoEmote then DoEmote(token) end
end

local function Close()
    sticky = false
    if ring then ring:Hide() end
end

local function Hovered()
    for _, b in ipairs(buttons) do
        if b:IsMouseOver() then return b end
    end
end

local function Build()
    ring = CreateFrame("Frame", "EmoteRingFrame", UIParent)
    ring:SetSize(2 * RADIUS + DISC, 2 * RADIUS + DISC)
    ring:SetFrameStrata("DIALOG")
    ring:EnableMouse(true)
    ring:SetScript("OnMouseDown", Close)  -- a click outside the discs closes it
    ring:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "EmoteRingFrame") end  -- Escape closes it
    for i, e in ipairs(ns.EMOTES) do
        local a = math.pi / 2 - (i - 1) * 2 * math.pi / #ns.EMOTES
        local b = CreateFrame("Button", nil, ring)
        b:SetSize(DISC, DISC)
        b:SetPoint("CENTER", ring, "CENTER", RADIUS * math.cos(a), RADIUS * math.sin(a))
        local bg = b:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(); bg:SetTexture(DIR .. "disc")
        local glow = b:CreateTexture(nil, "HIGHLIGHT")
        glow:SetAllPoints(); glow:SetTexture(DIR .. "disc"); glow:SetBlendMode("ADD"); glow:SetVertexColor(0.6, 0.8, 1, 0.6)
        local t = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        t:SetPoint("CENTER")
        t:SetText(e[2])
        local path, size = t:GetFont()
        if path then t:SetFont(path, size, "OUTLINE") end
        b.token = e[1]
        b:SetScript("OnClick", function() Do(e[1]); Close() end)
        buttons[i] = b
    end
end

local function Open()
    if not ring then Build() end
    local x, y = GetCursorPosition()
    local s = UIParent:GetEffectiveScale()
    ring:ClearAllPoints()
    ring:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / s, y / s)
    ring:Show()
    openedAt = GetTime()
end

-- the key binding (Bindings.xml): down opens, up does the hovered emote; a tap leaves the ring open to click
function EmoteRing_Key(keystate)
    if keystate == "down" then
        if ring and ring:IsShown() then return Close() end
        sticky = false
        return Open()
    end
    if not (ring and ring:IsShown()) then return end
    local b = Hovered()
    if b then
        Do(b.token); Close()
    elseif GetTime() - openedAt < TAP then
        sticky = true  -- a tap: stays open for a click
    else
        Close()
    end
end

BINDING_HEADER_EMOTERING = "Emote ring"
BINDING_NAME_EMOTERING = "Emote ring (hold, release on an emote)"
SLASH_EMOTERING1, SLASH_EMOTERING2 = "/emotering", "/er"
SlashCmdList.EMOTERING = function() Open(); sticky = true end
