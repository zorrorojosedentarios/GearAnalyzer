-- ============================================================================
-- Gear Analyzer - Motor de Cálculo de Índice de Golpe (WotLK 3.3.5a)
-- ============================================================================

local GA_HitCalc = CreateFrame("Frame")

-- Constantes Matemáticas del Nivel 80
local COMBAT_RATINGS = {
    MELEE = { baseCap = 8,  ratingPerPercent = 32.79,  id = 6 }, -- CR_HIT_MELEE
    RANGED= { baseCap = 8,  ratingPerPercent = 32.79,  id = 7 }, -- CR_HIT_RANGED
    SPELL = { baseCap = 17, ratingPerPercent = 26.232, id = 8 }, -- CR_HIT_SPELL
    DUAL  = { baseCap = 27, ratingPerPercent = 32.79,  id = 6 }  -- Dual Wield base
}

-- ============================================================================
-- BASE DE DATOS DE TALENTOS (Mapeo)
-- Estructura: [Clase] = { tabTree = X, talentIndex = Y, bonusPerRank = Z, isSpell = true/false }
-- Nota: 'talentIndex' es la posición del talento de izquierda a derecha, de arriba a abajo.
-- ============================================================================
local TalentDB = {
    ["DRUID"] = {
        { name = "Equilibrio de Poder", tab = 1, index = 16, bonus = 2, isSpell = true }, -- Equilibrio de Poder: 2% hechizos por rango (Max 2 rangos = 4%)
    },
    ["PRIEST"] = {
        { name = "Enfoque de las Sombras", tab = 3, index = 3, bonus = 1, isSpell = true },  -- Enfoque de las Sombras: 1% hechizos por rango (Max 3 = 3%)
    },
    ["ROGUE"] = {
        { name = "Precisión", tab = 2, index = 4, bonus = 1, isSpell = false }, -- Precisión (Combate): 1% físico por rango (Max 5 = 5%)
    },
    ["MAGE"] = {
        { name = "Precisión", tab = 3, index = 3, bonus = 1, isSpell = true }, -- Precisión (Escarcha): 1% hechizos por rango (Max 3 = 3%)
        { name = "Enfoque Arcano", tab = 1, index = 2, bonus = 1, isSpell = true }, -- Enfoque Arcano: 1% hechizos (Arcano) por rango (Max 3 = 3%)
    },
    ["WARLOCK"] = {
        { name = "Supresión", tab = 1, index = 2, bonus = 1, isSpell = true }, -- Supresión (Aflicción): 1% hechizos por rango (Max 3 = 3%)
    },
    ["SHAMAN"] = {
        { name = "Precisión Elemental", tab = 1, index = 10, bonus = 1, isSpell = true }, -- Precisión Elemental: 1% hechizos por rango (Max 3 = 3%)
        { name = "Especialización en doble empuñadura", tab = 2, index = 16, bonus = 2, isSpell = false }, -- Especialización Doble Empuñadura: 2% golpe con dos armas por rango (Max 3 = 6%)
    },
    ["HUNTER"] = {
        { name = "Puntería centrada", tab = 2, index = 8, bonus = 1, isSpell = false }, -- Puntería Centrada: 1% golpe físico por rango (Max 3 = 3%)
    },
    ["WARRIOR"] = {
        { name = "Precisión", tab = 2, index = 11, bonus = 1, isSpell = false }, -- Precisión (Furia): 1% golpe físico por rango (Max 3 = 3%)
    },
    ["DEATHKNIGHT"] = {
        { name = "Nervios de acero frío", tab = 2, index = 7, bonus = 1, isSpell = false }, -- Nervios de Acero Frío: 1% golpe físico con dos armas por rango (Max 3 = 3%)
        { name = "Virulencia", tab = 3, index = 2, bonus = 1, isSpell = true }, -- Virulencia: 1% hechizos/enfermedades por rango (Max 3 = 3%)
    }
}

-- Detectar si el jugador usa dos armas (Dual Wield)
local function IsDualWielding()
    local offHandLink = GetInventoryItemLink("player", 17) -- Slot 17 es la mano izquierda
    if offHandLink then
        local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(offHandLink)
        if itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" then
            return true
        end
    end
    return false
end

