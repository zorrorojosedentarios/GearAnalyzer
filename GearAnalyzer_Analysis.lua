-- =========================
-- GearAnalyzer Analysis
-- FLAGS: BIS / GEMAS / ENCHANT
-- WoW 3.3.5
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")

-- Fuentes manuales (Fallback para objetos que no están en Bases de Datos)
GearAnalyzer.ManualSources = {
    [51300] = { instance = "ICC (25H)", boss = "Token T10" }, 
    [50454] = { instance = "ICC", boss = "Vendedor Emblemas" },
    [50453] = { instance = "ICC", boss = "Vendedor Emblemas" },
    [50398] = { instance = "ICC", boss = "Rep. Ashen Verdict" },
    [50402] = { instance = "ICC", boss = "Rep. Ashen Verdict" },
}

-- Bridge para LibPeriodicTable (Datos de ClassLoot/PT3)
function GearAnalyzer:GetSourceFromPT3(itemID)
    local PT = LibStub("LibPeriodicTable-3.1", true)
    if not PT then return nil, nil end
    
    local sets = PT:ItemSearch(itemID)
    if not sets then return nil, nil end
    
    local BZ = LibStub("LibBabble-Zone-3.0", true)
    local BB = LibStub("LibBabble-Boss-3.0", true)
    local BZ_Lookup = BZ and BZ:GetUnstrictLookupTable()
    local BB_Lookup = BB and BB:GetUnstrictLookupTable()

    for _, v in pairs(sets) do
        local set, instance, difficulty, boss = strsplit(".", v)
        if set == "RaidLoot" then
            -- Mapear dificultades para hacerlo más legible
            local d = ""
            if difficulty == "1" then d = "(10N)"
            elseif difficulty == "2" then d = "(25N)"
            elseif difficulty == "3" then d = "(10H)"
            elseif difficulty == "4" then d = "(25H)"
            end

            -- Limpiar nombres de instancias comunes
            instance = instance:gsub("Icecrown Citadel", "ICC"):gsub("The Ruby Sanctum", "RS")
            
            -- Traducir si es posible
            instance = BZ_Lookup and (BZ_Lookup[instance] or instance) or instance
            boss = BB_Lookup and (BB_Lookup[boss] or boss) or boss

            return instance .. (d ~= "" and " " .. d or ""), boss
        end
    end
    return nil, nil
end

function GearAnalyzer:GetItemSource(itemID)
    if not itemID or itemID == 0 or itemID == -1 then return "??", "Desconocido" end
    local id = tonumber(itemID)
    
    -- 1. Prioridad: Fuentes manuales (Muy específicas)
    if self.ManualSources and self.ManualSources[id] then
        return self.ManualSources[id].instance, self.ManualSources[id].boss
    end

    -- 2. DINÁMICO: Buscar en LibPeriodicTable (Datos de ClassLoot)
    local ptInst, ptBoss = self:GetSourceFromPT3(id)
    if ptInst then return ptInst, ptBoss end

    -- 3. Base de datos guardada (Sincronizada)
    local db = self.db.profile
    if db and db.sources and db.sources[id] then
        local src = db.sources[id]
        if src.instance and src.instance ~= "??" and src.boss and src.boss ~= "Desconocido" then
            return src.instance, src.boss
        end
    end

    -- 4. Búsqueda en lootTable de BiSTooltip (si está cargado)
    if _G.lootTable then
        for zone, bosses in pairs(_G.lootTable) do
            for boss, items in pairs(bosses) do
                for _, itemId in ipairs(items) do
                    if itemId == id then
                        local cleanZone = zone:gsub("Icecrown Citadel", "ICC"):gsub("The Ruby Sanctum", "RS"):gsub("Trial of the Crusader", "TotC")
                        return cleanZone, boss
                    end
                end
            end
        end
    end

    -- 5. Heurísticas por Rango (Último recurso)
    if id >= 51280 and id <= 51308 then return "Tokens", "T10 Santificado (277)" end
    if id >= 51160 and id <= 51279 then return "Tokens", "T10 Santificado (264)" end
    if id >= 50730 and id <= 50738 then return "ICC (25H)", "Lich King" end
    if id >= 50600 and id <= 50735 then return "ICC (25H)", "Jefe" end
    if id >= 54500 and id <= 55000 then return "RS (25H)", "Halion" end
    if id >= 49890 and id <= 49910 then return "Profesión", "Sastrería/Peletería" end
    if id >= 50000 and id <= 50150 then return "Tokens / Emblemas", "Vendedor Tier T10" end
    
    -- Fallback final: En lugar de ?? mostrar categorías genéricas de WotLK
    return "Tokens / Misión", "Profesión / Vendedor"
end


function GearAnalyzer:GetSlotKey(slotName, slotID)
    if slotID then
        local mapByID = {
            [1] = "head", [2] = "neck", [3] = "shoulders", [5] = "chest",
            [6] = "waist", [7] = "legs", [8] = "feet", [9] = "wrists",
            [10] = "hands", [11] = "ring1", [12] = "ring2", [13] = "trinket1",
            [14] = "trinket2", [15] = "back", [16] = "weapon", [17] = "offhand",
            [18] = (select(2, UnitClass("player")) == "HUNTER") and "ranged" or "idol",
        }
        if mapByID[slotID] then return mapByID[slotID] end
    end
    
    local map = {
        ["SLOT_HEAD"] = "head", ["SLOT_NECK"] = "neck", ["SLOT_SHOULDERS"] = "shoulders", ["SLOT_BACK"] = "back",
        ["SLOT_CHEST"] = "chest", ["SLOT_WRISTS"] = "wrists", ["SLOT_HANDS"] = "hands", ["SLOT_WAIST"] = "waist",
        ["SLOT_LEGS"] = "legs", ["SLOT_FEET"] = "feet", ["SLOT_WEAPON"] = "weapon", ["SLOT_OFFHAND"] = "offhand",
        ["SLOT_RELIC"] = "idol", ["SLOT_RING"] = "ring1", ["SLOT_TRINKET"] = "trinket1",
        
        -- English / Modular
        ["Head"] = "head", ["Neck"] = "neck", ["Shoulder"] = "shoulders", ["Shoulders"] = "shoulders",
        ["Back"] = "back", ["Chest"] = "chest", ["Wrist"] = "wrists", ["Wrists"] = "wrists",
        ["Hands"] = "hands", ["Waist"] = "waist", ["Legs"] = "legs", ["Feet"] = "feet",
        ["Finger"] = "ring1", ["Trinket"] = "trinket1", ["Weapon"] = "weapon",
        ["Off hand"] = "offhand", ["Ranged"] = "ranged", ["Relic"] = "idol",
        
        -- Legacy Spanish
        ["Cabeza"] = "head", ["Cuello"] = "neck", ["Hombros"] = "shoulders", ["Espalda"] = "back",
        ["Pecho"] = "chest", ["Muñecas"] = "wrists", ["Manos"] = "hands", ["Cintura"] = "waist",
        ["Piernas"] = "legs", ["Pies"] = "feet", ["Anillo 1"] = "ring1", ["Anillo 2"] = "ring2",
        ["Mano principal"] = "weapon",
        ["Mano secundaria"] = "offhand", ["Reliquia"] = "idol", ["Rango"] = "ranged", ["Distancia"] = "ranged",
        ["Ranged"] = "ranged", ["Relic"] = "idol",
    }
    return map[slotName]
