-- ============================================================
-- GearAnalyzer: Guide, Specs & Localization
-- Intelligent spec detection, normalization and translations
-- ============================================================

GearAnalyzer.ClassSpecsMap = {
    ["DRUID"] = { "Balance", "Feral Cat", "Feral Bear", "Restoration" },
    ["DEATHKNIGHT"] = { "Blood DPS", "Blood Tank", "Frost", "Unholy" },
    ["PALADIN"] = { "Holy", "Protection", "Retribution" },
    ["WARRIOR"] = { "Arms", "Fury", "Protection" },
    ["MAGE"] = { "Arcane", "Fire", "Fire FFB", "Frost" },
    ["PRIEST"] = { "Discipline", "Holy", "Shadow" },
    ["SHAMAN"] = { "Elemental", "Enhancement", "Restoration" },
    ["WARLOCK"] = { "Affliction", "Demonology", "Destruction" },
    ["HUNTER"] = { "Beast Mastery", "Marksmanship", "Survival" },
    ["ROGUE"] = { "Assassination", "Combat" },
}

GearAnalyzer.TalentTreeNames = {
    ["WARRIOR"]     = { "Arms", "Fury", "Protection" },
    ["PALADIN"]     = { "Holy", "Protection", "Retribution" },
    ["HUNTER"]      = { "Beast Mastery", "Marksmanship", "Survival" },
    ["ROGUE"]       = { "Assassination", "Combat" },
    ["PRIEST"]      = { "Discipline", "Holy", "Shadow" },
    ["DEATHKNIGHT"] = { "Blood", "Frost", "Unholy" },
    ["SHAMAN"]      = { "Elemental", "Enhancement", "Restoration" },
    ["MAGE"]        = { "Arcane", "Fire", "Frost" },
    ["WARLOCK"]     = { "Affliction", "Demonology", "Destruction" },
    ["DRUID"]       = { "Balance", "Feral", "Restoration" },
}

function GearAnalyzer:GetCurrentSpec(ignoreForced)
    local class = self:GetClassToken(ignoreForced)
    local activeGroup = GetActiveTalentGroup()
    
    local tab1 = select(3, GetTalentTabInfo(1, false, false, activeGroup)) or 0
    local tab2 = select(3, GetTalentTabInfo(2, false, false, activeGroup)) or 0
    local tab3 = select(3, GetTalentTabInfo(3, false, false, activeGroup)) or 0

    local isTank = self:IsTank(ignoreForced)

    if class == "DRUID" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Balance" end
        if tab3 > tab1 and tab3 > tab2 then return "Restoration" end
        
        -- Detección por talentos para Feral (Gato vs Oso)
        local isBear = false
        local _, _, _, _, rankSurv = GetTalentInfo(2, 15, false, false, activeGroup)
        local _, _, _, _, rankThick = GetTalentInfo(2, 10, false, false, activeGroup)
        
        if (rankSurv and rankSurv > 0) or (rankThick and rankThick > 0) then
            isBear = true
        end
        
        return isBear and "Feral Bear" or "Feral Cat"
        
    elseif class == "DEATHKNIGHT" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then 
            local isDKTank = false
            local _, _, _, _, rankVet = GetTalentInfo(1, 19, false, false, activeGroup)
            local _, _, _, _, rankVamp = GetTalentInfo(1, 23, false, false, activeGroup)
            
            if (rankVet and rankVet > 0) or (rankVamp and rankVamp > 0) then
                if rankVamp and rankVamp > 0 then
                    isDKTank = true
                else
                    isDKTank = (GetCombatRating(CR_DEFENSE_SKILL or 2) or 0) > 350
                end
            end
            
            return isDKTank and "Blood Tank" or "Blood DPS" 
        end
        if tab2 > tab1 and tab2 > tab3 then 
            return "Frost" 
        end
        return "Unholy"
    elseif class == "PALADIN" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Holy" end
        if tab2 > tab1 and tab2 > tab3 then return "Protection" end
        return "Retribution"
    elseif class == "WARRIOR" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Arms" end
        if tab2 > tab1 and tab2 > tab3 then return "Fury" end
        if tab3 > tab1 and tab3 > tab2 then return "Protection" end
        return isTank and "Protection" or "Fury"
    elseif class == "MAGE" then
        if tab1 > tab2 and tab1 > tab3 then return "Arcane" end
        if tab2 > tab1 and tab2 > tab3 then 
            if tab3 > 10 then return "Fire FFB" end
            return "Fire"
        end
        return "Frost"
    elseif class == "PRIEST" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Discipline" end
        if tab2 > tab1 and tab2 > tab3 then return "Holy" end
        if tab3 > tab1 and tab3 > tab2 then return "Shadow" end
        return "None"
    elseif class == "SHAMAN" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Elemental" end
        if tab2 > tab1 and tab2 > tab3 then return "Enhancement" end
        return "Restoration"
    elseif class == "WARLOCK" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Affliction" end
        if tab2 > tab1 and tab2 > tab3 then return "Demonology" end
        return "Destruction"
    elseif class == "ROGUE" then
        if tab1 == 0 and tab2 == 0 and tab3 == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Assassination" end
        if tab2 > tab1 and tab2 > tab3 then return "Combat" end
        return "Subtlety"
    elseif class == "HUNTER" then
        if (tab1 + tab2 + tab3) == 0 then return "None" end
        if tab1 > tab2 and tab1 > tab3 then return "Beast Mastery" end
        if tab2 > tab1 and tab2 > tab3 then return "Marksmanship" end
        return "Survival"
    end
    
    return "None"
