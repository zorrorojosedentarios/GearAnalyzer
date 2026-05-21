-- ============================================================
-- GearAnalyzer: Módulo de Estado y Diccionario Central
-- Responsabilidad: Identidad, Idioma y Puente entre Módulos
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local State = GearAnalyzer:NewModule("State")

-- 1. DICCIONARIO MAESTRO (VERIFICADO CONTRA BISTOOLTIP DB)
local DICTIONARY = {
    ["DEATHKNIGHT"] = {
        dbKey = "Death knight",
        specs = {
            ["Escarcha"] = "Frost", ["Frost"] = "Frost", ["Frost DPS"] = "Frost",
            ["Profano"] = "Unholy", ["Unholy"] = "Unholy", ["Unholy DPS"] = "Unholy",
            ["Sangre"] = "Blood tank", ["Blood Tank"] = "Blood tank", ["Blood tank"] = "Blood tank",
            ["Blood DPS"] = "Blood dps", ["Blood dps"] = "Blood dps",
        }
    },
    ["DRUID"] = {
        dbKey = "Druid",
        specs = {
            ["Equilibrio"] = "Balance", ["Balance"] = "Balance",
            ["Feral"] = "Feral dps", ["Feral dps"] = "Feral dps", ["Gato"] = "Feral dps", ["Feral Cat"] = "Feral dps",
            ["Guardián"] = "Feral tank", ["Feral tank"] = "Feral tank", ["Oso"] = "Feral tank", ["Feral Bear"] = "Feral tank",
            ["Restauración"] = "Restoration", ["Restoration"] = "Restoration",
        }
    },
    ["HUNTER"] = {
        dbKey = "Hunter",
        specs = {
            ["Bestias"] = "Beast mastery", ["Beast mastery"] = "Beast mastery",
            ["Puntería"] = "Marksmanship", ["Marksmanship"] = "Marksmanship",
            ["Supervivencia"] = "Survival", ["Survival"] = "Survival",
        }
    },
    ["WARLOCK"] = {
        dbKey = "Warlock",
        specs = {
            ["Aflicción"] = "Affliction", ["Affliction"] = "Affliction",
            ["Demonología"] = "Demonology", ["Demonology"] = "Demonology",
            ["Destrucción"] = "Destruction", ["Destruction"] = "Destruction",
            ["Destrucción Fuego"] = "Destruction fire", ["Destruction fire"] = "Destruction fire",
        }
    },
    ["PALADIN"] = {
        dbKey = "Paladin",
        specs = {
            ["Sagrado"] = "Holy", ["Holy"] = "Holy",
            ["Protección"] = "Protection", ["Protection"] = "Protection",
            ["Reprensión"] = "Retribution", ["Retribution"] = "Retribution",
        }
    },
    ["WARRIOR"] = {
        dbKey = "Warrior",
        specs = {
            ["Armas"] = "Arms", ["Arms"] = "Arms",
            ["Furia"] = "Fury", ["Fury"] = "Fury",
            ["Protección"] = "Protection", ["Protection"] = "Protection",
        }
    },
    ["SHAMAN"] = {
        dbKey = "Shaman",
        specs = {
            ["Elemental"] = "Elemental", ["Elemental"] = "Elemental",
            ["Mejora"] = "Enhancement", ["Enhancement"] = "Enhancement",
            ["Restauración"] = "Restoration", ["Restoration"] = "Restoration",
        }
    },
    ["PRIEST"] = {
        dbKey = "Priest",
        specs = {
            ["Disciplina"] = "Discipline", ["Discipline"] = "Discipline",
            ["Sagrado"] = "Holy", ["Holy"] = "Holy",
            ["Sombra"] = "Shadow", ["Shadow"] = "Shadow",
        }
    },
    ["ROGUE"] = {
        dbKey = "Rogue",
        specs = {
            ["Asesinato"] = "Assassination", ["Assassination"] = "Assassination",
            ["Combate"] = "Combat", ["Combat"] = "Combat",
            ["Sutileza"] = "Subtlety", ["Subtlety"] = "Subtlety",
        }
    },
    ["MAGE"] = {
        dbKey = "Mage",
        specs = {
            ["Arcano"] = "Arcane", ["Arcane"] = "Arcane",
            ["Fuego"] = "Fire", ["Fire"] = "Fire",
            ["Escarcha"] = "Frost", ["Frost"] = "Frost",
            ["Fire FFB"] = "Fire FFB", ["Fuego FFB"] = "Fire FFB",
        }
    }
}

-- 2. VARIABLES DE ESTADO
local playerClassToken = nil
local playerSpecKey = nil
local targetBiSItems = {}

-- 3. MOTOR DE IDENTIDAD
function State:Refresh()
    local _, classToken = UnitClass("player")
    playerClassToken = classToken
    
    -- Usamos la función nativa de GearAnalyzer para obtener la rama actual
    local specName = GearAnalyzer:GetCurrentSpec() or "None"
    
    if DICTIONARY[classToken] then
        playerSpecKey = DICTIONARY[classToken].specs[specName] or specName
    else
        playerSpecKey = specName
    end
end

-- 4. ACCESORES Y PUENTE
function State:SetTargetItem(slotKey, itemID)
    targetBiSItems[slotKey] = itemID
end

function State:GetTargetItem(slotKey)
    local db = GearAnalyzer.db and GearAnalyzer.db.profile
    if db then
        local custom = db.custom_bis and db.custom_bis[slotKey] and db.custom_bis[slotKey].itemID
        if custom then return custom end
        
        local bis = db.bis and db.bis[slotKey] and db.bis[slotKey].itemID
        if bis then return bis end
        
        local top6 = db.top6 and db.top6[slotKey]
        if top6 then
            if (slotKey == "ring2" or slotKey == "trinket2") and top6[2] then
                return top6[2]
            elseif top6[1] then
                return top6[1]
            end
        end
    end
    return targetBiSItems[slotKey]
end

function State:GetPlayerState()
    self:Refresh()
    local dbClass = DICTIONARY[playerClassToken] and DICTIONARY[playerClassToken].dbKey or playerClassToken
    return playerClassToken, playerSpecKey, dbClass
end

function State:OnInitialize()
    self:Refresh()
end