end

function GearAnalyzer:GetINVTYPE(slotName, slotID)
    if slotID then
        local mapByID = {
            [1] = "INVTYPE_HEAD", [2] = "INVTYPE_NECK", [3] = "INVTYPE_SHOULDER",
            [5] = "INVTYPE_CHEST", [6] = "INVTYPE_WAIST", [7] = "INVTYPE_LEGS",
            [8] = "INVTYPE_FEET", [9] = "INVTYPE_WRIST", [10] = "INVTYPE_HAND",
            [11] = "INVTYPE_FINGER", [12] = "INVTYPE_FINGER", [13] = "INVTYPE_TRINKET",
            [14] = "INVTYPE_TRINKET", [15] = "INVTYPE_CLOAK", [16] = "INVTYPE_WEAPON",
            [17] = "INVTYPE_WEAPONOFFHAND", 
            [18] = (select(2, UnitClass("player")) == "HUNTER" or select(2, UnitClass("player")) == "ROGUE" or select(2, UnitClass("player")) == "WARRIOR") and "INVTYPE_RANGED" or "INVTYPE_RELIC",
        }
        if mapByID[slotID] then return mapByID[slotID] end
    end
    
    local map = {
        ["SLOT_HEAD"] = "INVTYPE_HEAD", ["SLOT_NECK"] = "INVTYPE_NECK", ["SLOT_SHOULDERS"] = "INVTYPE_SHOULDER",
        ["SLOT_BACK"] = "INVTYPE_CLOAK", ["SLOT_CHEST"] = "INVTYPE_CHEST", ["SLOT_WRISTS"] = "INVTYPE_WRIST",
        ["SLOT_HANDS"] = "INVTYPE_HAND", ["SLOT_WAIST"] = "INVTYPE_WAIST", ["SLOT_LEGS"] = "INVTYPE_LEGS",
        ["SLOT_FEET"] = "INVTYPE_FEET", ["SLOT_RING"] = "INVTYPE_FINGER", ["SLOT_TRINKET"] = "INVTYPE_TRINKET",
        ["SLOT_WEAPON"] = "INVTYPE_WEAPON", ["SLOT_OFFHAND"] = "INVTYPE_WEAPONOFFHAND",
        ["SLOT_RELIC"] = "INVTYPE_RELIC",
        
        -- Legacy
        ["Cabeza"] = "INVTYPE_HEAD", ["Cuello"] = "INVTYPE_NECK", ["Hombros"] = "INVTYPE_SHOULDER",
        ["Espalda"] = "INVTYPE_CLOAK", ["Pecho"] = "INVTYPE_CHEST", ["Muñecas"] = "INVTYPE_WRIST",
        ["Manos"] = "INVTYPE_HAND", ["Cintura"] = "INVTYPE_WAIST", ["Piernas"] = "INVTYPE_LEGS",
        ["Pies"] = "INVTYPE_FEET", ["Anillo 1"] = "INVTYPE_FINGER", ["Anillo 2"] = "INVTYPE_FINGER",
        ["Abalorio 1"] = "INVTYPE_TRINKET", ["Abalorio 2"] = "INVTYPE_TRINKET",
        ["Mano principal"] = "INVTYPE_WEAPON", ["Mano secundaria"] = "INVTYPE_WEAPONOFFHAND",
        ["Reliquia"] = "INVTYPE_RELIC", ["Rango"] = "INVTYPE_RANGED", ["Distancia"] = "INVTYPE_RANGED",
    }
    return map[slotName]
end


function GearAnalyzer:ItemLinkHasID(itemLink, itemID)
    if not itemLink or not itemID then return false end
    return string.find(itemLink, "item:"..itemID, 1, true) ~= nil
end


