-- ============================================================
-- GearAnalyzer Integration (BiSTooltip)
-- Bridges GearAnalyzer with BiSTooltip data dynamically
-- ============================================================

GearAnalyzer_Integration = {}

local PHASE_MAP = {
    ["PR"]  = "Pre-Raid / Heroicas",
    ["T9"]  = "Fase 3: TotC",
    ["T10"] = "Fase 5: ICC",
    ["RS"]  = "Sagrario Rubí"
}

local SLOT_MAP = {
    [1] = "head",
    [2] = "neck",
    [3] = "shoulders",
    [4] = "back",
    [5] = "chest",
    [6] = "wrists",
    [7] = "hands",
    [8] = "waist",
    [9] = "legs",
    [10] = "feet",
    [11] = "ring",    -- Special handling
    [12] = "trinket", -- Special handling
    [13] = "weapon",
    [14] = "offhand",
    [15] = (select(2, UnitClass("player")) == "HUNTER") and "ranged" or "idol"
}

function GearAnalyzer:GetBiSTooltipSpec(ignoreForced)
    return self:GetCurrentSpecEnhanced(ignoreForced)
end

local function cleanZoneName(zone)
    if not zone then return "Desconocido" end
    local clean = zone
    clean = clean:gsub("Icecrown Citadel", "ICC")
    clean = clean:gsub("The Ruby Sanctum", "RS")
    clean = clean:gsub("Trial of the Crusader", "TotC")
    clean = clean:gsub("Onyxia's Lair", "Onyxia")
    clean = clean:gsub("Ulduar", "Ulduar")
    clean = clean:gsub("Naxxramas", "Naxx")
    clean = clean:gsub("The Eye of Eternity", "EoE")
    clean = clean:gsub("The Obsidian Sanctum", "OS")
    clean = clean:gsub("Vault of Archavon", "VoA")
    return clean
end

function GearAnalyzer:SyncWithBiSTooltip(phase, targetDB, ignoreForced)
    if ignoreForced == nil then ignoreForced = true end -- Por defecto, usar contexto del jugador
    local db = targetDB or self.db.profile
    if not db then return false end

    local phaseName = phase or "T10"

    -- MODO INTERNO (Manual - usa ClassData)
    if phaseName == "MANUAL" then
        local classTag = self:GetClassToken(ignoreForced)
        local internalSpec = self:GetCurrentSpecEnhanced(ignoreForced)
        local classData = self.ClassData[classTag]
        local manualData = classData and classData.BiS and classData.BiS[internalSpec]

        if manualData then
            db.bis = {}
            db.top6 = {}
            db.alternatives = {}
            db.phase = "MANUAL"
            db.gamePhase = "MANUAL"
            db.spec = internalSpec

            for slot, itemID in pairs(manualData) do
                local id = itemID
                if type(itemID) == "table" then id = itemID.itemID or itemID[1] end
                db.bis[slot] = { itemID = id }
                db.top6[slot] = { id }
            end
            return true
        end
    end

    -- === MODO GA_BiSLists ===
    if not GA_BiSLists then return false end

    local bisSpec = self:GetBiSTooltipSpec(ignoreForced)
    if not bisSpec then return false end

    -- Obtener nombre de clase en formato de GA_BiSLists (Estandarizado a MAYÚSCULAS)
    local classTag = self:GetClassToken(ignoreForced)
    local className = classTag -- "WARLOCK", "PRIEST", etc.

    -- Validar existencia de datos
    if not GA_BiSLists[className] or not bisSpec or not GA_BiSLists[className][bisSpec] then
        return false
    end

    local phaseData = GA_BiSLists[className][bisSpec][phaseName]
    if not phaseData or #phaseData == 0 then 
        if phaseName ~= "T10" then
            phaseData = GA_BiSLists[className][bisSpec]["T10"]
        end
        if not phaseData then return false end
    end

    -- Inicializar estructura de DB
    db.bis = db.bis or {}
    db.top6 = db.top6 or {}
    db.alternatives = db.alternatives or {}
    db.sources = db.sources or {}
    
    if phaseName ~= "MANUAL" then
        wipe(db.bis)
        wipe(db.top6)
    end
    wipe(db.alternatives)
    -- wipe(db.sources) -- Evitar wipe de sources para no perder cache
    
    db.phase = phaseName
    db.gamePhase = phaseName
    db.spec = bisSpec

    local is17Slots = (#phaseData >= 17)

    for i, data in ipairs(phaseData) do
        local slotKey = nil
        if is17Slots then
            local map17 = {
                [1]="head",[2]="neck",[3]="shoulders",[4]="back",[5]="chest",
                [6]="wrists",[7]="hands",[8]="waist",[9]="legs",[10]="feet",
                [11]="ring1",[12]="ring2",[13]="trinket1",[14]="trinket2",
                [15]="weapon",[16]="offhand",[17]=(classTag == "HUNTER") and "ranged" or "idol"
            }
            slotKey = map17[i]
        else
            slotKey = SLOT_MAP[i]
        end

        if slotKey and type(data) == "table" then
            db.top6[slotKey] = {}
            for j = 1, 6 do
                local id = data[j]
                if id and type(id) == "number" and id > 0 then
                    table.insert(db.top6[slotKey], id)
                end
            end

            if not is17Slots and slotKey == "ring" then
                db.bis["ring1"]  = { itemID = data[1] }
                db.bis["ring2"]  = { itemID = data[2] or data[1] }
                db.top6["ring1"] = db.top6[slotKey]
                db.top6["ring2"] = db.top6[slotKey]
            elseif not is17Slots and slotKey == "trinket" then
                db.bis["trinket1"] = { itemID = data[1] }
                db.bis["trinket2"] = { itemID = data[2] or data[1] }
                db.top6["trinket1"] = db.top6[slotKey]
                db.top6["trinket2"] = db.top6[slotKey]
            else
                if data[1] and data[1] > 0 then
                    db.bis[slotKey] = { itemID = data[1] }
                end
                db.alternatives[slotKey] = {}
                for j = 2, 6 do
                    if data[j] and data[j] > 0 then
                        table.insert(db.alternatives[slotKey], data[j])
                    end
                end
            end
        end
    end
    return true
end

