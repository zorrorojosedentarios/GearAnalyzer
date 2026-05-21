-- =========================
-- GearAnalyzer: Gem Analysis
-- Logic for Sockets, Professional Gems, and Meta Requirements
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

function GearAnalyzer:AnalyzeItemGems(d, dynamicGems, metaActive, metaError, ignoreForced)
    if not d.itemLink then return end
    
    local class = self:GetClassToken(ignoreForced)
    local currentSpec = self:GetCurrentSpecEnhanced(ignoreForced)
    
    -- 1. Slots que pueden llevar gemas
    local CAN_HAVE_GEMS = { 
        head=true, neck=true, shoulders=true, back=true, chest=true, wrists=true, 
        hands=true, waist=true, legs=true, feet=true, ring1=true, ring2=true, 
        weapon=true, offhand=true, ranged=true, idol=true, relic=true
    }

    local slotKey = self:GetSlotKey(d.slotName, d.slotID)
    if not CAN_HAVE_GEMS[slotKey] then
        d.gemStatus, d.gemTooltip = 2, "No requiere"
        return
    end

    -- 2. Lógica Dinámica de Huecos y Bonos
    local socketSlots, socketBonusText, bonusVal, bonusStat = self:GetItemSocketColors(d.itemLink or "")
    local totalSockets = #socketSlots
    d.socketBonusText = socketBonusText
    d.bonusStat = bonusStat
    d.bonusVal = bonusVal
    d.socketSlotsAvailable = socketSlots
    
    -- Detectar gemas actuales
    local filledGems = (d.gems and #d.gems) or 0
    
    if totalSockets == 0 and not socketBonusText then
        d.gemStatus, d.gemTooltip = 2, "No requiere"
        return
    end

    if not dynamicGems then
        d.gemStatus, d.gemTooltip = 2, "|cffffa500Spec No Soportada|r\nNo hay datos de gemas para " .. (currentSpec or "esta spec")
        return
    end

    local recRed = GearAnalyzer:GetEffectiveEnchantID(dynamicGems.red, "gem") or dynamicGems.red
    local recYel = GearAnalyzer:GetEffectiveEnchantID(dynamicGems.yellow, "gem") or dynamicGems.yellow
    local recBlu = GearAnalyzer:GetEffectiveEnchantID(dynamicGems.blue, "gem") or dynamicGems.blue
    local recMeta = GearAnalyzer:GetEffectiveEnchantID(dynamicGems.meta, "meta") or dynamicGems.meta
    
    -- Heurística: ¿Merece la pena el bono?
    local worthFollow = self:ShouldFollowSocket(class, currentSpec, socketSlots, bonusStat, bonusVal)
    
    -- Comprobar estado global de Lágrima de pesadilla (Unique-Equipped)
    local hasNightmareTearHere = false
    local hasNightmareTearAnywhere = false
    if self.scannedEquipment then
        for _, equipData in ipairs(self.scannedEquipment) do
            if equipData.gems then
                for _, gid in ipairs(equipData.gems) do
                    if gid == 49110 or gid == 3511 then
                        hasNightmareTearAnywhere = true
                        if equipData.slotName == d.slotName then
                            hasNightmareTearHere = true
                        end
                    end
                end
            end
        end
    end

    local socketAnalysis = {}
    local allOk = true
    local wrongMsg = ""
    -- Leer gema por posición: usar allGemSlots pre-escaneado, si existe
    local gemBySlot = d.allGemSlots
    if not gemBySlot then
        gemBySlot = {}
        local itemID, enchantID, gem1, gem2, gem3, gem4 = string.match(d.itemLink, "item:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")
        if gem1 then
            gemBySlot = { tonumber(gem1), tonumber(gem2), tonumber(gem3), tonumber(gem4) }
        else
            -- Fallback regex más laxo
            local itemStr = string.match(d.itemLink, "item:([%d:%-]+)")
            if itemStr then
                local parts = { strsplit(":", itemStr) }
                for i = 3, 6 do table.insert(gemBySlot, tonumber(parts[i]) or 0) end
            end
        end
    end

    for i = 1, totalSockets do
        local curGID = gemBySlot[i] or 0

        local socketColor = socketSlots[i] or "extra"
        local targetGem = recRed
        local gemColor = curGID > 0 and self:GetGemColor(curGID) or "none"

        if socketColor == "meta" then
            targetGem = recMeta
        elseif socketColor == "blue" and worthFollow then
            -- Lógica de Gema Prismática (Lágrima de pesadilla 49110)
            -- Solo la sugerimos si el slot coincide con el preferido (ej. Pecho)
            if dynamicGems.prismatic and dynamicGems.prismaticSlot then
                local currentSlotKey = self:GetSlotKey(d.slotName, d.slotID)
                if currentSlotKey == dynamicGems.prismaticSlot then
                    targetGem = dynamicGems.prismatic
                else
                    -- Si no es el slot preferido, sugerimos la azul normal (o roja si es prioridad fuerza)
                    targetGem = recBlu
                end
            else
                targetGem = recBlu
            end
        elseif socketColor == "yellow" and worthFollow then
            targetGem = recYel
        else
            targetGem = recRed -- Stat puro por defecto (Rojo)
        end

        -- 1. IDENTIFICACIÓN DE DATOS
        local curData = self:GetEnchantData(curGID)
        local curName = curGID > 0 and (curData and curData.name or "ID:"..curGID) or "|cff777777(Vacío)|r"
        local curStats = curData and curData.stats and (" (" .. curData.stats .. ")") or ""

        -- 2. RECOMENDACIÓN
        local recData = self:GetEnchantData(targetGem)
        local recName = targetGem > 0 and (recData and recData.name or "ID:"..targetGem) or "N/A"
        local recStats = recData and recData.stats and (" (" .. recData.stats .. ")") or ""

        -- 3. COMPARACIÓN: validar por color de gema vs color de ranura
        local function satisfiesSocket(gemColor, socket)
            if not gemColor or not socket then return false end
            if gemColor == "prismatic" then return true end
            if gemColor == socket then return true end
            -- Híbridas
            if gemColor == "orange"  and (socket == "red" or socket == "yellow") then return true end
            if gemColor == "purple"  and (socket == "red" or socket == "blue")   then return true end
            if gemColor == "green"   and (socket == "yellow" or socket == "blue") then return true end
            return false
        end

        local isMatch = false
        if curGID > 0 then
            -- 1. Coincidencia exacta de ID siempre es válida
            if curGID == targetGem then
                isMatch = true
            else
                -- 2. Coincidencia por nombre (mismogema, diferente ID interno/item)
                local curData = self:GetEnchantData(curGID)
                local recData = self:GetEnchantData(targetGem)
                if curData and recData and curData.name == recData.name then
                    isMatch = true
                else
                    -- 3. Validación por lógica de colores
                    local curColor = self:GetGemColorByID(curGID)
                    if curColor == "prismatic" then
                        -- Prismática vale para cualquier color (no meta)
                        isMatch = socketColor ~= "meta"
                    elseif socketColor == "meta" then
                        -- Ranura meta solo acepta gemas meta
                        isMatch = (curColor == "meta")
                    elseif worthFollow then
                        -- Bono vale: la gema DEBE satisfacer el color de la ranura
                        isMatch = satisfiesSocket(curColor, socketColor)
                    else
                        -- Bono no vale: aceptamos todo lo que aporte "rojo" (stat principal)
                        isMatch = satisfiesSocket(curColor, "red")
                    end
                end
            end
        end

        -- Lágrima de pesadilla (prisma único): siempre ok en ranuras no-meta
        if (curGID == 49110 or curGID == 3511) and socketColor ~= "meta" then
            isMatch = true
        end

        table.insert(socketAnalysis, {
            color           = socketColor,
            currentName     = curName,
            currentStats    = curStats,
            currentGID      = curGID,
            recommendedName = recName,
            recommendedStats= recStats,
            recommendedID   = targetGem,
            isMatch         = isMatch,
            isEmpty         = (curGID == 0)
        })

        if not isMatch then
            allOk = false
            wrongMsg = wrongMsg .. "- Hueco " .. socketColor .. ": " .. curName .. " -> Sugerido: " .. recName .. "\n"
        end
    end

    -- Aviso de Meta Desactivada en el Casco
    if slotKey == "head" and not metaActive then
        wrongMsg = wrongMsg .. "- |cffff0000Meta INACTIVA|r (" .. (metaError or "Faltan requisitos") .. ")\n"
        allOk = false
    end

    d.socketAnalysis = socketAnalysis
    if allOk then
        d.gemStatus = 2
        d.gemTooltip = "|cff00ff00Gemas y Ranuras OK|r"
    else
        d.gemStatus = 1
        d.gemTooltip = "|cffffff00Sugerencias por ranura:|r\n" .. (wrongMsg ~= "" and wrongMsg or "|cff00ff00Todo correcto|r")
    end

end