function GearAnalyzer:GetDynamicGems(class, spec)
    local normSpec = self:NormalizeSpecName(spec)
    local classData = self.ClassData[class]
    if not classData or not classData.Gems or not classData.Gems[normSpec] then return nil end
    
    local gems = classData.Gems[normSpec]
    
    -- LÓGICA DINÁMICA DE PROGRESIÓN (SUBIBAJA FUERZA/AGILIDAD -> ARPEN)
    local redGem = gems.red
    local yellowGem = gems.yellow
    local blueGem = gems.blue
    local noteText = gems.note
    
    local arpRating = GetCombatRating(CR_ARMOR_PENETRATION) or 0
    
    if class == "DEATHKNIGHT" and normSpec == "Frost" then
        if arpRating >= 1000 then
            redGem = 40117 -- Rubí cárdeno fracturado (+20 ArPen)
            yellowGem = 40117
            blueGem = 40117
            noteText = "DYNAMIC_GEM_NOTE_DK_FROST_FINAL"
        else
            redGem = 40111 -- Rubí cárdeno llamativo (+20 Fuerza)
            yellowGem = 40111
            blueGem = 40111
            noteText = "DYNAMIC_GEM_NOTE_DK_FROST_INITIAL"
        end
    elseif class == "DRUID" and normSpec == "Feral Cat" then
        if arpRating >= 700 then
            redGem = 40117 -- Rubí cárdeno fracturado (+20 ArPen)
            yellowGem = 40117
            blueGem = 40117
            noteText = "DYNAMIC_GEM_NOTE_DRUID_CAT_FINAL"
        else
            redGem = 40112 -- Rubí cárdeno delicado (+20 Agilidad)
            yellowGem = 40147 -- Ametrino letal (+10 Agi / +10 Crit)
            blueGem = 40112
            noteText = "DYNAMIC_GEM_NOTE_DRUID_CAT_INITIAL"
        end
    elseif class == "HUNTER" and normSpec == "Marksmanship" then
        if arpRating >= 800 then
            redGem = 40117 -- Rubí cárdeno fracturado (+20 ArPen)
            yellowGem = 40117
            blueGem = 40117
            noteText = "DYNAMIC_GEM_NOTE_HUNTER_MM_FINAL"
        else
            redGem = 40112 -- Rubí cárdeno delicado (+20 Agilidad)
            yellowGem = 40147 -- Ametrino mortal (+10 Agi / +10 Crit)
            blueGem = 40112
            noteText = "DYNAMIC_GEM_NOTE_HUNTER_MM_INITIAL"
        end
    end
    
    local current = {
        meta = gems.meta,
        red = redGem,
        yellow = yellowGem,
        blue = blueGem,
        prismatic = gems.prismatic,
        prismaticSlot = gems.prismaticSlot,
        note = noteText,
        capsStatus = {}
    }

    local specCaps = classData.Caps and classData.Caps[normSpec]
    if specCaps and specCaps.gemAdjustments then
        -- Primero procesamos todo para tener los estados de los caps
        local failPoints = { HIT = 10, EXPERTISE = 5, ARP = 3, ArPen = 3, ARPEN = 3, OTHER = 1 }
        local bestPriority = 0
        
        for _, adj in ipairs(specCaps.gemAdjustments) do
            local statKey = adj.stat
            if statKey == "HIT" and specCaps.role == "Caster" then statKey = "HIT_SPELL" end
            
            local currentVal = self:GetStatVal(statKey)
            local target = adj.target
            local isMet = currentVal >= target
            local isOver = false
            
            local margin = (statKey:find("HIT")) and 26 or (target * 0.15)
            if currentVal > (target + margin) then isOver = true end

            local transKey = (statKey == "HIT_SPELL") and "HIT_SPELL" or adj.stat
            local statLabel = adj.label or self.StatTrans[transKey] or statKey
            table.insert(current.capsStatus, { 
                label = statLabel, 
                stat = statKey, 
                cap = target, 
                met = isMet, 
                over = isOver 
            })

            local localizedStat = rawget(L, statLabel) or statLabel
            if not isMet then
                local priority = failPoints[adj.stat] or failPoints.OTHER
                if priority > bestPriority then
                    bestPriority = priority
                    local failMsg = "|cffff0000(" .. string.format(L["LACKING"], localizedStat) .. ")|r"
                    if adj.yellow then current.yellow = adj.yellow; current.yellowReason = failMsg end
                    if adj.red then current.red = adj.red; current.redReason = failMsg end
                    if adj.blue then current.blue = adj.blue; current.blueReason = failMsg end
                end
            else
                local okColor = isOver and "|cffffa500" or "|cff00ff00"
                local okLabel = isOver and L["EXCESS_TAG"] or L["OK"]
                local okMsg = okColor .. "(" .. localizedStat .. " " .. okLabel .. ")|r"
                
                if adj.yellow and not current.yellowReason then current.yellowReason = okMsg end
                if adj.red and not current.redReason then current.redReason = okMsg end
                if adj.blue and not current.blueReason then current.blueReason = okMsg end
            end
        end
    end

    if specCaps and specCaps.priorities then
        for _, p in ipairs(specCaps.priorities) do
            if p.cap then
                local statKey = p.stat
                if statKey == "HIT" and specCaps.role == "Caster" then statKey = "HIT_SPELL" end
                
                local exists = false
                local label = p.label or statKey
                for _, s in ipairs(current.capsStatus) do
                    if s.label == label then exists = true; break end
                end
                
                if not exists then
                    local currentVal = self:GetStatVal(statKey)
                    local target = p.cap
                    local isMet = currentVal >= target
                    local isOver = (currentVal > (target + (statKey:find("HIT") and 26 or target * 0.15)))
                    table.insert(current.capsStatus, { 
                        label = label, 
                        stat = statKey, 
                        cap = target, 
                        met = isMet, 
                        over = isOver 
                    })
                end
            end
        end
    end
    
    -- Soporte para Profesiones (Joyería: Ojos de Dragón)
    local profs = self:GetProfessionsList()
    if profs["JEWELCRAFTING"] then
        local jcGems = {
            red = { ["STR"] = 42142, ["AGI"] = 42143, ["SP"] = 42144, ["ARP"] = 42153, ["AP"] = 42145, ["EXP"] = 42152 },
            yellow = { ["CRIT"] = 42148, ["HASTE"] = 42150, ["HIT"] = 42149, ["INT"] = 42146 },
            blue = { ["STA"] = 42151, ["SPIRIT"] = 42147 }
        }
        
        -- Mapeo Extendido de estadísticas para Ojos de Dragón
        local jcStatMap = {
            -- Rojas
            [40111] = "STR", [40112] = "AGI", [40113] = "SP", [40114] = "ARP", [40115] = "AP", [40118] = "EXP",
            -- Amarillas
            [40122] = "INT", [40123] = "HASTE", [40124] = "CRIT", [40125] = "HIT",
            -- Azules
            [40119] = "STA", [40110] = "STA", [40126] = "SPIRIT"
        }
        
        local bestStat = jcStatMap[current.red] or jcStatMap[current.yellow] or jcStatMap[current.blue] or "STR"

        if jcGems.red[bestStat] then
            current.redJC = jcGems.red[bestStat]
        elseif jcGems.yellow[bestStat] then
            current.redJC = jcGems.yellow[bestStat]
        elseif jcGems.blue[bestStat] then
            current.redJC = jcGems.blue[bestStat]
        end
        
        if current.redJC then
            current.redJCReason = "|cffff00ff" .. L["JEWELRY_BIS"] .. "|r"
        end
    end

    -- Nota de "IGNORAR COLOR" solo para DK (según pedido específico)
    if class == "DEATHKNIGHT" then
        if current.yellow == current.red then
            local msg = "|cffffffff" .. L["IGNORE_COLOR"] .. "|r"
            current.yellowReason = current.yellowReason and (current.yellowReason .. " " .. msg) or msg
        end
        if current.blue == current.red then
            local msg = "|cffffffff" .. L["IGNORE_COLOR"] .. "|r"
            current.blueReason = current.blueReason and (current.blueReason .. " " .. msg) or msg
        end
    end

    local overrides = GearAnalyzer.db.global.customOverrides
    if overrides and overrides.gems then
        -- Usamos class_spec para evitar colisiones entre clases (ej. DK Escarcha vs Mago Escarcha)
        local overrideSpec = class .. "_" .. normSpec
        current.red = overrides.gems[overrideSpec .. "_roja"] or current.red
        current.yellow = overrides.gems[overrideSpec .. "_amarilla"] or current.yellow
        current.blue = overrides.gems[overrideSpec .. "_azul"] or current.blue
        current.meta = overrides.gems[overrideSpec .. "_meta"] or current.meta
    end
    
    return current
end

