-- ============================================================
-- GearAnalyzer: Minimap Button (LDB)
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub:GetLibrary("LibDBIcon-1.0", true)

function GearAnalyzer:SetupMinimapButton()
    if not LDB or not LDBIcon then return end
    
    -- Evitar registros duplicados que pueden causar fallos en LibDBIcon
    if self.minimapRegistered then return end

    local gaLDB = LDB:NewDataObject("GearAnalyzer", {
        type = "launcher",
        text = "GearAnalyzer",
        icon = "Interface\\AddOns\\GearAnalyzer\\icono.tga",
        OnClick = function(self, button)
            if button == "LeftButton" then
                GearAnalyzer:ToggleUI()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cff3fc7ebGearAnalyzer|r")
            tooltip:AddLine("|cffffffff" .. L["LEFT_CLICK_OPEN"] .. "|r")
            tooltip:AddLine("|cff888888" .. string.format(L["VERSION_TOOLTIP"], GearAnalyzer.version or "v3.5") .. "|r")
        end,
    })

    -- Usar la base de datos de perfil directamente para evitar fallos de inicialización
    if not self.db or not self.db.profile or not self.db.profile.settings then return end
    
    local settings = self.db.profile.settings
    settings.minimap = settings.minimap or { hide = false }

    LDBIcon:Register("GearAnalyzer", gaLDB, settings.minimap)
    self.minimapRegistered = true
end
