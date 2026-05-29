-- GearAnalyzer Scan & Extraction
-- Caches and equipment/tooltip data extraction
-- ============================================================
GearAnalyzer.scannedEquipment = GearAnalyzer.scannedEquipment or {}
GearAnalyzer.itemDataCache = {}
GearAnalyzer.socketColorsCache = {}
GearAnalyzer.evaluationCache = {}
GearAnalyzer.scoreCache = {}


local SLOT_ORDER = {
    { id = 1,  name = "SLOT_HEAD", slotID = 1 },
    { id = 2,  name = "SLOT_NECK", slotID = 2 },
    { id = 3,  name = "SLOT_SHOULDERS", slotID = 3 },
    { id = 5,  name = "SLOT_CHEST", slotID = 5 },
    { id = 6,  name = "SLOT_WAIST", slotID = 6 },
    { id = 7,  name = "SLOT_LEGS", slotID = 7 },
    { id = 8,  name = "SLOT_FEET", slotID = 8 },
    { id = 9,  name = "SLOT_WRISTS", slotID = 9 },
    { id = 10, name = "SLOT_HANDS", slotID = 10 },
    { id = 11, name = "SLOT_RING", slotID = 11 },
    { id = 12, name = "SLOT_RING", slotID = 12 }, -- Ring 2 using same key
    { id = 13, name = "SLOT_TRINKET", slotID = 13 },
    { id = 14, name = "SLOT_TRINKET", slotID = 14 }, -- Trinket 2
    { id = 15, name = "SLOT_BACK", slotID = 15 },
    { id = 16, name = "SLOT_WEAPON", slotID = 16 },
    { id = 17, name = "SLOT_OFFHAND", slotID = 17 },
    { id = 18, name = "SLOT_RELIC", slotID = 18 },
}

function GearAnalyzer:ScanEquipment()
    self.scannedEquipment = self.scannedEquipment or {}

    -- Cache de links: omitir rescan si el equipo no cambió
    local linksChanged = false
    if not self._equipLinkCache then
        self._equipLinkCache = {}
        linksChanged = true
    elseif self._equipLinkCacheDirty then
        linksChanged = true
        self._equipLinkCacheDirty = nil
    else
        for _, slot in ipairs(SLOT_ORDER) do
            local link = GetInventoryItemLink("player", slot.id)
            if self._equipLinkCache[slot.id] ~= link then
                linksChanged = true
                break
            end
        end
    end
    if not linksChanged then return end

    wipe(self.scannedEquipment)

    for _, slot in ipairs(SLOT_ORDER) do
        local itemLink = GetInventoryItemLink("player", slot.id)
        self._equipLinkCache[slot.id] = itemLink

        local d = {
            slotName = slot.name,
            slotID = slot.slotID,
            itemLink = itemLink,
            itemID = nil,
            gems = {},
            enchant = "0",
            isBIS = false,
            gemsOK = true,
            enchantOK = true,
        }

        if itemLink then
            local itemStr = string.match(itemLink, "item:([%d:%-]+)")
            if itemStr then
                local parts = { strsplit(":", itemStr) }
                d.itemID  = tonumber(parts[1])
                d.enchant = parts[2] or "0"

                d.allGemSlots = {}
                for i = 3, 6 do
                    table.insert(d.allGemSlots, tonumber(parts[i]) or 0)
                end

                for _, gid in ipairs(d.allGemSlots) do
                    if gid > 0 then
                        table.insert(d.gems, gid)
                    end
                end
                if d.enchant == "0" or d.enchant == "" then
                    if slot.name == "SLOT_WAIST" then
                        for i = 3, 6 do
                            if tonumber(parts[i]) and tonumber(parts[i]) > 0 then
                                d.enchant = "3731"
                                break
                            end
                        end
                    end

                    local checkSlots = { SLOT_HANDS=true, SLOT_BACK=true, SLOT_FEET=true, SLOT_WRISTS=true, SLOT_SHOULDERS=true }
                    if checkSlots[slot.name] then
                        local tooltip = self.scanner or _G["GA_ScanTooltipFallback"]
                        if tooltip then
                            tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
                            tooltip:SetHyperlink(itemLink)
                            for j = 1, tooltip:NumLines() do
                                local lineText = _G[tooltip:GetName().."TextLeft"..j]:GetText()
                                if lineText then
                                    local lt = lineText:lower()
                                    if lt:find("aceleradores") or lt:find("nitro boosts") then d.enchant = "3604"; break
                                    elseif lt:find("nitro") and lt:find("boots") then d.enchant = "3855"; break
                                    elseif lt:find("tela flexible") or lt:find("paraca") or lt:find("flexweave") then d.enchant = "3830"; break
                                    elseif lt:find("tejido de luz") or lt:find("lightweave") then d.enchant = "3722"; break
                                    elseif lt:find("resplandor oscuro") or lt:find("darkglow") then d.enchant = "3728"; break
                                    elseif lt:find("guardia de espada") or lt:find("swordguard") then d.enchant = "3730"; break
                                    elseif lt:find("forro de pelaje") or lt:find("fur lining") then 
                                        if lt:find("ataque") or lt:find("attack") then d.enchant = "3850"
                                        elseif lt:find("hechizos") or lt:find("spell") then d.enchant = "3851"
                                        elseif lt:find("aguante") or lt:find("stamina") then d.enchant = "3757"
                                        end
                                        break
                                    elseif (lt:find("inscripci") and lt:find("maestro")) or lt:find("master") then
                                        if lt:find("hacha") or lt:find("axe") then d.enchant = "3835"
                                        elseif lt:find("tormenta") or lt:find("storm") then d.enchant = "3836"
                                        elseif lt:find("pin") or lt:find("pinnacle") then d.enchant = "3837"
                                        elseif lt:find("risco") or lt:find("crag") then d.enchant = "3838"
                                        end
                                        break
                                    end
                                end
                            end
                            tooltip:Hide()
                        end
                    end
                end
            end
        end

        table.insert(self.scannedEquipment, d)
    end