local function IsGemRecommended(gemID, slotColor)
    if not gemID then return false end
    local class = GearAnalyzer:GetClassToken()
    local spec = GearAnalyzer:GetCurrentSpecEnhanced()
    local dynamicGems = GearAnalyzer:GetDynamicGems(class, spec)
    if not dynamicGems then return false end
    
    -- Si no especificamos color, aceptamos cualquiera de las recomendadas (comportamiento antiguo/lazy)
    if not slotColor then
        return (gemID == dynamicGems.red or gemID == dynamicGems.yellow or gemID == dynamicGems.blue or gemID == dynamicGems.meta)
    end
    
    -- Mapeo de colores (acepta gemas mixtas que contengan el color)
    local function CheckMatch(target, current)
        if not target or not current then return false end
        if type(target) == "table" then
            for _, id in ipairs(target) do if current == id then return true end end
            return false
        end
        return target == current
    end

    if slotColor == "meta" then return CheckMatch(dynamicGems.meta, gemID) end
    
    -- Caso especial: Lágrima de pesadilla (Prismática)
    -- Siempre es válida en cualquier hueco de color (rojo, amarillo, azul)
    if gemID == 49110 then return true end

    -- Caso especial: Tanques
    if dynamicGems.blue == 40119 and gemID == 40119 then return true end

    if slotColor == "red" then return CheckMatch(dynamicGems.red, gemID) end
    if slotColor == "yellow" then return CheckMatch(dynamicGems.yellow, gemID) end
    if slotColor == "blue" then return CheckMatch(dynamicGems.blue, gemID) end
    
    return false
end

