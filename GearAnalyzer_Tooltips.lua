-- ============================================================
-- GearAnalyzer: Tooltip Hooks
-- Enhancing GameTooltip with item information and debug data
-- ============================================================

function GearAnalyzer:OnTooltipSetItem(tooltip)
    local name, link = tooltip:GetItem()
    if not link then return end

    local devMode = self.db.profile.settings.devMode
    local itemID = link:match("item:(%d+)")
    local enchantID = link:match("item:%d+:(%d+)")
    
    local slotMapper = {
        [1] = "Cabeza", [3] = "Hombros", [15] = "Espalda", [5] = "Pecho",
        [9] = "Muñecas", [10] = "Manos", [7] = "Piernas", [8] = "Pies",
        [6] = "Cintura", [16] = "Arma Principal", [17] = "Mano Izquierda", [18] = "Rango"
    }

    local owner = tooltip:GetOwner()
    local slotLabel = nil
    if owner and owner.GetID then
        local slotID = owner:GetID()
        if slotID and slotID >= 1 and slotID <= 19 then
            slotLabel = slotMapper[slotID]
        end
    end

    if devMode then
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine("|cff3fc7ebGearAnalyzer Debug:|r", "|cffffd100[MODO DEV]|r")
        tooltip:AddDoubleLine("Item ID:", "|cffffffff" .. (itemID or "0") .. "|r")
        tooltip:AddDoubleLine("Enchant ID (Master):", "|cff00ff00" .. (enchantID or "0") .. "|r")
        
        if enchantID and tonumber(enchantID) > 0 then
            local effectiveID = self:GetEffectiveEnchantID(tonumber(enchantID), slotLabel)
            tooltip:AddDoubleLine("Server Enchant ID:", "|cff3fc7eb" .. effectiveID .. "|r")
        end
    end
end
