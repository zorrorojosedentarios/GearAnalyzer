-- ============================================================
-- GearAnalyzer_DB_Hook.lua
-- Tooltip BiS hook: muestra en qué fase/spec es BiS un item
-- ============================================================

local eventFrame = CreateFrame("Frame", nil, UIParent)

-- Índice invertido: itemId -> { {class, spec, phase, rank} }
-- Se construye una sola vez en initBisTooltip() para búsquedas O(1)
local GA_BiSIndex = nil

local function BuildBiSIndex()
    GA_BiSIndex = {}
    if not GA_BiSLists or not GA_BiSPhases then return end

    for class, specs in pairs(GA_BiSLists) do
        for spec, phases in pairs(specs) do
            for _, phase in ipairs(GA_BiSPhases) do
                local phaseData = phases[phase]
                if phaseData then
                    for _, itemData in ipairs(phaseData) do
                        if type(itemData) == "table" then
                            for rank, itemId in ipairs(itemData) do
                                if type(itemId) == "number" and itemId > 0 then
                                    if not GA_BiSIndex[itemId] then
                                        GA_BiSIndex[itemId] = {}
                                    end
                                    table.insert(GA_BiSIndex[itemId], {
                                        class = class,
                                        spec  = spec,
                                        phase = phase,
                                        rank  = rank,
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Búsqueda O(1) usando el índice invertido
local function GetBiSPhasesForItem(itemId)
    if not GA_BiSIndex then return nil end
    local entries = GA_BiSIndex[itemId]
    if not entries or #entries == 0 then return nil end
    return entries
end

-- Verifica si un spec está filtrado
local function specFiltered(class_name, spec_name)
    local char = GearAnalyzer.db and GearAnalyzer.db.char
    if not char then return false end

    -- Si el spec está resaltado, nunca filtrar
    local hl = char.highlight_spec
    if hl and hl.spec_name == spec_name and hl.class_name == class_name then
        return false
    end

    if IsAltKeyDown() then return false end

    if char.filter_specs and char.filter_specs[class_name] then
        return not char.filter_specs[class_name][spec_name]
    end
    return false
end

-- Búsqueda lineal en GA_LootSources (sólo para origen del item)
local function containsItem(items, itemId)
    for _, v in pairs(items) do
        if v == itemId then return true end
    end
    return false
end

local DataStore_Inventory = DataStore_Inventory or nil

local function formatInstanceName(instance)
    local tmp = instance:lower()
    if tmp == "the obsidian sanctum (heroic)" then
        return "The Obsidian Sanctum(25)"
    elseif tmp == "the eye of eternity (heroic)" then
        return "The Eye Of Eternity (25)"
    elseif tmp == "naxxramas (heroic)" then
        return "Naxxramas (25)"
    elseif tmp == "ulduar (heroic)" then
        return "Ulduar (25)"
    end
    return instance
end

local function GetItemSource(itemId)
    local source

    if GA_LootSources then
        for zone, bosses in pairs(GA_LootSources) do
            for boss, items in pairs(bosses) do
                if containsItem(items, itemId) then
                    source = "|cFFFFFFFFSource:|r |cFF00FF00[" .. formatInstanceName(zone) .. "] - " .. boss .. "|r"
                    break
                end
            end
            if source then break end
        end
    end

    if not source and DataStore_Inventory and DataStore_Inventory.GetSource then
        local Instance, Boss = DataStore_Inventory:GetSource(itemId)
        if Instance and Boss then
            source = "|cFFFFFFFFSource:|r |cFF00FF00[" .. formatInstanceName(Instance) .. "] - " .. Boss .. "|r"
        end
    end

    return source
end

local ga_groupedCache = {}
local ga_orderCache = {}
local ga_groupPool = {}
local ga_groupPoolIdx = 0

local slotMap = {
    ["INVTYPE_HEAD"] = 1, ["INVTYPE_NECK"] = 2, ["INVTYPE_SHOULDER"] = 3,
    ["INVTYPE_CLOAK"] = 15, ["INVTYPE_CHEST"] = 5, ["INVTYPE_ROBE"] = 5,
    ["INVTYPE_WRIST"] = 9, ["INVTYPE_HAND"] = 10, ["INVTYPE_WAIST"] = 6,
    ["INVTYPE_LEGS"] = 7, ["INVTYPE_FEET"] = 8, ["INVTYPE_FINGER"] = 11,
    ["INVTYPE_TRINKET"] = 13, ["INVTYPE_WEAPON"] = 16, ["INVTYPE_2HWEAPON"] = 16,
    ["INVTYPE_WEAPONMAINHAND"] = 16, ["INVTYPE_WEAPONOFFHAND"] = 17,
    ["INVTYPE_HOLDABLE"] = 17, ["INVTYPE_SHIELD"] = 17,
    ["INVTYPE_RANGED"] = 18, ["INVTYPE_RANGEDRIGHT"] = 18, ["INVTYPE_THROWN"] = 18, ["INVTYPE_RELIC"] = 18
}

local function OnGameTooltipSetItem(tooltip)
    if InCombatLockdown() then return end

    local char = GearAnalyzer.db and GearAnalyzer.db.char
    if char and char.tooltip_with_ctrl and not IsControlKeyDown() then
        return
    end

    local profile = GearAnalyzer.db and GearAnalyzer.db.profile
    if profile and profile.settings and not profile.settings.showTooltipBis then
        return
    end

    local _, link = tooltip:GetItem()
    if not link then return end

    local _, itemId = strsplit(":", link)
    itemId = tonumber(itemId)
    if not itemId then return end

    -- Buscar en índice O(1)
    local entries = GetBiSPhasesForItem(itemId)
    if entries then
        -- Agrupar por class+spec para una línea por combinación
        if not GearAnalyzer.bisTooltipCache then GearAnalyzer.bisTooltipCache = {} end
        if not GearAnalyzer.bisTooltipCache[itemId] then
            GearAnalyzer.bisTooltipCache[itemId] = {}
            if GearAnalyzer._cacheCounts then
                GearAnalyzer._cacheCounts.bis = GearAnalyzer._cacheCounts.bis + 1
                if GearAnalyzer._cacheCounts.bis > 200 then
                    wipe(GearAnalyzer.bisTooltipCache)
                    GearAnalyzer._cacheCounts.bis = 0
                end
            end
            wipe(ga_groupedCache)
            wipe(ga_orderCache)
            ga_groupPoolIdx = 0
            
            for _, e in ipairs(entries) do
                if not specFiltered(e.class, e.spec) then
                    local key = e.class .. "|" .. e.spec
                    if not ga_groupedCache[key] then
                        ga_groupPoolIdx = ga_groupPoolIdx + 1
                        if not ga_groupPool[ga_groupPoolIdx] then
                            ga_groupPool[ga_groupPoolIdx] = { class = "", spec = "", phases = {} }
                        end
                        local grp = ga_groupPool[ga_groupPoolIdx]
                        grp.class = e.class
                        grp.spec = e.spec
                        wipe(grp.phases)
                        
                        ga_groupedCache[key] = grp
                        table.insert(ga_orderCache, key)
                    end
                    local label = e.rank == 1 and (e.phase .. " BiS") or (e.phase .. " Alt" .. e.rank)
                    table.insert(ga_groupedCache[key].phases, label)
                end
            end

            for _, key in ipairs(ga_orderCache) do
                local g = ga_groupedCache[key]
                local icons = GA_SpecIcons and GA_SpecIcons[g.class]
                local icon  = icons and icons[g.spec]
                local iconStr = icon and string.format("|T%s:16|t ", icon) or ""
                local lineText  = iconStr .. g.class .. " - " .. g.spec
                local phaseText = table.concat(g.phases, " / ")
                table.insert(GearAnalyzer.bisTooltipCache[itemId], {left = lineText, right = phaseText})
            end
        end

        for _, line in ipairs(GearAnalyzer.bisTooltipCache[itemId]) do
            tooltip:AddDoubleLine(line.left, line.right, 1, 1, 0, 1, 1, 0)
        end
    end

    -- Origen del item
    local itemSource = GetItemSource(itemId)
    if itemSource then
        tooltip:AddLine(" ", 1, 1, 0)
        tooltip:AddLine(itemSource, 1, 1, 1)
        tooltip:AddLine(" ", 1, 1, 0)
    end

    -- ==========================================
    -- NUEVO: Evaluación de puntuación (Pawn-like)
    -- ==========================================
    local class = GearAnalyzer:GetClassToken()
    local spec  = GearAnalyzer:GetCurrentSpecEnhanced()
    local score = GearAnalyzer:CalculateItemScore(link, class, spec)

    if score > 0 then
        -- Encontrar item equipado en el mismo slot
        local _, _, _, _, _, _, _, _, equipSlot = GetItemInfo(link)
        local invSlot1, invSlot2
        
        invSlot1 = slotMap[equipSlot]
        if equipSlot == "INVTYPE_FINGER" then invSlot2 = 12
        elseif equipSlot == "INVTYPE_TRINKET" then invSlot2 = 14
        end

        local equippedScore = 0
        if invSlot1 then
            local eqLink = GetInventoryItemLink("player", invSlot1)
            if eqLink then
                equippedScore = GearAnalyzer:CalculateItemScore(eqLink, class, spec)
                -- Si hay un segundo slot (anillos/abalorios), comparamos con el peor de los dos
                if invSlot2 then
                    local eqLink2 = GetInventoryItemLink("player", invSlot2)
                    if eqLink2 then
                        local score2 = GearAnalyzer:CalculateItemScore(eqLink2, class, spec)
                        if score2 < equippedScore then equippedScore = score2 end
                    end
                end
            end
        end

        local color = "|cffffffff"
        local upgradeText = ""
        if equippedScore > 0 then
            local diff = score - equippedScore
            local percent = (diff / equippedScore) * 100
            if diff > 0 then
                color = "|cff00ff00"
                upgradeText = string.format(" (+%.1f%%)", percent)
            elseif diff < 0 then
                color = "|cffaaaaaa"
                upgradeText = string.format(" (%.1f%%)", percent)
            end
        end

        tooltip:AddDoubleLine("|cff3fc7ebGearAnalyzer Score:|r", color .. score .. upgradeText)
    end
end

function GearAnalyzer:initBisTooltip()
    -- Construir índice invertido una sola vez al cargar
    BuildBiSIndex()
end

function GearAnalyzer:EnableTooltipHooks()
    if not self.db.profile.settings.showTooltipBis then return end
    
    if not self:IsHooked(GameTooltip, "OnTooltipSetItem") then
        self:SecureHookScript(GameTooltip, "OnTooltipSetItem", "OnGameTooltipSetItem")
    end
    if not self:IsHooked(ItemRefTooltip, "OnTooltipSetItem") then
        self:SecureHookScript(ItemRefTooltip, "OnTooltipSetItem", "OnGameTooltipSetItem")
    end

    -- Refrescar tooltip al presionar ALT (para mostrar/ocultar filtros)
    eventFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
    eventFrame:SetScript("OnEvent", function(_, _, e_key)
        if e_key ~= "RALT" and e_key ~= "LALT" then return end
        local owner = GameTooltip:GetOwner()
        if owner and not owner.hasItem then
            local _, link = GameTooltip:GetItem()
            if link then
                GameTooltip:SetHyperlink(link)
            end
        end
    end)
end

function GearAnalyzer:DisableTooltipHooks()
    if self:IsHooked(GameTooltip, "OnTooltipSetItem") then
        self:Unhook(GameTooltip, "OnTooltipSetItem")
    end
    if self:IsHooked(ItemRefTooltip, "OnTooltipSetItem") then
        self:Unhook(ItemRefTooltip, "OnTooltipSetItem")
    end
    eventFrame:UnregisterEvent("MODIFIER_STATE_CHANGED")
end

function GearAnalyzer:OnGameTooltipSetItem(tooltip)
    if self.inCombat or InCombatLockdown() then return end
    OnGameTooltipSetItem(tooltip)
end