end

function GearAnalyzer:GetClassSpecs(ignoreForced)
    local class = self:GetClassToken(ignoreForced)
    local specs = {}
    
    if self.ClassSpecsMap[class] then
        for _, s in ipairs(self.ClassSpecsMap[class]) do
            table.insert(specs, s)
        end
    end
    return specs
end

function GearAnalyzer:GetSpecLabel(spec)
    if not spec then return "Desconocida" end
    local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer", true)
    if L then
        local val = rawget(L, spec)
        if val then return val end
    end
    return spec
end

-- ============================================================
-- Shared helper: Class & Spec icons for any Guide tab page
-- Icons are placed centered at the top of the frame (32x32 each)
-- ============================================================
local guideIconFrames = {}  -- keyed by page frame reference

function GearAnalyzer:SetupGuideIcons(page, class, spec)
    if not page then return end
    local guideFrame = page:GetParent()
    if not guideFrame then return end

    -- Create icon textures once per guide frame (not per page)
    if not guideIconFrames[guideFrame] then
        local classIcon = guideFrame:CreateTexture(nil, "OVERLAY")
        classIcon:SetSize(32, 32)
        classIcon:SetPoint("TOP", guideFrame, "TOP", -19, -35)

        local specIcon = guideFrame:CreateTexture(nil, "OVERLAY")
        specIcon:SetSize(32, 32)
        specIcon:SetPoint("LEFT", classIcon, "RIGHT", 6, 0)

        guideIconFrames[guideFrame] = { classIcon = classIcon, specIcon = specIcon }
    end

    local icons = guideIconFrames[guideFrame]

    -- Class icon using WoW built-in coordinate map
    if class and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[class] then
        icons.classIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
        icons.classIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
        icons.classIcon:Show()
    else
        icons.classIcon:Hide()
    end

    -- Spec icon from GA_SpecIcons, mapping internal spec names to icon keys
    local specIconTex
    if spec and GA_SpecIcons then
        local properClassName = class:sub(1,1) .. class:sub(2):lower()
        if class == "DEATHKNIGHT" then properClassName = "Death knight" end
        local specIcons = GA_SpecIcons[properClassName]
        if specIcons then
            local searchSpec = string.lower(spec)
            if searchSpec == "feral cat" then searchSpec = "feral dps" end
            if searchSpec == "feral bear" then searchSpec = "feral tank" end
            if searchSpec == "blood tank" then searchSpec = "blood tank" end
            if searchSpec == "blood dps"  then searchSpec = "blood dps"  end
            for k, v in pairs(specIcons) do
                if string.lower(k) == searchSpec then
                    specIconTex = v; break
                end
            end
        end
    end

    if specIconTex then
        icons.specIcon:SetTexture(specIconTex)
        icons.specIcon:SetTexCoord(0, 1, 0, 1)
        icons.specIcon:Show()
    else
        icons.specIcon:Hide()
    end
end

