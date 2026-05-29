-- ============================================================================
-- Gear Analyzer - Motor de Cálculo de Índice de Golpe (WotLK 3.3.5a)
-- ============================================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

local GA_HitCalc = CreateFrame("Frame", "GAHitCalcFrame", UIParent)

-- Cache estático del jugador (nunca cambia en sesión)
local playerClassFilename = select(2, UnitClass("player"))
local playerFaction = UnitFactionGroup("player")
local playerRaceFilename = select(2, UnitRace("player"))

-- Cache para IsDualWielding (refrescado en PLAYER_EQUIPMENT_CHANGED)
local cachedIsDualWielding = false
local dualWieldDirty = true

-- Caché de talentos (refrescado bajo demanda cuando un evento lo marca dirty)
local tab1Points, tab2Points, tab3Points = 0, 0, 0
local tabsDirty = true

-- Caché de presencia Draenei (refrescado al cambiar grupo)
local cachedDraenei = false
local draeneiDirty = true

-- Debounce con ScheduleTimer (evita OnUpdate por frame)
local debounceTimer = nil

GA_HitCalc:RegisterEvent("PLAYER_ENTERING_WORLD")
GA_HitCalc:RegisterEvent("CHARACTER_POINTS_CHANGED")
GA_HitCalc:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
GA_HitCalc:RegisterEvent("PLAYER_TALENT_UPDATE")
GA_HitCalc:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
GA_HitCalc:RegisterEvent("PARTY_MEMBERS_CHANGED")
GA_HitCalc:RegisterEvent("RAID_ROSTER_UPDATE")

GA_HitCalc:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self.initialized = true
        return
    end
    if not self.initialized then return end

    -- Debounce: coalescer eventos rápidos en un solo recálculo diferido
    if debounceTimer then
        GearAnalyzer:CancelTimer(debounceTimer)
    end

    if event == "PLAYER_EQUIPMENT_CHANGED" then
        tabsDirty = true
        dualWieldDirty = true
    elseif event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" then
        draeneiDirty = true
    else
        tabsDirty = true
    end

    debounceTimer = GearAnalyzer:ScheduleTimer(function()
        self.cachedResult = nil
        debounceTimer = nil
    end, 0.5)
end)

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

