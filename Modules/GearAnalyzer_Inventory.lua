-- =========================
-- GearAnalyzer Module: Inventory & Recommendations
-- Logic to find better items in bags/bank
-- WoW 3.3.5
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Rec = GearAnalyzer:NewModule("Recommender", "AceEvent-3.0")

function Rec:OnInitialize()
    self.inventoryItems = {}
    self.recommendations = {}
end

function Rec:OnEnable()
    -- Register events if needed
end

function Rec:UpdateRecommendations(activeBiS)
    local now = GetTime()
    self.lastUpdate = now

    self:ScanBagsAndBank()
    wipe(self.recommendations)
    
    if not GearAnalyzer.scannedEquipment then return end
    
    local usedInventory = {}
    local pairAssignments = {}
    local class = GearAnalyzer:GetClassToken()
    local spec = GearAnalyzer:GetCurrentSpecEnhanced()
    
    local bisData = activeBiS and activeBiS.bis
    local top6Data = activeBiS and activeBiS.top6
    local checkPairs = { ["ring1"]="ring2", ["ring2"]="ring1", ["trinket1"]="trinket2", ["trinket2"]="trinket1" }

    for _, d in ipairs(GearAnalyzer.scannedEquipment) do
        local slotKey = GearAnalyzer:GetSlotKey(d.slotName, d.slotID)
        local top6 = slotKey and top6Data and top6Data[slotKey]
        local pairKey = checkPairs[slotKey]
        
        local best = self:GetBestItemForSlot(d.slotName, d.slotID, d.itemLink, top6, pairKey, pairAssignments, usedInventory)
        if best then
            self.recommendations[slotKey] = best
            usedInventory[best.bag .. ":" .. best.slot] = true
        end
    end
end

function Rec:GetRecommendation(slotKey)
    return self.recommendations[slotKey]
end

-------------------------------------------------
-- [REC-SCAN] Escanear Bolsas y Banco
-------------------------------------------------
function Rec:ScanBagsAndBank()
    wipe(self.inventoryItems)

    -- 1. Bolsas del Personaje (0 a 4)
    for bagID = 0, 4 do
        local numSlots = GetContainerNumSlots(bagID)
        if numSlots > 0 then
            for slotID = 1, numSlots do
                local itemLink = GetContainerItemLink(bagID, slotID)
                if itemLink then
                    local _, _, _, iLevel, _, _, _, _, equipSlot = GetItemInfo(itemLink)
                    if equipSlot and equipSlot ~= "" then
                        if not self.inventoryItems[equipSlot] then self.inventoryItems[equipSlot] = {} end
                        local category, lvl = GearAnalyzer:EvaluateItem(itemLink)
                        table.insert(self.inventoryItems[equipSlot], {
                            link = itemLink, bag = bagID, slot = slotID, isBank = false, iLevel = lvl, category = category
                        })
                    end
                end
            end
        end
    end

    -- 2. Escaneo de Banco
    local bankCache = GearAnalyzer.db.char.bankCache or {}
    
    if GearAnalyzer.isBankOpen then
        wipe(bankCache)
        
        -- SCAN BANCO PRINCIPAL
        local bankSlots = GetContainerNumSlots(-1)
        for slotID = 1, bankSlots do
            local itemLink = GetContainerItemLink(-1, slotID)
            if itemLink then
                local _, _, _, lvl, _, _, _, _, equipSlot = GetItemInfo(itemLink)
                if equipSlot and equipSlot ~= "" then
                    local category = GearAnalyzer:EvaluateItem(itemLink)
                    bankCache[equipSlot] = bankCache[equipSlot] or {}
                    table.insert(bankCache[equipSlot], {
                        link = itemLink, bag = -1, slot = slotID, isBank = true, iLevel = lvl, category = category
                    })
                end
            end
        end

        -- SCAN BOLSAS DEL BANCO
        for bagID = 5, 11 do
            local numSlots = GetContainerNumSlots(bagID)
            for slotID = 1, numSlots do
                local itemLink = GetContainerItemLink(bagID, slotID)
                if itemLink then
                    local _, _, _, lvl, _, _, _, _, equipSlot = GetItemInfo(itemLink)
                    if equipSlot and equipSlot ~= "" then
                        local category = GearAnalyzer:EvaluateItem(itemLink)
                        bankCache[equipSlot] = bankCache[equipSlot] or {}
                        table.insert(bankCache[equipSlot], {
                            link = itemLink, bag = bagID, slot = slotID, isBank = true, iLevel = lvl, category = category
                        })
                    end
                end
            end
        end
        GearAnalyzer.db.char.bankCache = bankCache
    end

    for equipSlot, items in pairs(bankCache) do
        self.inventoryItems[equipSlot] = self.inventoryItems[equipSlot] or {}
        for _, item in ipairs(items) do
            local category = GearAnalyzer:EvaluateItem(item.link)
            table.insert(self.inventoryItems[equipSlot], {
                link = item.link, bag = item.bag, slot = item.slot, isBank = item.isBank, iLevel = item.iLevel, category = category
            })
        end
    end
end