end

function GearAnalyzer:GetItemData(link)
    if not link then return nil end
    local itemKey = link:match("item:([%d:-]+)")
    if itemKey and self.itemDataCache[itemKey] then return self.itemDataCache[itemKey] end
    local name, _, quality, iLevel, _, _, subclass, _, equipSlot = GetItemInfo(link)
    if not name then return nil end
    local data = {
        name = name, quality = quality, iLevel = iLevel or 0, subclass = subclass or "", equipSlot = equipSlot or "",
        stats = { spellpower = 0, haste = 0, mp5 = 0, spirit = 0, strength = 0, agility = 0, attackpower = 0, stamina = 0, intellect = 0, crit = 0, hit = 0, expertise = 0, arp = 0, armor = 0, dodge = 0, parry = 0, block = 0, defense = 0 },
        hasTankStats = false, hasMeleeStats = false, isShield = (subclass and (subclass:find("Escudo") or subclass:find("Shield"))),
        metaReqs = { red = 0, yellow = 0, blue = 0, moreRedThanYellow = false },
        setName = nil, setCount = 0, setMax = 0, hasSetInfo = false,
    }
    local tooltip = self.scanner
    if not tooltip then
        local fb = _G["GA_ScanTooltipFallback"]
        if not fb then fb = CreateFrame("GameTooltip", "GA_ScanTooltipFallback", nil, "GameTooltipTemplate"); fb:SetOwner(WorldFrame, "ANCHOR_NONE") end
        tooltip = fb
    end
    tooltip:ClearLines(); tooltip:SetHyperlink(link)
    for i = 1, tooltip:NumLines() do
        local line = _G[tooltip:GetName().."TextLeft"..i]
        local text = line and line:GetText()
        if text then
            local ltext = text:lower()
            local v = tonumber(text:match("(%d+)"))
            if v and GearAnalyzer.LocaleStatPatterns then
                for pattern, statKey in pairs(GearAnalyzer.LocaleStatPatterns) do
                    if ltext:find(pattern, 1, true) then if data.stats[statKey] ~= nil then data.stats[statKey] = data.stats[statKey] + v; break end end
                end
                if ltext:find("cada 5") or ltext:find("5 sec") then data.stats.mp5 = data.stats.mp5 + v end
            end
            if GearAnalyzer.TextHasTankStat and GearAnalyzer:TextHasTankStat(ltext) then data.hasTankStats = true end
            if GearAnalyzer.TextHasMeleeStat and GearAnalyzer:TextHasMeleeStat(ltext) then data.hasMeleeStats = true end
            if ltext:find("requiere") or ltext:find("requires") then
                local function ExtractReqColorWords(txt, colorKey)
                    if not GearAnalyzer.LocaleSocketWords or not GearAnalyzer.LocaleSocketWords[colorKey] then return nil end
                    for _, w in ipairs(GearAnalyzer.LocaleSocketWords[colorKey]) do
                        if w ~= "" then
                            local m = txt:match("(%d+)%s+gemas?%s+" .. w) or txt:match("(%d+)%s+" .. w .. "%s+gems?") or txt:match(w .. ".-(%d+)")
                            if m then return m end
                        end
                    end
                    return nil
                end
                local nBlue = ExtractReqColorWords(ltext, "blue"); if nBlue then data.metaReqs.blue = tonumber(nBlue) end
                local nRed = ExtractReqColorWords(ltext, "red"); if nRed then data.metaReqs.red = tonumber(nRed) end
                local nYellow = ExtractReqColorWords(ltext, "yellow"); if nYellow then data.metaReqs.yellow = tonumber(nYellow) end
                if ltext:find("más.*que.*amarill") or ltext:find("more.*than.*yellow") then data.metaReqs.moreRedThanYellow = true end
            end
            local sName, cur, max = text:match("^(.+) %((%d+)/(%d+)%)$")
            if sName and cur and max then data.setName = sName; data.setCount = tonumber(cur); data.setMax = tonumber(max); data.hasSetInfo = true end
        end
    end
    if itemKey and tooltip:NumLines() >= 2 then
        self.itemDataCache[itemKey] = data
    end
    return data
