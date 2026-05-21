-- ============================================================
-- GearAnalyzer_Locale.lua
-- Resuelve todos los strings dependientes del idioma del servidor
-- usando las APIs de WoW en tiempo de carga.
-- Compatible con cualquier locale (esMX, enUS, deDE, frFR, etc.)
-- ============================================================

local GA = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

-- ============================================================
-- UTILITY: obtener nombre de hechizo por ID (locale-safe)
-- ============================================================
local function SpellName(id)
    return (GetSpellInfo(id)) or ""
end

-- ============================================================
-- 1. DETECCIÓN DE STATS EN TOOLTIPS
--    WoW expone globales de tipo ITEM_MOD_*_SHORT ya localizados.
--    Construimos un mapa { patron_lower -> campo } para usar en GetItemData.
-- ============================================================
GearAnalyzer.LocaleStatPatterns = {}

local function AddStatPattern(field, ...)
    for _, str in ipairs({...}) do
        if str and str ~= "" then
            local lower = str:lower():gsub("%+?%%s", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
            if lower ~= "" then
                GearAnalyzer.LocaleStatPatterns[lower] = field
            end
        end
    end
end

-- Construir usando los globals de WoW (disponibles en cualquier locale)
-- Spell Power
AddStatPattern("spellpower",
    ITEM_MOD_SPELL_POWER_SHORT or "",
    "Spell Power", "Poder de Hechizos", "Puissance des sorts")

-- Haste
AddStatPattern("haste",
    ITEM_MOD_HASTE_RATING_SHORT or "",
    "Haste", "Celeridad", "Célérité")

-- Spirit
AddStatPattern("spirit",
    ITEM_MOD_SPIRIT_SHORT or "",
    "Spirit", "Espíritu", "Esprit")

-- Strength
AddStatPattern("strength",
    ITEM_MOD_STRENGTH_SHORT or "",
    "Strength", "Fuerza", "Force")

-- Agility
AddStatPattern("agility",
    ITEM_MOD_AGILITY_SHORT or "",
    "Agility", "Agilidad", "Agilité")

-- Stamina
AddStatPattern("stamina",
    ITEM_MOD_STAMINA_SHORT or "",
    "Stamina", "Aguante", "Endurance")

-- Intellect
AddStatPattern("intellect",
    ITEM_MOD_INTELLECT_SHORT or "",
    "Intellect", "Intelecto", "Intelligence")

-- Crit
AddStatPattern("crit",
    ITEM_MOD_CRIT_RATING_SHORT or "",
    "Crit", "Crítico", "Coup critique")

-- Hit
AddStatPattern("hit",
    ITEM_MOD_HIT_RATING_SHORT or "",
    "Hit", "Golpe", "Touché")

-- Expertise
AddStatPattern("expertise",
    ITEM_MOD_EXPERTISE_RATING_SHORT or "",
    "Expertise", "Pericia", "Expertise")

-- Armor Penetration
AddStatPattern("arp",
    ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT or "",
    "Armor Penetration", "ArPen", "Penetración de armadura", "Pénétration d'armure")

-- Attack Power
AddStatPattern("attackpower",
    ITEM_MOD_ATTACK_POWER_SHORT or "",
    "Attack Power", "Poder de ataque", "Puissance d'attaque")

-- Armor
AddStatPattern("armor",
    RESISTANCE0_NAME or "Armor",
    "Armor", "Armadura", "Armure")

-- ============================================================
-- 2. DETECCIÓN DE RANURAS DE GEMA (GetItemSocketColors)
--    WoW expone EMPTY_SOCKET_RED / YELLOW / BLUE / META
-- ============================================================
GearAnalyzer.LocaleSocketWords = {
    red    = {},
    yellow = {},
    blue   = {},
    meta   = {},
    socket = {}, -- palabras que indican que es una línea de ranura
}

local function AddSocketWord(color, ...)
    for _, w in ipairs({...}) do
        if w and w ~= "" then
            table.insert(GearAnalyzer.LocaleSocketWords[color], w:lower())
        end
    end
end

-- Palabras de color del hueco (locale + fallbacks)
AddSocketWord("red",    EMPTY_SOCKET_RED    or "", "roja",    "red",    "rouge")
AddSocketWord("yellow", EMPTY_SOCKET_YELLOW or "", "amarilla","yellow", "jaune")
AddSocketWord("blue",   EMPTY_SOCKET_BLUE   or "", "azul",    "blue",   "bleu")
AddSocketWord("meta",   EMPTY_SOCKET_META   or "", "meta")
-- Palabras que indican que la línea ES una ranura
AddSocketWord("socket", "ranura", "socket", "emplacements")

-- Helper: comprobar si un string contiene alguna palabra de la lista
function GearAnalyzer:TextContainsLocaleWord(text, color)
    local words = self.LocaleSocketWords[color]
    if not words then return false end
    for _, w in ipairs(words) do
        if w ~= "" and text:find(w, 1, true) then return true end
    end
    return false
end

-- ============================================================
-- 3. DETECCIÓN DE BUFF DE TANQUE (IsTank)
--    Resuelve nombres de buff/forma en el locale activo
-- ============================================================
GearAnalyzer.LocaleTankSpells = {
    -- Paladin: Righteous Fury
    PALADIN  = SpellName(25780),
    -- Warrior: no buff específico, usa ratings
    -- DK: no buff específico, usa ratings
    -- Druid: Bear Form (ID de HABILIDAD de forma)
    DRUID_BEAR_FORM = SpellName(5487),  -- Bear Form
    DRUID_CAT_FORM  = SpellName(768),   -- Cat Form
}

-- ============================================================
-- 4. DETECCIÓN DE STATS DE TANQUE EN TOOLTIPS
--    Usamos los globals de WoW para Esquiva/Parada/Bloqueo/Defensa
-- ============================================================
GearAnalyzer.LocaleTankStatWords = {}

local function AddTankWord(...)
    for _, str in ipairs({...}) do
        if str and str ~= "" then
            local lower = str:lower():gsub("%+?%%s", ""):match("^%s*(.-)%s*$")
            if lower ~= "" then
                table.insert(GearAnalyzer.LocaleTankStatWords, lower)
            end
        end
    end
end

AddTankWord(
    ITEM_MOD_DODGE_RATING_SHORT      or "",  -- "Esquiva" / "Dodge"
    ITEM_MOD_PARRY_RATING_SHORT      or "",  -- "Parada" / "Parry"
    ITEM_MOD_BLOCK_RATING_SHORT      or "",  -- "Bloqueo" / "Block"
    ITEM_MOD_DEFENSE_SKILL_RATING_SHORT or "", -- "Defensa" / "Defense"
    -- Fallbacks
    "dodge", "parry", "block", "defense",
    "esquiva", "parada", "bloqueo", "defensa",
    "esquiver", "parade", "blocage"
)

-- Helper
function GearAnalyzer:TextHasTankStat(ltext)
    for _, w in ipairs(self.LocaleTankStatWords) do
        if w ~= "" and ltext:find(w, 1, true) then return true end
    end
    return false
end

-- ============================================================
-- 5. DETECCIÓN DE STATS MELEE EN TOOLTIPS
-- ============================================================
GearAnalyzer.LocaleMeleeStatWords = {}

local function AddMeleeWord(...)
    for _, str in ipairs({...}) do
        if str and str ~= "" then
            local lower = str:lower():gsub("%+?%%s", ""):match("^%s*(.-)%s*$")
            if lower ~= "" then
                table.insert(GearAnalyzer.LocaleMeleeStatWords, lower)
            end
        end
    end
end

AddMeleeWord(
    ITEM_MOD_AGILITY_SHORT           or "",
    ITEM_MOD_STRENGTH_SHORT          or "",
    ITEM_MOD_ATTACK_POWER_SHORT      or "",
    -- Fallbacks
    "agility", "strength", "attack power",
    "agilidad", "fuerza", "poder de ataque",
    "agilité", "force", "puissance d'attaque"
)

function GearAnalyzer:TextHasMeleeStat(ltext)
    for _, w in ipairs(self.LocaleMeleeStatWords) do
        if w ~= "" and ltext:find(w, 1, true) then return true end
    end
    return false
end

-- ============================================================
-- 6. BONO DE RANURA (ITEM_SOCKET_BONUS)
--    Ya es un global de WoW — solo exponemos un helper
-- ============================================================
function GearAnalyzer:GetSocketBonusPattern()
    if not self._socketBonusPattern then
        local tmpl = ITEM_SOCKET_BONUS or "Bono de ranura: %s"
        self._socketBonusPattern = tmpl:gsub("%%s", "(.+)")
    end
    return self._socketBonusPattern
end

-- ============================================================
-- 7. PROFESIONES: mapa locale usando GetSpellInfo
-- ============================================================
-- Spell IDs para el rango 1 de cada profesión (lang-independent)
local PROFESSION_SPELL_IDS = {
    ENGINEERING    = 4036,
    TAILORING      = 3908,
    LEATHERWORKING = 2108,
    INSCRIPTION    = 45357,
    ENCHANTING     = 7411,
    BLACKSMITHING  = 2018,
    JEWELCRAFTING  = 25229,
    ALCHEMY        = 2259,
    HERBALISM      = 2383,
    MINING         = 2575,
    SKINNING       = 8617,
}

-- Construir el mapa reverso: nombre_localizado → token
GearAnalyzer.LocaleProfessionMap = {}
for token, sid in pairs(PROFESSION_SPELL_IDS) do
    local name = GetSpellInfo(sid)
    if name then
        GearAnalyzer.LocaleProfessionMap[name] = token
    end
end