-------------------------------------------------
-- [REC-LOGIC] Encontrar el mejor item para un slot
-------------------------------------------------
function Rec:GetBestItemForSlot(slotName, slotID, currentItemLink, top6, pairKey, pairAssignments, usedInventory)
    local invType = GearAnalyzer:GetINVTYPE(slotName, slotID)
    if not invType or not self.inventoryItems then return nil end

    local curCategory, curLevel = GearAnalyzer:EvaluateItem(currentItemLink)
    local currentRank = 99
    if top6 and currentItemLink then
        for r, id in ipairs(top6) do
            if GearAnalyzer:ItemLinkHasID(currentItemLink, id) then currentRank = r; break end
        end
    end

    -- Mapeo de tipos compatibles (Bidireccional)
    local searchTypes = { invType }
    if invType == "INVTYPE_WEAPON" or invType == "INVTYPE_WEAPONMAINHAND" then
        table.insert(searchTypes, "INVTYPE_2HWEAPON")
    elseif invType == "INVTYPE_2HWEAPON" then
        table.insert(searchTypes, "INVTYPE_WEAPON")
        table.insert(searchTypes, "INVTYPE_WEAPONMAINHAND")
    elseif invType == "INVTYPE_WEAPONOFFHAND" then
        table.insert(searchTypes, "INVTYPE_WEAPON")
        table.insert(searchTypes, "INVTYPE_SHIELD")
        table.insert(searchTypes, "INVTYPE_HOLDABLE")
    elseif invType == "INVTYPE_RANGED" or invType == "INVTYPE_RANGEDRIGHT" or invType == "INVTYPE_THROWN" then
        table.insert(searchTypes, "INVTYPE_RANGED")
        table.insert(searchTypes, "INVTYPE_THROWN")
        table.insert(searchTypes, "INVTYPE_RANGEDRIGHT")
    end

    local bestInvRank = currentRank
    local bestInvLvl = curLevel or 0
    local bestItem = nil

    for _, t in ipairs(searchTypes) do
        if self.inventoryItems[t] then
            for _, invItem in ipairs(self.inventoryItems[t]) do
                local itemUID = invItem.bag .. ":" .. invItem.slot
                if not usedInventory[itemUID] then
                    local invRank = 99
                    if top6 then
                        for r, id in ipairs(top6) do
                            if GearAnalyzer:ItemLinkHasID(invItem.link, id) then invRank = r; break end
                        end
                    end

                    local invCategory = invItem.category
                    if invRank < 99 or invCategory == curCategory or invCategory == "VALID" then                        local betterThanEquipped = false
                        if invRank < currentRank then
                            betterThanEquipped = true
                        elseif currentRank == 99 and invRank == 99 then
                            local eqScore = GearAnalyzer:CalculateItemScore(currentItemLink)
                            local inScore = GearAnalyzer:CalculateItemScore(invItem.link)
                            if inScore > eqScore then
                                betterThanEquipped = true
                            end
                        end

                        if betterThanEquipped then
                            -- Evitar duplicados en anillos/abalorios
                            local isDuplicate = false
                            if pairKey then
                                for _, otherD in ipairs(GearAnalyzer.scannedEquipment) do
                                    if GearAnalyzer:GetSlotKey(otherD.slotName, otherD.slotID) == pairKey then
                                        if GearAnalyzer:ItemLinkHasID(invItem.link, tonumber(otherD.itemLink:match("item:(%d+)"))) then
                                            isDuplicate = true
                                        end
                                    end
                                end
                            end

                            if not isDuplicate then
                                local isPreferable = false
                                if invRank < bestInvRank then
                                    isPreferable = true
                                elseif invRank == bestInvRank and invRank == 99 then
                                    local bestScore = bestItem and GearAnalyzer:CalculateItemScore(bestItem.link) or 0
                                    local inScore = GearAnalyzer:CalculateItemScore(invItem.link)
                                    if inScore > bestScore then
                                        isPreferable = true
                                    elseif inScore == bestScore then
                                        if not invItem.isBank and (not bestItem or bestItem.isBank) then
                                            isPreferable = true
                                        end
                                    end
                                elseif invRank == bestInvRank and (invItem.iLevel or 0) > bestInvLvl then
                                    isPreferable = true
                                elseif invRank == bestInvRank and (invItem.iLevel or 0) == bestInvLvl then
                                    if not invItem.isBank and (not bestItem or bestItem.isBank) then
                                        isPreferable = true
                                    end
                                end

                                if isPreferable then
                                    bestInvRank = invRank
                                    bestInvLvl = invItem.iLevel or 0
                                    bestItem = invItem
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return bestItem
end

function Rec:HasItem(checkID)
    if not checkID then return false end
    checkID = tonumber(checkID)
    
    -- Revisar equipo actual
    if GearAnalyzer.scannedEquipment then
        for _, eq in ipairs(GearAnalyzer.scannedEquipment) do
            if eq.itemLink then
                local linkID = eq.itemLink:match("item:(%d+)")
                if tonumber(linkID) == checkID then return true end
            end
        end
    end
    
    -- Revisar bolsas y banco
    if self.inventoryItems then
        for _, items in pairs(self.inventoryItems) do
            for _, item in ipairs(items) do
                if item.link then
                    local linkID = item.link:match("item:(%d+)")
                    if tonumber(linkID) == checkID then return true end
                end
            end
        end
    end
    
    return false
end
