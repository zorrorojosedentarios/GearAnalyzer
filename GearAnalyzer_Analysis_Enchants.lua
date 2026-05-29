-- ============================================================
-- GearAnalyzer: Módulo de Análisis de Encantamientos (VERSIÓN ORIGINAL)
-- Sincronizado con la lógica de GearAnalyzer-ori
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Enchants = GearAnalyzer:NewModule("AnalysisEnchants")

-- [FILTRO DE RANURAS] Solo estas ranuras pueden llevar encantamiento
local ENCHANTABLE = { 
    head=true, shoulders=true, back=true, chest=true, wrists=true, 
    hands=true, legs=true, feet=true, weapon=true, offhand=true, 
    waist=true, ranged=true, ring1=true, ring2=true
}

function Enchants:AnalyzeItem(itemData, ignoreForced)
    local link = itemData.itemLink
    local slotID = itemData.slotID
    local slotKey = GearAnalyzer:GetSlotKey(itemData.slotName, slotID)
    local prefix = ignoreForced and "" or "guide_"

    -- 1. ¿Es un slot encantable?
    if not ENCHANTABLE[slotKey] or not link then
        itemData[prefix.."enchStatus"] = 2
        itemData[prefix.."enchTooltip"] = "|cff777777" .. L["NOT_REQUIRED"] .. "|r"
        return
    end

    -- 2. Casos Especiales (Mano Izquierda no-escudo)
    if slotKey == "offhand" then
        local name, _, _, _, _, _, subclass = GetItemInfo(link)
        if subclass and not (subclass:find("Escudo") or subclass:find("Shield")) then
            itemData[prefix.."enchStatus"] = 2
            itemData[prefix.."enchTooltip"] = "|cff00ff00" .. L["NOT_REQUIRED"] .. " (No es escudo)|r"
            return
        end
    end

    -- 3. Obtener recomendación de la Spec (usa APIs inline en vez de módulo State inexistente)
    local classToken = GearAnalyzer:GetClassToken(ignoreForced)
    local specKey = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local normSpec = GearAnalyzer:NormalizeSpecName(specKey)
    local classData = GearAnalyzer.ClassData and GearAnalyzer.ClassData[classToken]
    if not classData or not classData.Enchants then return end
    
    local specEnchants = classData.Enchants[normSpec] or classData.Enchants[specKey] or classData.Enchants[specKey.." DPS"] or classData.Enchants[specKey.." Tank"]
    if not specEnchants then return end

    local recID = specEnchants[slotKey]
    if not recID then
        itemData[prefix.."enchStatus"] = 2
        itemData[prefix.."enchTooltip"] = "|cff777777" .. L["NOT_REQUIRED"] .. "|r"
        return
    end

    -- 4. Extraer encantamiento actual (Utilizando el escaneo previo con soporte para Hebilla y Profesiones)
    local currentEnchantID = tonumber(itemData.enchant) or 0
    if currentEnchantID == 0 and link then
        local itemStr = link:match("item:([%d:]+)")
        if itemStr then
            local parts = { strsplit(":", itemStr) }
            currentEnchantID = tonumber(parts[2]) or 0
        end
    end
    
    -- 4b. Verificar si es un beneficio de profesión válido
    if currentEnchantID > 0 and GearAnalyzer.ProfessionsDB then
        local profData = GearAnalyzer.ProfessionsDB[currentEnchantID]
        if profData then
            local myProfs = GearAnalyzer:GetProfessionsList()
            if myProfs and myProfs[profData.prof] then
                if profData.slot == slotKey or (profData.slot == "ring" and (slotKey == "ring1" or slotKey == "ring2")) then
                    itemData[prefix.."enchStatus"] = 3
                    itemData[prefix.."enchTooltip"] = "|cffffa500" .. (L["PROFESSION_BENEFIT"] or "Beneficio de profesión") .. " (" .. (profData.name or "") .. ")|r"
                    return
                end
            end
        end
    end
    
    
    -- 5. Comparar con IDs efectivos (Soporte para profesiones)
    local isMatch = false
    local recList = (type(recID) == "table") and recID or { recID }
    
    for _, id in ipairs(recList) do
        if currentEnchantID == id then isMatch = true break end
        -- Búsqueda por nombre (Normalización)
        local d1 = GearAnalyzer:GetEnchantData(currentEnchantID)
        local d2 = GearAnalyzer:GetEnchantData(id)
        if d1 and d2 and d1.name and d2.name then
            local function n(s)
                if not s then return "" end
                s = s:lower()
                s = s:gsub("[áa]", "a"):gsub("[ée]", "e"):gsub("[íi]", "i"):gsub("[óo]", "o"):gsub("[úu]", "u"):gsub("[ñn]", "n")
                s = s:gsub("[^a-z0-9]", "")
                return s
            end
            if n(d1.name) == n(d2.name) then isMatch = true break end
        end
    end

    if currentEnchantID == 0 then
        itemData[prefix.."enchStatus"] = 0
        local recData = GearAnalyzer:GetEnchantData(recList[1])
        itemData[prefix.."enchTooltip"] = "|cffff0000" .. L["MISSING_ENCHANT"] .. "|r\nSugerido: " .. (recData and recData.name or "ID:"..recList[1])
    elseif not isMatch then
        itemData[prefix.."enchStatus"] = 1
        local recData = GearAnalyzer:GetEnchantData(recList[1])
        local curData = GearAnalyzer:GetEnchantData(currentEnchantID)
        itemData[prefix.."enchTooltip"] = "|cffffff00" .. L["IMPROVABLE_ENCHANT"] .. ":|r\n" .. (curData and curData.name or "ID:"..currentEnchantID) .. " -> |cff00ff00" .. (recData and recData.name or "ID:"..recList[1]) .. "|r"
    else
        itemData[prefix.."enchStatus"] = 2
        itemData[prefix.."enchTooltip"] = "|cff00ff00" .. L["ENCHANT_OK"] .. "|r"
    end
end