end

-- Formato de item limpio pre-compilado para evitar string concat en GetItemSocketColors
local CLEAN_ITEM_FMT = "item:%d:0:0:0:0:0:0:0:0:0"

-- Patrón de bonificación de ranura pre-compilado
local SOCKET_BONUS_PATTERN = (function()
    if ITEM_SOCKET_BONUS then
        return ITEM_SOCKET_BONUS:gsub("%%s", "(.+)")
    end
    return "Bono de ranura: (.+)"
end)()

function GearAnalyzer:GetItemSocketColors(itemLink)
    if not itemLink then return {}, nil, 0 end
    local itemID = tonumber(itemLink:match("item:(%d+)"))
    if not itemID then return {}, nil, 0 end
    if self.socketColorsCache[itemID] then
        local c = self.socketColorsCache[itemID]
        return c.slots, c.bonusText, c.bonusVal, c.bonusStat
    end
    local cleanLink = CLEAN_ITEM_FMT:format(itemID)
    local tooltip = GearAnalyzer.scanner
    tooltip:SetOwner(WorldFrame, "ANCHOR_NONE"); tooltip:ClearLines(); tooltip:SetHyperlink(cleanLink)
    local info = { slots = {}, bonusText = nil, bonusVal = 0, bonusStat = nil }
    local tooltipName = tooltip:GetName()
    local linesCount = tooltip:NumLines()
    for i = 1, linesCount do
        local line = _G[tooltipName.."TextLeft"..i]
        local text = line and line:GetText()
        if text then
            local ltext = text:gsub("|c%x%x%x%x%x%x%x%x|r", ""):gsub("|[cHr][%x%x]-|h?.-|h", ""):gsub("|r", ""):lower()
            if (ltext:find("ranura") or ltext:find("socket") or ltext:find("emplacement")) then
                if ltext:find("meta") then table.insert(info.slots, "meta")
                elseif ltext:find("roja") or ltext:find("red") or ltext:find("rouge") then table.insert(info.slots, "red")
                elseif ltext:find("amarilla") or ltext:find("yellow") or ltext:find("jaune") then table.insert(info.slots, "yellow")
                elseif ltext:find("azul") or ltext:find("blue") or ltext:find("bleu") then table.insert(info.slots, "blue")
                end
            end
            local bMatch = text:match(SOCKET_BONUS_PATTERN)
            if bMatch then
                info.bonusText = bMatch
                local v = bMatch:match("%+(%d+)"); if v then info.bonusVal = tonumber(v) end
                local lbonus = bMatch:lower()
                local bStatMap = { spellpower="SP", strength="STR", intellect="INT", stamina="STA", haste="HASTE", crit="CRIT", agility="AGI" }
                if GearAnalyzer.LocaleStatPatterns then
                    for pattern, statKey in pairs(GearAnalyzer.LocaleStatPatterns) do
                        if lbonus:find(pattern, 1, true) and bStatMap[statKey] then info.bonusStat = bStatMap[statKey]; break end
                    end
                end
                if not info.bonusStat then
                    if lbonus:find("hechizos") or lbonus:find("spell") then info.bonusStat = "SP"
                    elseif lbonus:find("fuerza") or lbonus:find("strength") then info.bonusStat = "STR"
                    elseif lbonus:find("intelecto") or lbonus:find("intellect") then info.bonusStat = "INT"
                    elseif lbonus:find("aguante") or lbonus:find("stamina") then info.bonusStat = "STA"
                    elseif lbonus:find("celeridad") or lbonus:find("haste") then info.bonusStat = "HASTE"
                    elseif lbonus:find("crítico") or lbonus:find("crit") then info.bonusStat = "CRIT"
                    elseif lbonus:find("agilidad") or lbonus:find("agility") then info.bonusStat = "AGI"
                    end
                end
            end
        end
    end
    tooltip:Hide()
    if linesCount > 1 then self.socketColorsCache[itemID] = { slots = info.slots, bonusText = info.bonusText, bonusVal = info.bonusVal, bonusStat = info.bonusStat } end
    return info.slots, info.bonusText, info.bonusVal, info.bonusStat