-- Detectar si el jugador usa dos armas (Dual Wield) con caché
local function IsDualWielding()
    if dualWieldDirty then
        local offHandLink = GetInventoryItemLink("player", 17)
        if offHandLink then
            local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(offHandLink)
            cachedIsDualWielding = (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND")
        else
            cachedIsDualWielding = false
        end
        dualWieldDirty = false
    end
    return cachedIsDualWielding
end

-- ============================================================================
-- FUNCIÓN PRINCIPAL DE CÁLCULO (retorna tabla)
-- ============================================================================
function GA_HitCalc:AnalyzePlayerHit()
    if self.cachedResult then return self.cachedResult end

    -- Refrescar caché de puntos de talento si está sucio
    if tabsDirty then
        local activeGroup = GetActiveTalentGroup()
        _, _, tab1Points = GetTalentTabInfo(1, false, false, activeGroup)
        _, _, tab2Points = GetTalentTabInfo(2, false, false, activeGroup)
        _, _, tab3Points = GetTalentTabInfo(3, false, false, activeGroup)
        tabsDirty = false
    end

    -- Refrescar caché de Draenei si cambió el grupo
    if draeneiDirty then
        cachedDraenei = false
        if playerFaction == "Alliance" then
            if playerRaceFilename == "Draenei" then
                cachedDraenei = true
            else
                local numRaid = GetNumRaidMembers() or 0
                if numRaid > 0 then
                    for i = 1, numRaid do
                        if UnitExists("raid" .. i) and select(2, UnitRace("raid" .. i)) == "Draenei" then
                            cachedDraenei = true
                            break
                        end
                    end
                else
                    local numParty = GetNumPartyMembers() or 0
                    if numParty > 0 then
                        for i = 1, numParty do
                            if UnitExists("party" .. i) and select(2, UnitRace("party" .. i)) == "Draenei" then
                                cachedDraenei = true
                                break
                            end
                        end
                    end
                end
            end
        end
        draeneiDirty = false
    end

    local combatType = COMBAT_RATINGS.MELEE
    if playerClassFilename == "HUNTER" then combatType = COMBAT_RATINGS.RANGED end
    if playerClassFilename == "MAGE" or playerClassFilename == "WARLOCK" or playerClassFilename == "PRIEST" then combatType = COMBAT_RATINGS.SPELL end

    local highestTab = 1
    local maxPoints = tab1Points
    if tab2Points > maxPoints then highestTab = 2; maxPoints = tab2Points end
    if tab3Points > maxPoints then highestTab = 3; maxPoints = tab3Points end

    if playerClassFilename == "DRUID" and highestTab == 1 then combatType = COMBAT_RATINGS.SPELL end
    if playerClassFilename == "SHAMAN" and highestTab == 1 then combatType = COMBAT_RATINGS.SPELL end
    if playerClassFilename == "PALADIN" and highestTab == 1 then combatType = COMBAT_RATINGS.SPELL end

    local isDualWielding = IsDualWielding()
    if combatType.id == 6 and isDualWielding then
        combatType = COMBAT_RATINGS.DUAL
    end

    local hitFromTalents = 0
    if TalentDB[playerClassFilename] then
        local activeGroup = GetActiveTalentGroup()
        for _, talentData in ipairs(TalentDB[playerClassFilename]) do
            local isCurrentCombatMagical = (combatType.id == 8)
            if talentData.isSpell == isCurrentCombatMagical or (not talentData.isSpell and not isCurrentCombatMagical) then
                local _, _, _, _, rank = GetTalentInfo(talentData.tab, talentData.index, false, false, activeGroup)
                if rank and rank > 0 then
                    hitFromTalents = hitFromTalents + (rank * talentData.bonus)
                end
            end
        end
    end

    if cachedDraenei then
        hitFromTalents = hitFromTalents + 1
    end

    local capNecesarioPorcentaje = combatType.baseCap - hitFromTalents
    if capNecesarioPorcentaje < 0 then capNecesarioPorcentaje = 0 end

    local capNecesarioRating = math.ceil(capNecesarioPorcentaje * combatType.ratingPerPercent)
    local currentRating = GetCombatRating(combatType.id)
    local currentPercent = GetCombatRatingBonus(combatType.id) + hitFromTalents

    local faltanteRating = capNecesarioRating - currentRating

    local meleeHitPercent = 0
    local spellHitPercent = 0
    if combatType.id == 8 then
        spellHitPercent = currentPercent
    else
        meleeHitPercent = currentPercent
        if playerClassFilename == "MAGE" or playerClassFilename == "WARLOCK" or playerClassFilename == "PRIEST" then
            spellHitPercent = GetCombatRatingBonus(8) + (hitFromTalents > 0 and hitFromTalents or 0)
        end
    end

    local result = {
        meleeHitPercent = meleeHitPercent,
        spellHitPercent = spellHitPercent,
        hitRating = currentRating,
        neededHitRating = faltanteRating,
        talentHitPercent = hitFromTalents,
        dualWield = isDualWielding,
        hasDraenei = cachedDraenei,
        combatType = combatType,
        caps = {
            base = combatType.baseCap,
            neededPercent = capNecesarioPorcentaje,
            neededRating = capNecesarioRating,
        }
    }

    self.cachedResult = result
    return result
end

-- ============================================================================
-- SALIDA A CHAT (usa la función de cálculo compartida)
-- ============================================================================
function GA_HitCalc:PrintHitAnalysis()
    local data = self:AnalyzePlayerHit()
    if not data then return end

    local colorStatus = data.neededHitRating <= 0 and "|cff00ff00" or "|cffff0000"

    DEFAULT_CHAT_FRAME:AddMessage(" ")
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ffff[Gear Analyzer] Análisis de Índice de Golpe|r")
    DEFAULT_CHAT_FRAME:AddMessage("Modo detectado: " .. (data.combatType.id == 8 and "Magia" or (data.combatType == COMBAT_RATINGS.DUAL and "Dual Wield Físico" or "Físico Estándar")))
    DEFAULT_CHAT_FRAME:AddMessage("Objetivo Base (Boss Lvl 83): " .. data.combatType.baseCap .. "%")
    DEFAULT_CHAT_FRAME:AddMessage("Aporte por Talentos: " .. data.talentHitPercent - (data.hasDraenei and 1 or 0) .. "%")
    if data.hasDraenei then
        DEFAULT_CHAT_FRAME:AddMessage("Aura Draenei (Presencia Heroica): +1%")
    end
    DEFAULT_CHAT_FRAME:AddMessage("Porcentaje a buscar en equipo: " .. data.caps.neededPercent .. "% (" .. data.caps.neededRating .. " de Índice)")
    DEFAULT_CHAT_FRAME:AddMessage("Tu Índice Actual: " .. data.hitRating .. " (" .. string.format("%.2f", data.meleeHitPercent > 0 and data.meleeHitPercent or data.spellHitPercent) .. "%)")

    if data.neededHitRating <= 0 then
        DEFAULT_CHAT_FRAME:AddMessage(colorStatus .. "ESTADO: ¡Estás capeado! (Te sobran " .. math.abs(data.neededHitRating) .. " puntos)|r")
    else
        DEFAULT_CHAT_FRAME:AddMessage(colorStatus .. "ESTADO: Te faltan " .. data.neededHitRating .. " puntos para capear.|r")
    end
end

-- API pública para otros módulos (ej. Caps tab)
function GearAnalyzer:GetHitAnalysis()
    return GA_HitCalc:AnalyzePlayerHit()
end

-- Comando para testear en el juego
SLASH_GEARANALYZER_HIT1 = "/gahit"
SlashCmdList["GEARANALYZER_HIT"] = function()
    GA_HitCalc:PrintHitAnalysis()
end