function GearAnalyzer:AnalyzeEquipment(ignoreForced)
    if ignoreForced == nil then ignoreForced = true end -- Por defecto, analizar al jugador real
    
    -- [CORRECCIÓN CRÍTICA] Escanear SIEMPRE antes de analizar para evitar datos vacíos/stale
    self:ScanEquipment()
    
    -- [CORRECCIÓN CACHÉ] Limpiar el caché de evaluación para evitar que objetos queden como "Sin Datos"
    if self.evaluationCache then wipe(self.evaluationCache) end
    
    local db = self.charDB

    local currentSpec = self:GetCurrentSpecEnhanced(ignoreForced)
    local class = self:GetClassToken(ignoreForced)
    self.temp_currentSpec = currentSpec -- Garantizar que EvaluateItem use la spec correcta

    -- Preparar datos de BiS para la comparación
    local activeBiS = db -- Por defecto usar el del perfil
    if ignoreForced then
        activeBiS = { bis = {}, top6 = {} }
        local phase = db.gamePhase or "T10"
        if phase == "MANUAL" then phase = "T10" end -- Forzar T10 para el análisis automático
        self:SyncWithBiSTooltip(phase, activeBiS, true)
    end

    local dynamicGems = self:GetDynamicGems(class, currentSpec)
    
    local assignedUpgrades = {}
    local pairAssignments = {} -- Rastreador global para evitar duplicados en Anillos/Abalorios
    local checkPairs = { ["ring1"]="ring2", ["ring2"]="ring1", ["trinket1"]="trinket2", ["trinket2"]="trinket1" }

    -- [INTELLIGENT-SET] Conteo de Sets
    local setCounts = {}
    for _, d in ipairs(self.scannedEquipment) do
        if d.itemLink then
            local setName, pieces, max = self:GetSetBonusCount(d.itemLink)
            if setName then
                setCounts[setName] = (setCounts[setName] or 0) + 1
            end
        end
    end

    -- [INTELLIGENT-GEMS] Conteo de Gemas para Meta
    local colorCounts = { red = 0, yellow = 0, blue = 0, metaLink = nil, metaID = 0 }
    
    -- Diagnóstico para el usuario (se verá con modo dev)
    local devLog = ""

    local top6Data = activeBiS.top6
    local bisData = activeBiS.bis

    for _, d in ipairs(self.scannedEquipment) do
        if d.itemLink and d.gems then
            for i, gid in ipairs(d.gems) do
                if gid and gid > 0 then
                    local gColor = self:GetGemColorByID(gid)
                    local gData = self:GetEnchantData(gid)
                    local gName = (gData and gData.name) or "Gema desconocida"
                    
                    if GearAnalyzer.db.profile.settings.devMode then
                        devLog = devLog .. string.format("[%s] ID:%d Color:%s\n", gName, gid, tostring(gColor))
                    end

                    if gColor == "meta" then
                        colorCounts.metaLink = d.itemLink
                        colorCounts.metaID = gid
                    elseif gColor == "red" then 
                        colorCounts.red = colorCounts.red + 1
                    elseif gColor == "yellow" then 
                        colorCounts.yellow = colorCounts.yellow + 1
                    elseif gColor == "blue" then 
                        colorCounts.blue = colorCounts.blue + 1
                    elseif gColor == "orange" then 
                        colorCounts.red = colorCounts.red + 1
                        colorCounts.yellow = colorCounts.yellow + 1
                    elseif gColor == "purple" then 
                        colorCounts.red = colorCounts.red + 1
                        colorCounts.blue = colorCounts.blue + 1
                    elseif gColor == "green" then 
                        colorCounts.yellow = colorCounts.yellow + 1
                        colorCounts.blue = colorCounts.blue + 1
                    elseif gColor == "prismatic" then 
                        colorCounts.red = colorCounts.red + 1
                        colorCounts.yellow = colorCounts.yellow + 1
                        colorCounts.blue = colorCounts.blue + 1
                    end
                end
            end
        end
    end

    -- Si tenemos una Meta, extraer requisitos frescos del tooltip
    local metaReqs = self:GetMetaRequirements(colorCounts.metaLink)
    
    -- Fallback: Si el parser de tooltip falla, usar requisitos estándar por ID (si está en DB)
    if not metaReqs and colorCounts.metaID > 0 then
         local mData = self:GetEnchantData(colorCounts.metaID)
         local mName = (mData and mData.name or ""):lower()
         if mName:find("caótico") or mName:find("chaotic") then
             metaReqs = { blue = 2 } 
         elseif mName:find("incansable") or mName:find("relentless") then
             metaReqs = { red = 1, yellow = 1, blue = 1 }
         elseif mName:find("austero") or mName:find("austere") then
             metaReqs = { blue = 2, red = 1 }
         elseif mName:find("ardiente") or mName:find("burning") or mName:find("ascuas") or mName:find("ember") then
             metaReqs = { red = 3 }
         elseif mName:find("perspicaz") or mName:find("insightful") then
             metaReqs = { red = 1, yellow = 1, blue = 1 }
         end
    end

    local metaActive = true
    local metaError = nil

    if metaReqs then
        if colorCounts.red < (metaReqs.red or 0) then 
            metaActive = false; metaError = string.format(L["GEMS_LACKING_RED"], colorCounts.red, metaReqs.red)
        elseif colorCounts.yellow < (metaReqs.yellow or 0) then 
            metaActive = false; metaError = string.format(L["GEMS_LACKING_YELLOW"], colorCounts.yellow, metaReqs.yellow)
        elseif colorCounts.blue < (metaReqs.blue or 0) then 
            metaActive = false; metaError = string.format(L["GEMS_LACKING_BLUE"], colorCounts.blue, metaReqs.blue)
        elseif metaReqs.moreRedThanYellow and colorCounts.red <= colorCounts.yellow then 
            metaActive = false; metaError = L["GEMS_REQ_RED_GT_YELLOW"]
        end
    end

    -- Guardar logs si devMode
    if GearAnalyzer.db.profile.settings.devMode and colorCounts.metaLink then
        self.lastGemCountLog = devLog
    end

    local usedInventory = {} 
    for _, d in ipairs(self.scannedEquipment) do
        -- Determinar qué campos usar para los resultados según el contexto
        local prefix = ignoreForced and "" or "guide_"
        
        local curCategory, curLevel = self:EvaluateItem(d.itemLink)
        d.iLevel = curLevel
        d[prefix.."isIncorrect"] = (curCategory == "INCORRECT")

        -- Identificar si es T10 Normal (Mejorable)
        d.isTier10Normal = false
        local _, itemIDString = strsplit(":", d.itemLink or "")
        local idNum = tonumber(itemIDString)
        if idNum and (idNum >= 50000 and idNum <= 51160) then d.isTier10Normal = true end

        local slotKey = self:GetSlotKey(d.slotName, d.slotID)
        local top6 = slotKey and top6Data and top6Data[slotKey]
        local pairKey = checkPairs[slotKey]
        local partnerItemLink = nil
        if pairKey then
            for _, otherD in ipairs(self.scannedEquipment) do
                if self:GetSlotKey(otherD.slotName, otherD.slotID) == pairKey then partnerItemLink = otherD.itemLink; break end
            end
        end

        d[prefix.."isBIS"] = false
        d[prefix.."isAlternative"] = false
        d[prefix.."rank"] = nil
        if top6 then
            for rank, itemID in ipairs(top6) do
                if self:ItemLinkHasID(d.itemLink, itemID) then
                    d[prefix.."rank"] = rank
                    if rank <= 6 then d[prefix.."isAlternative"] = true end
                    break
                end
            end
        end

        local targetID = (db.custom_bis and db.custom_bis[slotKey] and db.custom_bis[slotKey].itemID) or (bisData and bisData[slotKey] and bisData[slotKey].itemID)
        if not targetID and top6 then targetID = (pairKey and (slotKey:find("2")) and top6[2]) or top6[1] end
        if targetID and self:ItemLinkHasID(d.itemLink, targetID) then d[prefix.."isBIS"] = true; d[prefix.."isAlternative"] = false end
        if d[prefix.."isBIS"] or d[prefix.."isAlternative"] then d[prefix.."isIncorrect"] = false end

        if not d[prefix.."isBIS"] then
            if targetID and not (partnerItemLink and self:ItemLinkHasID(partnerItemLink, targetID)) and not pairAssignments[targetID] then
                d[prefix.."nextUpgradeID"] = targetID
                if pairKey then pairAssignments[targetID] = true end
            elseif top6 then
                for _, id in ipairs(top6) do
                    local alreadyInPartner = (partnerItemLink and self:ItemLinkHasID(partnerItemLink, id))
                    local alreadyAssignedInPair = pairAssignments[id]
                    if not self:ItemLinkHasID(d.itemLink, id) and not alreadyInPartner and not alreadyAssignedInPair then
                        d[prefix.."nextUpgradeID"] = id
                        assignedUpgrades[slotKey] = id
                        if pairKey then pairAssignments[id] = true end
                        break
                    end
                end
            end
        end

        self:AnalyzeItemGems(d, dynamicGems, metaActive, metaError, ignoreForced)

        local profs = self:GetProfessionsList()
        local isEnchanter = profs and profs["ENCHANTING"]
        
        local ENCHANTABLE = { 
            head=true, shoulders=true, back=true, chest=true, wrists=true, 
            hands=true, legs=true, feet=true, weapon=true, offhand=true, 
            waist=true, ranged=true, ring1=isEnchanter, ring2=isEnchanter
        }
        if ENCHANTABLE[slotKey] then
            local needsEnchant = true
            
            if slotKey == "offhand" and self:IsWearing2H() and not d.itemLink then
                needsEnchant = false
                d[prefix.."enchStatus"] = 2
                d[prefix.."enchTooltip"] = "|cff00ff00" .. L["NO_REQ_2H"] .. "|r"
            elseif not d.itemLink then
                needsEnchant = false
                d[prefix.."enchStatus"] = 2
                d[prefix.."enchTooltip"] = L["NO_REQ_EMPTY"]
            elseif slotKey == "offhand" then
                local itemData = self:GetItemData(d.itemLink)
                if itemData and not itemData.isShield then
                    needsEnchant = false
                    d[prefix.."enchStatus"] = 2
                    d[prefix.."enchTooltip"] = "|cff00ff00" .. L["NO_REQ_SHIELD"] .. "|r"
                end
            end
            
            if needsEnchant then
                local classData = self.ClassData[class:upper()]
                local normSpec = self:NormalizeSpecName(currentSpec)
                local specEnchants = classData and classData.Enchants and classData.Enchants[normSpec]
                self:AnalyzeItemEnchant(d, specEnchants, ignoreForced)
            end
        end

        -- [INFO] Sets
        local setName, pCount, pMax = self:GetSetBonusCount(d.itemLink)
        if setName then
            local activeCount = setCounts[setName] or 0
            d.setInfo = "|cffffd100Set:|r " .. setName .. " (" .. activeCount .. "/" .. pMax .. ")"
        end

        d[prefix.."isCorrect"] = (d[prefix.."isBIS"] or d[prefix.."isAlternative"] or curCategory == "VALID")
    end

    -- [GEMS-SUMMARY] Resumen de gemas que faltan o sobran
    local summaryKey = ignoreForced and "gemSummary_PJ" or "gemSummary_Guide"
    self[summaryKey] = { toChange = {}, missing = {} }
    
    for _, d in ipairs(self.scannedEquipment) do
        local prefix = ignoreForced and "" or "guide_"
        if d.socketAnalysis then
            for _, socket in ipairs(d.socketAnalysis) do
                if not socket.isMatch then
                    local entry = {
                        slot = d.slotName,
                        link = d.itemLink,
                        current = socket.currentName,
                        recommended = socket.recommendedName
                    }
                    if socket.isEmpty then
                        table.insert(self[summaryKey].missing, entry)
                    else
                        table.insert(self[summaryKey].toChange, entry)
                    end
                end
            end
        end
    end

    -- [RECOMENDACIONES DE INVENTARIO]
    if ignoreForced then
        local Rec = self:GetModule("Recommender", true)
        if Rec then
            Rec:UpdateRecommendations(activeBiS)
            for _, d in ipairs(self.scannedEquipment) do
                local slotKey = self:GetSlotKey(d.slotName, d.slotID)
                local best = Rec:GetRecommendation(slotKey)
                if best then
                    d.betterInBags = not best.isBank
                    d.betterInBank = best.isBank
                    d.betterItemLink = best.link
                    d.betterItemBag = best.bag
                    d.betterItemSlot = best.slot
                end
            end
        end
    end
