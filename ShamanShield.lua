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
warningFrame:SetWidth(300)
warningFrame:SetHeight(60)
warningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
warningFrame:Hide()

-- Background
warningFrame.bg = warningFrame:CreateTexture(nil, "BACKGROUND")
warningFrame.bg:SetAllPoints(true)
warningFrame.bg:SetTexture(0, 0, 0, 0.7)

-- Warning text
warningFrame.text = warningFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
warningFrame.text:SetPoint("CENTER", warningFrame, "CENTER", 0, 0)
warningFrame.text:SetTextColor(1, 0.2, 0.2)
warningFrame.text:SetText("SHIELD MISSING!")

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
