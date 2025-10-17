-- ShamanShield: Monitors Water Shield and Lightning Shield buffs
local addonName = "ShamanShield"
local frame = CreateFrame("Frame", addonName .. "Frame", UIParent)

-- Create tooltip for scanning buffs
local scanTooltip = CreateFrame("GameTooltip", addonName .. "ScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

-- Spell names (Classic WoW)
local WATER_SHIELD = "Water Shield"
local LIGHTNING_SHIELD = "Lightning Shield"

-- Warning frame
local warningFrame = CreateFrame("Frame", addonName .. "Warning", UIParent)
warningFrame:SetWidth(200)
warningFrame:SetHeight(40)
warningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 350)
warningFrame:Hide()

-- Background
warningFrame.bg = warningFrame:CreateTexture(nil, "BACKGROUND")
warningFrame.bg:SetAllPoints(true)
warningFrame.bg:SetTexture(0, 0, 0, 0.8)

-- Border (top)
warningFrame.borderTop = warningFrame:CreateTexture(nil, "BORDER")
warningFrame.borderTop:SetHeight(2)
warningFrame.borderTop:SetPoint("TOPLEFT", warningFrame, "TOPLEFT", 0, 0)
warningFrame.borderTop:SetPoint("TOPRIGHT", warningFrame, "TOPRIGHT", 0, 0)
warningFrame.borderTop:SetTexture(0.3, 0.6, 1, 0.9)

-- Border (bottom)
warningFrame.borderBottom = warningFrame:CreateTexture(nil, "BORDER")
warningFrame.borderBottom:SetHeight(2)
warningFrame.borderBottom:SetPoint("BOTTOMLEFT", warningFrame, "BOTTOMLEFT", 0, 0)
warningFrame.borderBottom:SetPoint("BOTTOMRIGHT", warningFrame, "BOTTOMRIGHT", 0, 0)
warningFrame.borderBottom:SetTexture(0.3, 0.6, 1, 0.9)

-- Border (left)
warningFrame.borderLeft = warningFrame:CreateTexture(nil, "BORDER")
warningFrame.borderLeft:SetWidth(2)
warningFrame.borderLeft:SetPoint("TOPLEFT", warningFrame, "TOPLEFT", 0, 0)
warningFrame.borderLeft:SetPoint("BOTTOMLEFT", warningFrame, "BOTTOMLEFT", 0, 0)
warningFrame.borderLeft:SetTexture(0.3, 0.6, 1, 0.9)

-- Border (right)
warningFrame.borderRight = warningFrame:CreateTexture(nil, "BORDER")
warningFrame.borderRight:SetWidth(2)
warningFrame.borderRight:SetPoint("TOPRIGHT", warningFrame, "TOPRIGHT", 0, 0)
warningFrame.borderRight:SetPoint("BOTTOMRIGHT", warningFrame, "BOTTOMRIGHT", 0, 0)
warningFrame.borderRight:SetTexture(0.3, 0.6, 1, 0.9)

-- Warning text
warningFrame.text = warningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
warningFrame.text:SetPoint("CENTER", warningFrame, "CENTER", 0, 0)
warningFrame.text:SetTextColor(1, 0.85, 0.2)
warningFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
warningFrame.text:SetText("⚠ SHIELD MISSING ⚠")

-- Check if player has a shield buff
local function HasShieldBuff()
    for i = 0, 31 do
        local buffTexture = GetPlayerBuffTexture(i)
        if buffTexture then
            scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
            scanTooltip:SetPlayerBuff(i)
            local buffName = (getglobal(addonName .. "ScanTooltipTextLeft1") and
                                 getglobal(addonName .. "ScanTooltipTextLeft1"):GetText()) or ""
            scanTooltip:Hide()

            if buffName == WATER_SHIELD or buffName == LIGHTNING_SHIELD then
                return true
            end
        end
    end
    return false
end

-- Update shield status
local function UpdateShieldStatus()
    -- Only check if player is a Shaman
    local _, playerClass = UnitClass("player")
    if playerClass ~= "SHAMAN" then
        return
    end

    -- Check if in combat or alive
    local isDead = UnitIsDead("player")
    local isGhost = UnitIsGhost("player")

    if isDead or isGhost then
        warningFrame:Hide()
        return
    end

    -- Show warning if no shield buff is active
    if HasShieldBuff() then
        warningFrame:Hide()
    else
        warningFrame:Show()
    end
end

-- Periodic check (every 0.5 seconds)
local timeSinceLastUpdate = 0
frame:SetScript("OnUpdate", function()
    timeSinceLastUpdate = timeSinceLastUpdate + arg1
    if timeSinceLastUpdate >= 0.5 then
        UpdateShieldStatus()
        timeSinceLastUpdate = 0
    end
end)

print("|cff00ff00" .. addonName .. " loaded!|r Monitoring Water Shield and Lightning Shield.")