end


-- Encantamientos de profesión (detectados desde ProfessionsDB)
function GearAnalyzer:AnalyzeItemEnchant(d, specEnchants, ignoreForced)
    local prefix = ignoreForced and "" or "guide_"
    local slotKey = self:GetSlotKey(d.slotName, d.slotID)
    local recs = {} -- Lista de posibles encantamientos válidos
    local currentSpec = self:GetCurrentSpecEnhanced(ignoreForced)

    local recData = specEnchants and specEnchants[slotKey]
    if recData then
        -- [FIX] Siempre crear una tabla local nueva para evitar modificar los datos maestros de ClassData
        local rawList = {}
        if type(recData) == "table" and not recData.id then
            for _, v in ipairs(recData) do table.insert(rawList, v) end
        else
            table.insert(rawList, recData)
        end
        
        -- [CASTER-WEAPON-LOGIC] Ajuste dinámico según 1H o 2H para Casters
        if slotKey == "weapon" and d.itemLink then
            local _, _, _, _, _, _, _, _, equipSlot = GetItemInfo(d.itemLink)
            
            -- Detectar si es un caster (si la guía ya recomienda algún ID de SP conocido)
            local isCasterRec = false
            for _, entry in ipairs(rawList) do
                local id = type(entry) == "number" and entry or entry.id
                if id == 3834 or id == 3854 or id == 3833 then
                    isCasterRec = true
                    break
                end
            end
            
            if isCasterRec then
                if equipSlot == "INVTYPE_2HWEAPON" then
                    -- Es un bastón: Recomendamos 81 SP (ID 3854)
                    rawList = { 3854 }
                else
                    -- Es 1H: Recomendamos 63 SP (ID 3834)
                    rawList = { 3834 }
                end
            end
        end

        local profs = GearAnalyzer:GetProfessionsList()
        local profDB = GearAnalyzer.ProfessionsDB
        if profs and profDB then
            for profID, info in pairs(profDB) do
                local isMatchSlot = (info.slot == slotKey) or (info.slot == "ring" and (slotKey == "ring1" or slotKey == "ring2"))
                if profs[info.prof] and isMatchSlot then
                    table.insert(rawList, profID)
                end
            end
        end

        for _, entry in ipairs(rawList) do
            local rawID = type(entry) == "number" and entry or entry.id
            if rawID then
                local map = GearAnalyzer:GetEnchantData(rawID)
                table.insert(recs, { 
                    id = GearAnalyzer:GetEffectiveEnchantID(rawID, slotKey), 
                    checkID = GearAnalyzer:GetEffectiveEnchantID(rawID, slotKey), 
                    name = map and map.name or ("ID: " .. rawID),
                    stats = map and map.stats or ""
                })
            end
        end
    end
    
    -- Overrides manuales (solo el primero de momento para simplificar)
    local overrideKey = (currentSpec or "NONE") .. "_" .. slotKey
    local globalOverrides = GearAnalyzer.db.global.customOverrides
    if globalOverrides and globalOverrides.enchants[overrideKey] then
        local overrideID = tonumber(globalOverrides.enchants[overrideKey])
        if overrideID then
            local map = GearAnalyzer:GetEnchantData(overrideID)
            local overRec = { 
                name = "|cff3fc7eb(Manual)|r " .. (map and map.name or "Cargando..."), 
                checkID = overrideID, 
                stats = map and map.stats or "" 
            }
            -- Si ya había recomendaciones, reemplazamos o añadimos (aquí reemplazamos el check del primero)
            if #recs > 0 then
                recs[1].checkID = overrideID
                if map then recs[1].name = "|cff3fc7eb(Act.)|r " .. (map.name or recs[1].name) end
            else
                table.insert(recs, overRec)
            end
        end
    end

    local enchantID = tonumber(d.enchant)
    if enchantID and enchantID > 0 then
        local map = self:GetEnchantData(enchantID)
        local curName = (map and map.name) or "ID: " .. enchantID
        
        local isMatch = false
        local matchedRec = nil
        
        local function Normalize(s)
            if not s then return "" end
            s = s:lower()
            -- Quitar tildes para evitar fallos de encoding
            s = s:gsub("á", "a"):gsub("é", "e"):gsub("í", "i"):gsub("ó", "o"):gsub("ú", "u"):gsub("ñ", "n")
            s = s:gsub("[^a-z0-9]", "")
            return s
        end
        local normCur = Normalize(curName)

        for _, r in ipairs(recs) do
            if enchantID == r.checkID then
                isMatch = true
                matchedRec = r
                break
            elseif Normalize(r.name) == normCur then
                isMatch = true
                matchedRec = r
                break
            end
        end

        if isMatch then
            -- Si es un encantamiento de profesión y el jugador la tiene, poner color naranja (status 3)
            local profs = GearAnalyzer:GetProfessionsList()
            local profDB = GearAnalyzer.ProfessionsDB
            local profInfo = profDB and profDB[enchantID]
            
            if profInfo and profs and profs[profInfo.prof] then
                d[prefix.."enchStatus"] = 3
                d[prefix.."enchTooltip"] = "|cffffa500Profesión:|r " .. curName
            else
                d[prefix.."enchStatus"] = 2
                d[prefix.."enchTooltip"] = "|cff00ff00Correcto:|r " .. curName
            end
        else
            local guideNames = ""
            for i, r in ipairs(recs) do
                guideNames = guideNames .. (i > 1 and " / " or "") .. r.name .. " (ID: "..tostring(r.checkID)..")"
            end
            d[prefix.."enchStatus"] = 0
            d[prefix.."enchTooltip"] = "|cffff0000Incorrecto:|r " .. curName .. " (ID: "..tostring(enchantID)..")\n|cffaaaaaaGuía:|r " .. (guideNames ~= "" and guideNames or "??")
        end
    else
        d[prefix.."enchStatus"] = 0
        d[prefix.."enchTooltip"] = "|cffff0000" .. L["MISSING_TAG"] .. "|r"
    end
end

