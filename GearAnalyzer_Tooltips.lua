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

        local graftedParts = { strsplit(":", link:match("item:[%d:]+") or "") }
        if #graftedParts >= 4 then
            local gem1 = graftedParts[3] or "0"
            local gem2 = graftedParts[4] or "0"
            local gem3 = graftedParts[5] or "0"
            local gem4 = graftedParts[6] or "0"
            tooltip:AddDoubleLine("Gems:", ("%s / %s / %s / %s"):format(gem1, gem2, gem3, gem4))
        end

        if enchantID and tonumber(enchantID) > 0 then
            local effectiveID = self:GetEffectiveEnchantID(tonumber(enchantID), slotLabel)
            if effectiveID ~= tonumber(enchantID) then
                tooltip:AddDoubleLine("Server Enchant ID:", "|cff3fc7eb" .. effectiveID .. "|r")
            end
        end
    end
end