end

function GearAnalyzer:GetAllSlots()
    return self.scannedEquipment
end

function GearAnalyzer:GetSetBonusCount(itemLink)
    local data = self:GetItemData(itemLink)
    if not data or not data.hasSetInfo then return nil, 0, 0 end
    return data.setName, data.setCount, data.setMax
end

-- ============================================================
-- Inventory scanner (standalone fallback, backport de Codia)
-- ============================================================
GearAnalyzer.inventoryItems = GearAnalyzer.inventoryItems or {}
GearAnalyzer.inventoryScanning = false
GearAnalyzer.inventoryScanQueued = false

local function InventoryProcessBag(self, bagID, isBank)
    local numSlots = GetContainerNumSlots(bagID)
    if numSlots and numSlots > 0 then
        for slotID = 1, numSlots do
            local itemLink = GetContainerItemLink(bagID, slotID)
            if itemLink then
                local _, _, _, iLevel, _, _, _, _, equipSlot = GetItemInfo(itemLink)
                if equipSlot and equipSlot ~= "" then
                    if not self.inventoryItems[equipSlot] then self.inventoryItems[equipSlot] = {} end
                    local category, lvl = self:EvaluateItem(itemLink)
                    table.insert(self.inventoryItems[equipSlot], {
                        link = itemLink,
                        bag = bagID,
                        slot = slotID,
                        isBank = isBank,
                        iLevel = lvl or iLevel or 0,
                        category = category or "NEUTRAL",
                    })
                end
            end
        end
    end
end

function GearAnalyzer:ScanBagsAndBank()
    local Rec = self:GetModule("Recommender", true)
    if Rec then Rec:ScanBagsAndBank(); return end

    if self.inventoryScanning then
        self.inventoryScanQueued = true
        return
    end
    self.inventoryScanning = true
    wipe(self.inventoryItems)

    self:ScheduleTimer(function()
        for bagID = 0, 4 do InventoryProcessBag(self, bagID, false) end
    end, 0.1)

    self:ScheduleTimer(function()
        local bankCache = self.db.char.bankCache or {}
        if self.isBankOpen then
            wipe(bankCache)
            InventoryProcessBag(self, -1, true)
            for bagID = 5, 11 do InventoryProcessBag(self, bagID, true) end
            self.db.char.bankCache = bankCache
        end
        for equipSlot, items in pairs(bankCache) do
            self.inventoryItems[equipSlot] = self.inventoryItems[equipSlot] or {}
            for _, item in ipairs(items) do
                table.insert(self.inventoryItems[equipSlot], item)
            end
        end
    end, 0.3)

    self:ScheduleTimer(function()
        self.inventoryScanning = false
        if self.inventoryScanQueued then
            self.inventoryScanQueued = false
            self:ScanBagsAndBank()
        end
    end, 0.5)