function GearAnalyzer:EvaluateItem(link)
    if not link then return "NONE", 0 end
    if self.evaluationCache[link] then local c = self.evaluationCache[link]; return c.category, c.iLevel end
    local data = self:GetItemData(link)
    if not data then return "NONE", 0 end
    if data.quality < 2 then self.evaluationCache[link] = { category = "NEUTRAL", iLevel = data.iLevel }; return "NEUTRAL", data.iLevel end
    
    local currentSpec = self:GetCurrentSpecEnhanced()
    local class = self:GetClassToken()
    local normSpec = self:NormalizeSpecName(currentSpec)
    local classData = self.ClassData[class]
    local specInfo = classData and classData.Caps and classData.Caps[normSpec]
    local role = specInfo and specInfo.role or "Melee"

    local hasSpellStats = (data.stats.spellpower > 0 or data.stats.spirit > 0 or data.stats.mp5 > 0)
    local hasMeleeBaseStats = (data.stats.strength > 0 or data.stats.agility > 0 or data.stats.arp > 0 or data.stats.attackpower > 0)
    local category = "NEUTRAL"

    -- Hardcoded Blacklists por Rol (Usando IDs de NaerItemCheck)
    local itemID = tonumber(link:match("item:(%d+)"))
    local isTankItem, isMeleeItem, isCasterItem, isHealItem = false, false, false, false
    if itemID then
        local tankItems = {
            [50341]=true, [50344]=true, [50349]=true, [50352]=true, [50353]=true, [50356]=true, 
            [50361]=true, [50364]=true, [50366]=true, [54591]=true, [50348]=true, [47735]=true,
            [47080]=true, [47451]=true, [47113]=true, [50642]=true, [49988]=true, [51856]=true, 
            [50800]=true, [50663]=true, [50011]=true, [50710]=true, [50170]=true
        }
        local meleeItems = {
            [50362]=true, [50363]=true, [50342]=true, [50343]=true, [50351]=true, [50706]=true, 
            [50355]=true, [47115]=true, [47131]=true, [47088]=true, [47464]=true, [50603]=true, 
            [50672]=true, [50737]=true, [50412]=true, [50012]=true
        }
        local casterItems = {
            [50348]=true, [50353]=true, [50360]=true, [50365]=true, [50340]=true, [50345]=true, 
            [50347]=true, [47073]=true, [47182]=true, [47188]=true, [47477]=true, [50339]=true
        }
        local healItems = {
            [50359]=true, [50366]=true, [50339]=true, [50346]=true, [50358]=true, [50357]=true,
            [47041]=true, [47059]=true, [47271]=true, [47432]=true
        }
        isTankItem = tankItems[itemID]
        isMeleeItem = meleeItems[itemID]
        isCasterItem = casterItems[itemID]
        isHealItem = healItems[itemID]
    end

    local isMainArmor = data.equipSlot:find("HEAD") or data.equipSlot:find("SHOULDER") or data.equipSlot:find("CHEST") or data.equipSlot:find("WRIST") or data.equipSlot:find("HAND") or data.equipSlot:find("WAIST") or data.equipSlot:find("LEGS") or data.equipSlot:find("FEET")
    if isMainArmor and (class == "DEATHKNIGHT" or class == "WARRIOR" or class == "PALADIN") then
        local sub = (data.subclass or ""):lower()
        local itemIDNum = itemID or tonumber(link:match("item:(%d+)"))
        local isWrongArmor = sub:find("tela") or sub:find("cuero") or sub:find("malla") or sub:find("cloth") or sub:find("leather") or sub:find("mail")
        if isWrongArmor or itemIDNum == 50449 then self.evaluationCache[link] = { category = "INCORRECT", iLevel = data.iLevel }; return "INCORRECT", data.iLevel end
        if not (sub:find("placa") or sub:find("plate")) and sub ~= "" then self.evaluationCache[link] = { category = "INCORRECT", iLevel = data.iLevel }; return "INCORRECT", data.iLevel end
    end

    if data.isShield then 
        if role == "Tank" or class == "PALADIN" or class == "SHAMAN" or class == "WARRIOR" then category = "VALID" else category = "INCORRECT" end
    elseif role == "Healer" then
        if isHealItem then category = "VALID"
        elseif isMeleeItem or isTankItem or isCasterItem then category = "INCORRECT"
        elseif (hasSpellStats or data.name:find("Intelecto")) then category = "VALID" 
        elseif data.hasMeleeStats or data.hasTankStats then category = "INCORRECT" end
    elseif role == "Caster" then
        if isCasterItem then category = "VALID"
        elseif isMeleeItem or isTankItem or isHealItem then category = "INCORRECT"
        elseif (hasSpellStats or data.name:find("Intelecto")) then category = "VALID" 
        elseif data.hasMeleeStats or data.hasTankStats then category = "INCORRECT" end
    elseif role == "Tank" then
        if isTankItem then category = "VALID"
        elseif isCasterItem or isHealItem then category = "INCORRECT"
        elseif hasSpellStats then category = "INCORRECT"
        elseif data.hasTankStats then category = "VALID"
        elseif (data.hasMeleeStats or hasMeleeBaseStats or data.name:find("Fuerza")) then if isMainArmor and not data.hasTankStats then category = "INCORRECT" else category = "VALID" end
        elseif data.name:find("Aguante") then category = "VALID" end
    elseif role == "Melee" then
        if isMeleeItem then category = "VALID"
        elseif isTankItem or isCasterItem or isHealItem then category = "INCORRECT"
        elseif data.hasTankStats then category = "INCORRECT"
        elseif hasSpellStats and not data.hasMeleeStats then category = "INCORRECT"
        elseif data.hasMeleeStats or hasMeleeBaseStats or data.name:find("Fuerza") or data.name:find("Agilidad") then category = "VALID" end
    end
    self.evaluationCache[link] = { category = category, iLevel = data.iLevel }
    return category, data.iLevel
end

function GearAnalyzer:GetGemColorByID(gemID)
    if not gemID or gemID == 0 then return nil end
    local db = self.EnchantMasterDB
    if db and db[gemID] and db[gemID].color then return db[gemID].color end
    local data = self:GetEnchantData(gemID)
    if data and data.color then return data.color end
    local id = tonumber(gemID); if not id then return "unknown" end
    if id == 3621 or id == 3624 or id == 3628 or id == 3623 or id == 3625 or id == 3620 or id == 41376 then return "meta" end
    if id == 3518 or id == 3520 or id == 3519 or id == 3524 or id == 3521 or id == 3525 or id == 3522 or id == 3523 or id == 3732 or id == 3735 or id == 3736 or id == 3742 or id == 3743 or id == 3746 or id == 40111 or id == 40113 or id == 42142 or id == 42144 or id == 42145 then return "red" end
    if id == 3530 or id == 3533 or id == 3531 or id == 3529 or id == 3527 or id == 3737 or id == 3739 or id == 3740 or id == 3741 or id == 40125 or id == 42148 or id == 42146 or id == 40128 or id == 40126 then return "yellow" end
    if id == 3526 or id == 3528 or id == 3738 or id == 40119 or id == 42151 or id == 42147 or id == 40120 then return "blue" end
    if id == 3550 or id == 3548 or id == 3534 or id == 3535 or id == 3538 or id == 3539 or id == 3540 or id == 3549 or id == 3547 or id == 3552 or id == 3559 or id == 3563 or id == 40151 or id == 40152 or id == 40155 or id == 40142 then return "orange" end
    if id == 3536 or id == 3545 or id == 3541 or id == 3544 or id == 3542 or id == 40129 or id == 40133 or id == 40134 then return "purple" end
    if id == 40165 or id == 3532 or id == 40173 then return "green" end
    if id == 3551 or id == 3855 or id == 3879 or id == 3511 or id == 3555 or id == 3626 or id == 49110 then return "prismatic" end
    return "red"