function GearAnalyzer:LocalizeText(text)
    if not text then return "" end

    -- Pick the right locale table based on user language setting
    local langOverride = self.db and self.db.profile and self.db.profile.settings and self.db.profile.settings.language
    local useEnUS = (langOverride == "enUS") and GearAnalyzer_Locale_enUS

    -- 1. Direct exact-match lookup in the target locale table
    if useEnUS then
        local enMatch = rawget(GearAnalyzer_Locale_enUS, text)
        if enMatch and enMatch ~= text then return enMatch end
    else
        local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
        local directMatch = rawget(L, text)
        if directMatch and directMatch ~= text then return directMatch end

        -- On Spanish clients keeping Spanish, return original text (no translation needed)
        if GetLocale() == "esES" or GetLocale() == "esMX" then
            if text:find("^SLOT_") or text:find("^TAB_") or text:find("^GEM_") then
                local match = rawget(L, text)
                if match then return match end
            end
            return text
        end
    end

    -- 2. Word-by-word substitution using the correct locale table
    local L = useEnUS or LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")

    -- Invalidate cache if language changed
    if self._lastLangOverride ~= langOverride then
        self.StaticTranslations = nil
        self._lastLangOverride = langOverride
    end

    if not self.StaticTranslations then
        self.StaticTranslations = {
            ["FUERZA"] = (rawget(L, "Fuerza") or "Strength"):upper(),
            ["Fuerza"] = rawget(L, "Fuerza") or "Strength",
            ["Agilidad"] = rawget(L, "Agilidad") or "Agility",
            ["Aguante"] = rawget(L, "Aguante") or "Stamina",
            ["Intelecto"] = rawget(L, "Intelecto") or "Intellect",
            ["Espiritu"] = rawget(L, "Espiritu") or "Spirit",
            ["Poder con hechizos"] = rawget(L, "Poder con hechizos") or "Spell Power",
            ["Poder de ataque"] = rawget(L, "Poder de ataque") or "Attack Power",
            ["Celeridad"] = rawget(L, "Celeridad") or "Haste",
            ["Pericia"] = rawget(L, "Pericia") or "Expertise",
            ["Penetracion de armadura"] = rawget(L, "Penetracion de armadura") or "Armor Pen.",
            ["Indice de golpe"] = rawget(L, "Indice de golpe") or "Hit Rating",
            ["Golpe"] = rawget(L, "Indice de golpe") or "Hit Rating",
            -- Notes / DB strings
            ["pasivo"] = "passive",
            ["Cambiar gemas al alcanzar"] = "Swap gems at",
            ["ARPEN DESDE DÍA 1"] = "ARPEN FROM DAY 1",
            ["PROGRESIÓN"] = "PROGRESSION",
            ["Punto de Quiebre"] = "Breakpoint",
            ["Inicio Full Fuerza"] = "Start Full Strength",
            ["Inicio Full Agilidad"] = "Start Full Agility",
            ["cambiar a Full ArPen"] = "swap to Full ArPen",
            ["hasta Hard Cap"] = "up to Hard Cap",
            ["al alcanzar"] = "at",
            ["con abalorios de"] = "with trinkets from",
            ["luego"] = "then",
            ["Inicio"] = "Early",
            ["Medio equipo"] = "Mid gear",
            ["Buscar"] = "Aim for",
            ["usando abalorio"] = "with trinket",
            ["Al conseguir"] = "Once you get",
            ["tirar"] = "drop",
            ["buscar"] = "push for",
            ["fijo"] = "fixed",
            ["con arco ICC"] = "with ICC bow",
            ["con ICC"] = "with ICC",
            ["con Escorpión o Estandarte"] = "with Scorpion or Banner",
            ["con Escorpión"] = "with Scorpion",
            ["en gemas amarillas"] = "in yellow gems",
            ["híbridas al llegar al Hard Cap"] = "hybrid gems once at Hard Cap",
            -- Other UI
            ["Lágrima"] = "Tear",
            ["Rojas"] = (rawget(L, "GEM_RED") or "Red") .. "s",
            ["Amarillas"] = (rawget(L, "GEM_YELLOW") or "Yellow") .. "s",
            ["Azules"] = (rawget(L, "GEM_BLUE") or "Blue") .. "s",
            ["Roja"] = rawget(L, "GEM_RED") or "Red",
            ["Amarilla"] = rawget(L, "GEM_YELLOW") or "Yellow",
            ["Azul"] = rawget(L, "GEM_BLUE") or "Blue",
            ["Pecho"] = rawget(L, "SLOT_CHEST") or "Chest",
            ["Cabeza"] = rawget(L, "SLOT_HEAD") or "Head",
            ["Cuello"] = rawget(L, "SLOT_NECK") or "Neck",
            ["Hombros"] = rawget(L, "SLOT_SHOULDERS") or "Shoulders",
            ["Usa"] = "Use",
            ["usar"] = "use",
            ["para activar"] = "to activate",
            ["ranuras"] = "sockets",
            ["Prioridad"] = rawget(L, "PRIORITY_LABEL") or "Priority",
            [" en "] = " in ",
            [" y "] = " and ",
            [" solo "] = " only ",
            [" con "] = " with ",
            ["Encantar "] = "Enchant ",
            ["encantar "] = "enchant ",
            ["capa"] = "Cloak",
            ["pechera"] = "Chest",
            ["brazales"] = "Bracers",
            ["guantes"] = "Gloves",
            ["botas"] = "Boots",
            ["Armadura de pierna"] = "Leg Armor",
            ["Hebilla eterna"] = "Eternal Belt Buckle",
            ["Runa del cruzado caído"] = "Rune of the Fallen Crusader",
            ["Estadísticas"] = "Stats",
            ["potentes"] = "Powerful",
            ["Asalto"] = "Attack Power",
            ["superior"] = "Superior",
            ["tormento"] = "Torment",
            ["hacha"] = "Axe",
            ["Ébano"] = "Ebon Blade",
            ["Hodir"] = "Hodir",
            ["escama de hielo"] = "Icescale",
            ["PA"] = "AP",
            ["Crítico"] = "Crit",
            ["Críticas"] = "Crit",
            ["Hechizos"] = "Spells",
            ["Índice de Golpe"] = "Hit Rating",
            ["índice de golpe"] = "Hit Rating",
            ["índice de defensa"] = "Defense Rating",
            ["Defensa"] = "Defense",
            ["Salud Efectiva"] = "Effective Health",
            ["Esquiva"] = "Dodge",
            ["Parada"] = "Parry",
            ["Poder con hechizos"] = "Spell Power",
            ["Puntería"] = "Marksmanship",
            ["Bestias"] = "Beast Mastery",
            ["Supervivencia"] = "Survival",
            ["Cazador"] = "Hunter",
            ["Equilibrio"] = "Balance",
            ["Combate Feral"] = "Feral Combat",
            ["Restauración"] = "Restoration",
            ["Combate"] = "Combat",
            ["Asesinato"] = "Assassination",
            ["Sutileza"] = "Subtlety",
            ["Sanación"] = "Healing",
            ["Protección"] = "Protection",
            ["Venganza"] = "Vengeance",
            ["Argenta"] = "Argent",
            ["Cruzado"] = "Crusader",
            ["Oso"] = "Bear",
            ["Gato"] = "Cat",
            ["Mage"] = "Mage",
            ["Guerrero"] = "Warrior",
            ["Pícaro"] = "Rogue",
            ["Brujo"] = "Warlock",
            ["Sacerdote"] = "Priest",
            ["Caballero de la Muerte"] = "Death Knight",
            ["Paladín"] = "Paladin",
            ["Chamán"] = "Shaman",
        }
        
        self.StaticSortedKeys = {}
        for k in pairs(self.StaticTranslations) do table.insert(self.StaticSortedKeys, k) end
        table.sort(self.StaticSortedKeys, function(a, b) return #a > #b end)
    end
    
    local result = text
    for _, k in ipairs(self.StaticSortedKeys) do
        local v = self.StaticTranslations[k]
        result = result:gsub(k, v)
        
        local lowK = k:lower()
        if lowK ~= k then
            result = result:gsub(lowK, v:lower())
        end
    end
    
    result = result:gsub("Índice de ", "")
    result = result:gsub("índice de ", "")
    
    return result
end

function GearAnalyzer:DetectSpecFromGear()
    local classTag = self:GetClassToken()
    if not classTag then return nil end
    local stats = {
        spellPower = 0, attackPower = 0, strength = 0, agility = 0, intellect = 0,
        spirit = 0, stamina = 0, defense = 0, dodge = 0, parry = 0, blockValue = 0,
        haste = 0, crit = 0, hit = 0, expertise = 0, armorPen = 0, mp5 = 0,
    }
    for slot = 1, 18 do
        local itemLink = GetInventoryItemLink("player", slot)
        if itemLink then
            local itemStats = GetItemStats(itemLink)
            if itemStats then
                for stat, value in pairs(itemStats) do
                    if stat == "ITEM_MOD_SPELL_POWER_SHORT" then stats.spellPower = stats.spellPower + value
                    elseif stat == "ITEM_MOD_ATTACK_POWER_SHORT" then stats.attackPower = stats.attackPower + value
                    elseif stat == "ITEM_MOD_STRENGTH_SHORT" then stats.strength = stats.strength + value
                    elseif stat == "ITEM_MOD_AGILITY_SHORT" then stats.agility = stats.agility + value
                    elseif stat == "ITEM_MOD_INTELLECT_SHORT" then stats.intellect = stats.intellect + value
                    elseif stat == "ITEM_MOD_SPIRIT_SHORT" then stats.spirit = stats.spirit + value
                    elseif stat == "ITEM_MOD_STAMINA_SHORT" then stats.stamina = stats.stamina + value
                    elseif stat == "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" then stats.defense = stats.defense + value
                    elseif stat == "ITEM_MOD_DODGE_RATING_SHORT" then stats.dodge = stats.dodge + value
                    elseif stat == "ITEM_MOD_PARRY_RATING_SHORT" then stats.parry = stats.parry + value
                    elseif stat == "ITEM_MOD_BLOCK_VALUE_SHORT" then stats.blockValue = stats.blockValue + value
                    elseif stat == "ITEM_MOD_HASTE_RATING_SHORT" or stat == "ITEM_MOD_HASTE_MELEE_RATING_SHORT" or stat == "ITEM_MOD_HASTE_SPELL_RATING_SHORT" then stats.haste = stats.haste + value
                    elseif stat == "ITEM_MOD_CRIT_RATING_SHORT" or stat == "ITEM_MOD_CRIT_MELEE_RATING_SHORT" or stat == "ITEM_MOD_CRIT_SPELL_RATING_SHORT" then stats.crit = stats.crit + value
                    elseif stat == "ITEM_MOD_HIT_RATING_SHORT" or stat == "ITEM_MOD_HIT_MELEE_RATING_SHORT" or stat == "ITEM_MOD_HIT_SPELL_RATING_SHORT" then stats.hit = stats.hit + value
                    elseif stat == "ITEM_MOD_EXPERTISE_RATING_SHORT" then stats.expertise = stats.expertise + value
                    elseif stat == "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" then stats.armorPen = stats.armorPen + value
                    elseif stat == "ITEM_MOD_MANA_REGENERATION_SHORT" then stats.mp5 = stats.mp5 + value
                    end
                end
            end
        end
    end
    return self:AnalyzeStatsForSpec(classTag, stats)
end

function GearAnalyzer:AnalyzeStatsForSpec(classTag, stats)
    local class = classTag:upper()
    local hasShield = GetInventoryItemID("player", 17) and select(9, GetItemInfo(GetInventoryItemID("player", 17))) == "INVTYPE_SHIELD"
    local isTank = (stats.defense > 140 or (hasShield and stats.blockValue > 400) or stats.dodge > 200 or stats.parry > 200)
    local isHealer = (stats.spellPower > 1000 and (stats.spirit > 300 or stats.mp5 > 100))
    local isCasterDPS = (stats.spellPower > 1000 and stats.spirit < 300)
    
    if class == "DRUID" then
        if isHealer then return "Restoration" end
        if isCasterDPS then return "Balance" end
        if isTank then return "Feral Bear" end
        return "Feral Cat"
    elseif class == "PRIEST" then
        if stats.hit > 100 or isCasterDPS then return "Shadow" end
        if stats.spirit > 500 or stats.spellPower > 2000 then
             if stats.spirit > stats.crit * 1.2 then return "Holy" end
             return "Discipline"
        end
        return stats.spirit > stats.crit and "Holy" or "Discipline"
    elseif class == "PALADIN" then
        if isTank then return "Protection" end
        if isHealer then return "Holy" end
        return "Retribution"
    elseif class == "WARRIOR" then
        if isTank then return "Protection" end
        return GetInventoryItemLink("player", 17) and "Fury" or "Arms"
    elseif class == "DEATHKNIGHT" then
        if isTank then return self:IsWearing2H() and "Blood Tank" or "Frost" end
        return stats.strength > stats.attackPower and "Unholy" or "Frost"
    elseif class == "SHAMAN" then
        if isHealer then return "Restoration" end
        if isCasterDPS then return "Elemental" end
        return "Enhancement"
    elseif class == "MAGE" then
        return stats.crit > stats.haste and "Fire" or "Arcane"
    elseif class == "WARLOCK" then
        if stats.haste > 400 then return "Affliction" end
        return stats.crit > stats.haste and "Destruction" or "Demonology"
    elseif class == "ROGUE" then
        return (stats.expertise > 100 or stats.armorPen > 200) and "Combat" or "Assassination"
    elseif class == "HUNTER" then
        if stats.armorPen > 500 then return "Marksmanship" end
        return stats.agility > stats.attackPower and "Survival" or "Beast Mastery"
    end
    return nil
end

function GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    if ignoreForced == nil then ignoreForced = true end -- Por defecto, modo jugador
    local class = self:GetClassToken(ignoreForced)
    local _, playerClass = UnitClass("player")
    if not ignoreForced and self.cachedCurrentSpec and self.cachedCurrentSpecClass == class then
        return self.cachedCurrentSpec
    end
    local forced = (not ignoreForced) and self.db.profile.settings.forcedSpec
    if forced and forced ~= "AUTO" then
        self.cachedCurrentSpec = forced
        self.cachedCurrentSpecClass = class
        return forced
    end
    local talentSpec = (class == playerClass) and self:GetCurrentSpec(ignoreForced) or "None"
    local fallbackSpec = nil
    if talentSpec == "None" then
        if class == playerClass then
            fallbackSpec = self:DetectSpecFromGear()
        end
        if not fallbackSpec then
            local specs = self:GetClassSpecs(ignoreForced)
            fallbackSpec = specs[1] or "None"
        end
    end
    local finalSpec = (talentSpec ~= "None") and talentSpec or fallbackSpec
    local result = self:NormalizeSpecName(finalSpec)
    if not ignoreForced then
        self.cachedCurrentSpec = result
        self.cachedCurrentSpecClass = class
    end
    return result
end

function GearAnalyzer:NormalizeSpecName(spec)
    if not spec or spec == "None" or spec == "Ninguna" then return "None" end
    local s = spec:lower()
    
    -- Death Knight
    if s:find("sangre") or s:find("blood") then 
        if s:find("dps") then return "Blood DPS" end
        if s:find("tanque") or s:find("tank") or self:IsTank() then return "Blood Tank" end
        return "Blood DPS"
    end
    if s:find("escarcha") or s:find("frost") then return "Frost" end
    if s:find("profano") or s:find("unholy") then return "Unholy" end
    
    -- Druid
    if s:find("feral") then
        if s:find("gato") or s:find("cat") or s:find("dps") then return "Feral Cat" end
        if s:find("tanque") or s:find("oso") or s:find("bear") or self:IsTank() then return "Feral Bear" end
        return "Feral Cat"
    end
    if s:find("equilibrio") or s:find("balance") then return "Balance" end
    if s:find("restauracion") or s:find("restauración") or s:find("resto") then return "Restoration" end
    
    -- Paladin / Priest / Warrior
    if s:find("sagrado") or s:find("holy") then return "Holy" end
    if s:find("proteccion") or s:find("protección") or s:find("protection") then return "Protection" end
    if s:find("reprension") or s:find("reprensión") or s:find("retribution") then return "Retribution" end
    
    -- Warrior
    if s:find("furia") or s:find("fury") then return "Fury" end
    if s:find("armas") or s:find("arms") then return "Arms" end
    
    -- Shaman
    if s:find("elemental") then return "Elemental" end
    if s:find("mejora") or s:find("enhancement") then return "Enhancement" end
    
    -- Warlock
    if s:find("afliccion") or s:find("aflicción") or s:find("affliction") then return "Affliction" end
    if s:find("demonologia") or s:find("demonología") or s:find("demonology") then 
        return "Demonology"
    end
    if s:find("destruccion") or s:find("destrucción") or s:find("destruction") then return "Destruction" end
    
    -- Mage
    if s:find("arcano") or s:find("arcane") then return "Arcane" end
    if s:find("piro") or (s:find("fuego") and s:find("escarcha")) or s:find("ffb") then return "Fire FFB" end
    if s:find("fuego") or s:find("fire") then return "Fire" end
    if s:find("escarcha") or s:find("frost") then return "Frost" end
    
    -- Rogue
    if s:find("asesinato") or s:find("assassination") then return "Assassination" end
    if s:find("combate") or s:find("combat") then return "Combat" end
    if s:find("sutileza") or s:find("subtlety") then return "Subtlety" end

    -- Hunter
    if s:find("bestias") or s:find("beast") then return "Beast Mastery" end
    if s:find("punteria") or s:find("puntería") or s:find("marks") then return "Marksmanship" end
    if s:find("supervivencia") or s:find("survival") then return "Survival" end
    
    -- Priest
    if s:find("disciplina") or s:find("discipline") then return "Discipline" end
    if s:find("sombras") or s:find("sombra") or s:find("shadow") then return "Shadow" end
    if s:find("sagrado") or s:find("holy") then return "Holy" end
    
    return spec
end

-- Stats Getters (for guide comparisons)
function GearAnalyzer:GetPlayerStat(stat)
    local val = 0
    if stat == "HIT" then 
        local rating = GetCombatRating(CR_HIT_MELEE)
        val = (rating / 32.79)
    elseif stat == "HIT_SPELL" then 
        local rating = GetCombatRating(CR_HIT_SPELL)
        val = (rating / 26.23)
    elseif stat == "EXPERTISE" then 
        local rating = GetCombatRating(CR_EXPERTISE)
        val = (rating / 8.2)
    elseif stat == "DEFENSE" or stat == "DEF" then 
        local base, modifier = UnitDefense("player")
        val = base + modifier
    elseif stat == "HASTE" then 
        val = GetCombatRating(CR_HASTE_SPELL)
        if val == 0 then val = GetCombatRating(CR_HASTE_MELEE) end
    elseif stat == "STR" then val = select(2, UnitStat("player", 1))
    elseif stat == "AGI" then val = select(2, UnitStat("player", 2))
    elseif stat == "STA" then val = select(2, UnitStat("player", 3))
    elseif stat == "INT" then val = select(2, UnitStat("player", 4))
    elseif stat == "SPIRIT" then val = select(2, UnitStat("player", 5))
    elseif stat == "AP" then val = select(1, UnitAttackPower("player"))
    elseif stat == "RAP" then val = select(1, UnitRangedAttackPower("player"))
    elseif stat == "ARMOR" then val = select(2, UnitArmor("player"))
    elseif stat == "DODGE" then val = GetDodgeChance()
    elseif stat == "PARRY" then val = GetParryChance()
    end
    return val or 0
end

function GearAnalyzer:GetStatVal(stat)
    local val = 0
    if stat == "HIT" then 
        val = GetCombatRating(CR_HIT_MELEE)
    elseif stat == "HIT_SPELL" then 
        val = GetCombatRating(CR_HIT_SPELL)
    elseif stat == "EXPERTISE" or stat == "EXP" then 
        val = GetExpertise()
    elseif stat == "ArPen" or stat == "ARPEN" or stat == "ARP" then 
        val = GetCombatRating(CR_ARMOR_PENETRATION)
    elseif stat == "DEFENSE" or stat == "DEF" then 
        local base, mod = UnitDefense("player")
        val = base + mod
    elseif stat == "HASTE" then
        val = GetCombatRating(CR_HASTE_SPELL)
        if (not val or val == 0) then val = GetCombatRating(CR_HASTE_MELEE) end
    elseif stat == "SP" then
        local maxSP = 0
        for i = 2, 7 do
            local sp = GetSpellBonusDamage(i)
            if sp > maxSP then maxSP = sp end
        end
        val = maxSP
    elseif stat == "CRIT" then
        local class = self:GetClassToken()
        local spec = self:GetCurrentSpecEnhanced()
        local role = "Melee"
        if self.ClassData[class] and self.ClassData[class].Caps and self.ClassData[class].Caps[spec] then
            role = self.ClassData[class].Caps[spec].role
        end
        if role == "Caster" or role == "Healer" then
            local school = 4 -- Naturaleza por defecto (Druida/Chamán)
            if class == "MAGE" then
                if spec == "Arcane" then school = 7
                elseif spec == "Fire" or spec == "Fire FFB" then school = 3
                elseif spec == "Frost" then school = 5
                end
            elseif class == "PRIEST" then
                if spec == "Shadow" then school = 6
                else school = 2
                end
            elseif class == "WARLOCK" then
                if spec == "Destruction" then school = 3
                else school = 6
                end
            end
            val = GetSpellCritChance(school)
        else
            val = GetCritChance() -- Crítico Físico
        end
    elseif stat == "STR" then val = select(2, UnitStat("player", 1))
    elseif stat == "AGI" then val = select(2, UnitStat("player", 2))
    elseif stat == "STA" then val = select(2, UnitStat("player", 3))
    elseif stat == "INT" then val = select(2, UnitStat("player", 4))
    elseif stat == "SPIRIT" then val = select(2, UnitStat("player", 5))
    elseif stat == "AP" then val = select(1, UnitAttackPower("player"))
    elseif stat == "RAP" then val = select(1, UnitRangedAttackPower("player"))
    elseif stat == "ARMOR" then val = select(2, UnitArmor("player"))
    elseif stat == "DODGE" then val = GetDodgeChance()
    elseif stat == "PARRY" then val = GetParryChance()
    end
    return val or 0
end

function GearAnalyzer:IsTank(ignoreForced)
    local class = self:GetClassToken(ignoreForced)
    local form = GetShapeshiftForm()
    
    if class == "DEATHKNIGHT" then
        if form == 2 then return true end
    elseif class == "WARRIOR" then
        if form == 2 then return true end
    elseif class == "DRUID" then
        if form == 1 then return true end
    elseif class == "PALADIN" then
        local spellName = GearAnalyzer.LocaleTankSpells and GearAnalyzer.LocaleTankSpells.PALADIN
        if spellName and UnitBuff("player", spellName) then return true end
    end

    local defense = GetCombatRating(CR_DEFENSE_SKILL or 2) or 0
    local _, defenseSkill = UnitDefense("player")
    if defense > 140 or (defenseSkill and defenseSkill > 500) then return true end 

    if class == "DRUID" then
        local agility = select(2, UnitStat("player", 2)) or 0
        local stamina = select(2, UnitStat("player", 3)) or 0
        return (stamina > agility * 1.5)
    elseif class == "WARRIOR" or class == "PALADIN" then
        local parry = GetParryChance() or 0
        local hasShield = GetInventoryItemID("player", 17) and select(9, GetItemInfo(GetInventoryItemID("player", 17))) == "INVTYPE_SHIELD"
        return (parry > 20 and hasShield)
    end
    return false
end

function GearAnalyzer:IsWearing2H()
    local itemLink = GetInventoryItemLink("player", 16)
    if not itemLink then return false end
    local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
    return itemEquipLoc == "INVTYPE_2HWEAPON"
end

function GearAnalyzer:GetClassToken(ignoreForced)
    if ignoreForced == nil then ignoreForced = true end -- Por defecto, modo jugador
    local classTag
    local forced = (not ignoreForced) and self.db.profile.settings.forcedClass
    if forced and forced ~= "AUTO" then
        classTag = forced
    else
        local _, nativeTag = UnitClass("player")
        classTag = nativeTag
    end
    if not classTag then return "UNKNOWN" end
    local c = classTag:upper():gsub(" ", "")
    local map = {
        ["DRUIDA"] = "DRUID", ["DRUID"] = "DRUID",
        ["CABALLERODELAMUERTE"] = "DEATHKNIGHT", ["DEATHKNIGHT"] = "DEATHKNIGHT",
        ["GUERRERO"] = "WARRIOR", ["WARRIOR"] = "WARRIOR",
        ["PALADIN"] = "PALADIN", ["CAZADOR"] = "HUNTER", ["HUNTER"] = "HUNTER",
        ["PICARO"] = "ROGUE", ["ROGUE"] = "ROGUE", ["SACERDOTE"] = "PRIEST", ["PRIEST"] = "PRIEST",
        ["CHAMAN"] = "SHAMAN", ["SHAMAN"] = "SHAMAN", ["MAGO"] = "MAGE", ["MAGE"] = "MAGE",
        ["BRUJO"] = "WARLOCK", ["WARLOCK"] = "WARLOCK",
    }
    return map[c] or c
end

function GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local classTag = self:GetClassToken(ignoreForced)
    if not classTag or classTag == "AUTO" then _, classTag = UnitClass("player") end
    if not classTag then return "Desconocido" end
    local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
    return L[classTag:upper()] or classTag
end

function GearAnalyzer:GetProfessionsList()
    if self.cachedProfessions then return self.cachedProfessions end
    local profs = {}
    local numSkills = GetNumSkillLines()
    for i = 1, numSkills do
        local name, isHeader = GetSkillLineInfo(i)
        if name and not isHeader then
            local key = GearAnalyzer.LocaleProfessionMap and GearAnalyzer.LocaleProfessionMap[name]
            if key then profs[key] = true end
        end
    end
    self.cachedProfessions = profs
    return profs
end