end

function GearAnalyzer:HasItem(checkID)
    if not checkID then return false end

    local Rec = self:GetModule("Recommender", true)
    if Rec then return Rec:HasItem(checkID) end

    local checkIDnum = tonumber(checkID)
    if self.scannedEquipment then
        for _, eq in ipairs(self.scannedEquipment) do
            if eq.itemLink then
                local linkID = tonumber(eq.itemLink:match("item:(%d+)"))
                if linkID == checkIDnum then return true end
            end
        end
    end

    for _, items in pairs(self.inventoryItems) do
        for _, item in ipairs(items) do
            if item.link then
                local linkID = tonumber(item.link:match("item:(%d+)"))
                if linkID == checkIDnum then return true end
            end
        end
    end
    return false
end

function GearAnalyzer:GetBestItemInBags(slotName, slotID, currentItemLink, top6)
    local invType = self:GetINVTYPE(slotName, slotID)
    if not invType or not self.inventoryItems then return nil end

    local curCategory, curLevel = self:EvaluateItem(currentItemLink)
    local currentRank = 99
    if top6 and currentItemLink then
        for r, id in ipairs(top6) do
            if self:ItemLinkHasID(currentItemLink, id) then currentRank = r; break end
        end
    end

    local searchTypes = { invType }
    if invType == "INVTYPE_WEAPON" or invType == "INVTYPE_WEAPONMAINHAND" then
        table.insert(searchTypes, "INVTYPE_2HWEAPON")
    elseif invType == "INVTYPE_2HWEAPON" then
        table.insert(searchTypes, "INVTYPE_WEAPON"); table.insert(searchTypes, "INVTYPE_WEAPONMAINHAND")
    elseif invType == "INVTYPE_WEAPONOFFHAND" then
        table.insert(searchTypes, "INVTYPE_WEAPON"); table.insert(searchTypes, "INVTYPE_SHIELD"); table.insert(searchTypes, "INVTYPE_HOLDABLE")
    end

    local bestInvRank = currentRank
    local bestInvLvl = curLevel or 0
    local bestItem = nil

    for _, t in ipairs(searchTypes) do
        if self.inventoryItems[t] then
            for _, invItem in ipairs(self.inventoryItems[t]) do
                local invRank = 99
                if top6 then
                    for r, id in ipairs(top6) do
                        if self:ItemLinkHasID(invItem.link, id) then invRank = r; break end
                    end
                end
                local invCategory = invItem.category
                if invRank < 99 or invCategory == curCategory or invCategory == "VALID" then
                    local betterThanEquipped = false
                    if invRank < currentRank then
                        betterThanEquipped = true
                    elseif currentRank == 99 and invRank == 99 then
                        local eqScore = self:CalculateItemScore(currentItemLink)
                        local inScore = self:CalculateItemScore(invItem.link)
                        if inScore > eqScore then
                            betterThanEquipped = true
                        end
                    end
                    
                    if betterThanEquipped then
                        local isPreferable = false
                        if invRank < bestInvRank then
                            isPreferable = true
                        elseif invRank == bestInvRank and invRank == 99 then
                            local bestScore = bestItem and self:CalculateItemScore(bestItem.link) or 0
                            local inScore = self:CalculateItemScore(invItem.link)
                            if inScore > bestScore then
                                isPreferable = true
                            elseif inScore == bestScore then
                                if not invItem.isBank and (not bestItem or bestItem.isBank) then
                                    isPreferable = true
                                end
                            end
                        elseif invRank == bestInvRank and (invItem.iLevel or 0) > bestInvLvl then
                            isPreferable = true
                        end
                        
                        if isPreferable then
                            bestInvRank = invRank; bestInvLvl = invItem.iLevel or 0; bestItem = invItem
                        end
                    end
                end
            end
        end
    end
    return bestItem
end