-- ============================================================================
-- FUNCIÓN PRINCIPAL DE CÁLCULO
-- ============================================================================
function GA_HitCalc:AnalyzePlayerHit()
    local _, classFilename = UnitClass("player")
    
    -- Determinar el rol principal y el tipo de combate
    -- Por defecto asumimos Melee/Rango. Las clases de magia se sobreescriben.
    local combatType = COMBAT_RATINGS.MELEE
    if classFilename == "HUNTER" then combatType = COMBAT_RATINGS.RANGED end
    if classFilename == "MAGE" or classFilename == "WARLOCK" or classFilename == "PRIEST" then combatType = COMBAT_RATINGS.SPELL end
    
    -- Manejo de Híbridos (Druidas, Chamanes, Paladines) basado en su árbol de talentos con más puntos
    local _, _, tab1 = GetTalentTabInfo(1)
    local _, _, tab2 = GetTalentTabInfo(2)
    local _, _, tab3 = GetTalentTabInfo(3)
    local highestTab = 1
    local maxPoints = tab1
    if tab2 > maxPoints then highestTab = 2; maxPoints = tab2 end
    if tab3 > maxPoints then highestTab = 3; maxPoints = tab3 end

    -- Ajustes para Híbridos (Ej: Druida Equilibrio = Magia, Chaman Elemental = Magia)
    if classFilename == "DRUID" and highestTab == 1 then combatType = COMBAT_RATINGS.SPELL end
    if classFilename == "SHAMAN" and highestTab == 1 then combatType = COMBAT_RATINGS.SPELL end
    if classFilename == "PALADIN" and highestTab == 1 then combatType = COMBAT_RATINGS.SPELL end

    -- Ajuste si es Melee usando Dual Wield (Pícaros, Mejora, Furia, Escarcha)
    if combatType.id == 6 and IsDualWielding() then
        combatType = COMBAT_RATINGS.DUAL
    end

    -- Calcular bonificación de talentos
    local hitFromTalents = 0
    if TalentDB[classFilename] then
        for _, talentData in ipairs(TalentDB[classFilename]) do
            -- Solo contamos el talento si afecta al tipo de combate actual (físico vs mágico)
            local isCurrentCombatMagical = (combatType.id == 8)
            if talentData.isSpell == isCurrentCombatMagical or (not talentData.isSpell and not isCurrentCombatMagical) then
                local _, _, _, _, rank = GetTalentInfo(talentData.tab, talentData.index)
                if rank and rank > 0 then
                    hitFromTalents = hitFromTalents + (rank * talentData.bonus)
                end
            end
        end
    end

    -- Aura Draenei (Presencia Heroica = 1%) - Dinámica
    local hasDraenei = false
    local faction = UnitFactionGroup("player")
    if faction == "Alliance" then
        local _, race = UnitRace("player")
        if race == "Draenei" then
            hasDraenei = true
        else
            local numRaid = GetNumRaidMembers() or 0
            if numRaid > 0 then
                for i = 1, numRaid do
                    if UnitExists("raid" .. i) and select(2, UnitRace("raid" .. i)) == "Draenei" then
                        hasDraenei = true
                        break
                    end
                end
            else
                local numParty = GetNumPartyMembers() or 0
                if numParty > 0 then
                    for i = 1, numParty do
                        if UnitExists("party" .. i) and select(2, UnitRace("party" .. i)) == "Draenei" then
                            hasDraenei = true
                            break
                        end
                    end
                end
            end
        end
    end
    
    if hasDraenei then
        hitFromTalents = hitFromTalents + 1
    end

    -- Cálculo Final
    local capNecesarioPorcentaje = combatType.baseCap - hitFromTalents
    if capNecesarioPorcentaje < 0 then capNecesarioPorcentaje = 0 end -- Evitar números negativos

    local capNecesarioRating = math.ceil(capNecesarioPorcentaje * combatType.ratingPerPercent)
    local currentRating = GetCombatRating(combatType.id)
    local currentPercent = GetCombatRatingBonus(combatType.id) + hitFromTalents

    local faltanteRating = capNecesarioRating - currentRating

    -- Salida de resultados
    local colorStatus = faltanteRating <= 0 and "|cff00ff00" or "|cffff0000"
    
    DEFAULT_CHAT_FRAME:AddMessage(" ")
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ffff[Gear Analyzer] Análisis de Índice de Golpe|r")
    DEFAULT_CHAT_FRAME:AddMessage("Modo detectado: " .. (combatType.id == 8 and "Magia" or (combatType == COMBAT_RATINGS.DUAL and "Dual Wield Físico" or "Físico Estándar")))
    DEFAULT_CHAT_FRAME:AddMessage("Objetivo Base (Boss Lvl 83): " .. combatType.baseCap .. "%")
    DEFAULT_CHAT_FRAME:AddMessage("Aporte por Talentos: " .. hitFromTalents - (hasDraenei and 1 or 0) .. "%")
    if hasDraenei then
        DEFAULT_CHAT_FRAME:AddMessage("Aura Draenei (Presencia Heroica): +1%")
    end
    DEFAULT_CHAT_FRAME:AddMessage("Porcentaje a buscar en equipo: " .. capNecesarioPorcentaje .. "% (" .. capNecesarioRating .. " de Índice)")
    DEFAULT_CHAT_FRAME:AddMessage("Tu Índice Actual: " .. currentRating .. " (" .. string.format("%.2f", currentPercent) .. "%)")
    
    if faltanteRating <= 0 then
        DEFAULT_CHAT_FRAME:AddMessage(colorStatus .. "ESTADO: ¡Estás capeado! (Te sobran " .. math.abs(faltanteRating) .. " puntos)|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage(colorStatus .. "ESTADO: Te faltan " .. faltanteRating .. " puntos para capear.|r")
    end
end

-- Comando para testear en el juego
SLASH_GEARANALYZER_HIT1 = "/gahit"
SlashCmdList["GEARANALYZER_HIT"] = function()
    GA_HitCalc:AnalyzePlayerHit()
end