end

function GearAnalyzer:GetGemColor(gid)
    if not gid or gid == 0 then return nil end
    local data = self:GetEnchantData(gid)
    if data and data.color then return data.color end
    local name = data and data.name or ""
    if name:find("Rubí") or name:find("Ruby") then return "red" end
    if name:find("Ámbar") or name:find("Amber") then return "yellow" end
    if name:find("Zafiro") or name:find("Sapphire") or name:find("Circón") or name:find("Zircon") or name:find("Circona") then return "blue" end
    if name:find("Ametrino") or name:find("Ametrine") then return "orange" end
    if name:find("Piedra de terror") or name:find("Dreadstone") then return "purple" end
    if name:find("Ojo de Zul") or name:find("Eye of Zul") then return "green" end
    if name:find("pesadilla") or name:find("Nightmare") then return "prismatic" end
    return "unknown"
end

function GearAnalyzer:GetMetaRequirements(itemLink)
    local data = self:GetItemData(itemLink); return data and data.metaReqs or nil
end

function GearAnalyzer:GetGemWeights(class, spec)
    local weights = { STR = 0, AGI = 0, SP = 0, CRIT = 1.0, HASTE = 1.0, ARP = 0, STA = 0, INT = 0, SPIRIT = 0, AP = 0 }
    local normSpec = self:NormalizeSpecName(spec)
    if class == "DEATHKNIGHT" then
        if normSpec:find("Tanque") then weights.STA = 3.0; weights.STR = 1.0; weights.ARP = 0.5; weights.CRIT = 0.5; weights.HASTE = 0.5; weights.AGI = 0.8; weights.AP = 0.5
        else weights.STR = 2.8; weights.ARP = 2.4; weights.CRIT = 2.0; weights.HASTE = 1.8; weights.AGI = 1.2; weights.AP = 1.0; weights.STA = 1.0 end
        if normSpec == "Sombras" then weights.SP = 1.0; weights.HASTE = 0.98; weights.CRIT = 0.76; weights.SPIRIT = 0.2 
        else weights.SP = 1.0; weights.INT = 0.8; weights.SPIRIT = 0.7; weights.HASTE = 0.6 end
    elseif class == "ROGUE" then
        if normSpec == "Asesinato" then weights.AP = 2.0; weights.AGI = 1.8; weights.HASTE = 1.5; weights.CRIT = 1.2
        else weights.ARP = 2.5; weights.AGI = 2.0; weights.AP = 1.8; weights.CRIT = 1.4; weights.HASTE = 1.3 end
    elseif class == "HUNTER" then
        if normSpec == "Puntería" then weights.ARP = 2.4; weights.AGI = 2.0; weights.CRIT = 1.6; weights.AP = 1.0
        else weights.AGI = 2.2; weights.CRIT = 1.8; weights.HASTE = 1.4; weights.AP = 1.0 end
    else weights.STR = 2.0; weights.AGI = 2.0; weights.SP = 1.0; weights.STA = 1.5; weights.INT = 1.0 end
    return weights
end

function GearAnalyzer:ShouldFollowSocket(class, spec, socketSlots, bonusStat, bonusVal)
    if socketSlots == "meta" then return true end
    if not bonusStat or not bonusVal or bonusVal <= 0 then return false end

    -- Check if it's a caster spec
    local isCaster = false
    local normSpec = self:NormalizeSpecName(spec)
    local uClass = class:upper()
    if uClass == "MAGE" or uClass == "WARLOCK" or (uClass == "PRIEST" and normSpec == "Shadow") or (uClass == "DRUID" and normSpec == "Balance") or (uClass == "SHAMAN" and normSpec == "Elemental") then
        isCaster = true
    end

    -- If caster and the item has a blue socket:
    if isCaster and type(socketSlots) == "table" then
        local hasBlue = false
        for _, color in ipairs(socketSlots) do
            if color == "blue" then
                hasBlue = true
                break
            end
        end
        if hasBlue then
            -- For casters, a blue socket is only worth activating if the socket bonus is extremely high (e.g. >= 9 SP)
            if bonusStat == "SP" and bonusVal < 9 then
                return false
            end
            -- For secondary stats like Haste, Crit, Mp5, Intellect, etc., a blue socket is also not worth it unless high
            if (bonusStat == "HASTE" or bonusStat == "CRIT" or bonusStat == "INT") and bonusVal < 9 then
                return false
            end
        end
    end

    if (bonusStat == "STR" or bonusStat == "AGI" or bonusStat == "SP" or bonusStat == "STA") then return bonusVal >= 5 end
    local weights = self:GetGemWeights(class, spec)
    local primaryStat = "STR"; local maxW = 0
    for k, v in pairs(weights) do if v > maxW then maxW = v; primaryStat = k end end
    local valPure = 20 * (weights[primaryStat] or 1)
    local secondaryStat = (weights.CRIT > weights.HASTE) and "CRIT" or "HASTE"
    local valHybrid = (10 * weights[primaryStat]) + (10 * (weights[secondaryStat] or 1)) + (bonusVal * (weights[bonusStat] or 1))
    return valHybrid >= (valPure - 0.1)
end

function GearAnalyzer:CalculateItemScore(link, class, spec)
    if not link then return 0 end
    class = class or self:GetClassToken(); spec = spec or self:GetCurrentSpecEnhanced()
    self.scoreCache[class] = self.scoreCache[class] or {}; self.scoreCache[class][spec] = self.scoreCache[class][spec] or {}
    if self.scoreCache[class][spec][link] then return self.scoreCache[class][spec][link] end
    local data = self:GetItemData(link); if not data then return 0 end
    local weights = self:GetGemWeights(class, spec); if not weights then return 0 end
    local score = 0
    for stat, val in pairs(data.stats) do
        local weightKey = stat:upper(); if stat == "spellpower" then weightKey = "SP" end; if stat == "attackpower" then weightKey = "AP" end
        score = score + (val * (weights[weightKey] or 0))
    end
    local slots, bText, bVal, bStat = self:GetItemSocketColors(link)
    if slots and #slots > 0 then
        for _, color in ipairs(slots) do
            if color == "meta" then score = score + 100
            elseif color == "red" then score = score + (20 * (weights.STR or weights.AGI or weights.SP or 1))
            elseif color == "yellow" then score = score + (20 * (weights.HASTE or weights.CRIT or 1))
            elseif color == "blue" then score = score + (20 * (weights.STA or weights.SPIRIT or 1)) end
        end
        if bStat and bVal and weights[bStat] then score = score + (bVal * weights[bStat]) end
    end
    local finalScore = math.floor(score * 10) / 10
    self.scoreCache[class][spec][link] = finalScore; return finalScore
end

