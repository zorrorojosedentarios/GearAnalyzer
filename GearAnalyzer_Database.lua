-- ============================================================
-- GearAnalyzer: Database & Enchant Management
-- Mappings, Reverse Lookups, and Server Sync handling
-- ============================================================

-- MOTOR DE BASE DE DATOS UNIFICADA (Single Source of Truth)
function GearAnalyzer:GetEnchantInfo(id)
    if not id or id == 0 then return nil end
    local searchID = tonumber(id)
    
    -- 1. Buscar en el mapping activo (ServerTranslatedDB tiene prioridad)
    local db = self.db.global.ServerTranslatedDB
    if db and db[searchID] then
        return db[searchID], searchID
    end

    -- 2. Búsqueda por Reverse Lookup (ItemID / SpellID / OriginalID -> ServerID)
    if not self.reverseEnchantLookup then self:UpdateReverseLookup() end
    local foundServerID = self.reverseEnchantLookup[searchID]
    
    if foundServerID then
        if db and db[foundServerID] then
            return db[foundServerID], foundServerID
        elseif self.EnchantMasterDB[foundServerID] then
            return self.EnchantMasterDB[foundServerID], foundServerID
        end
    end

    -- 3. Fallback: Búsqueda directa en MasterDB si el ID es la clave
    if self.EnchantMasterDB and self.EnchantMasterDB[searchID] then
        return self.EnchantMasterDB[searchID], searchID
    end
    
    return nil
end

function GearAnalyzer:GetItemIDFromEnchant(id)
    if not id or id == 0 then return nil end
    local data, _ = self:GetEnchantInfo(id)
    return data and data.item or nil
end

function GearAnalyzer:UpdateReverseLookup()
    self.reverseEnchantLookup = {}
    local db = self.EnchantMasterDB
    if not db then return end
    
    for serverID, data in pairs(db) do
        if data.originalID then self.reverseEnchantLookup[tonumber(data.originalID)] = serverID end
        if data.spell then self.reverseEnchantLookup[tonumber(data.spell)] = serverID end
        if data.item then self.reverseEnchantLookup[tonumber(data.item)] = serverID end
        if data.guideID then self.reverseEnchantLookup[tonumber(data.guideID)] = serverID end
        if data.guideID2 then self.reverseEnchantLookup[tonumber(data.guideID2)] = serverID end
    end
end

function GearAnalyzer:GetEnchantData(id)
    local data, _ = self:GetEnchantInfo(id)
    if data and not data.localizedName then
        local fetchedName = nil
        if data.item then
            fetchedName = GetItemInfo(data.item)
        elseif data.spell then
            fetchedName = GetSpellInfo(data.spell)
        end
        
        if fetchedName and fetchedName ~= "" then
            data.name = fetchedName
            data.localizedName = true
        elseif not data.item and not data.spell then
            data.localizedName = true
        end
    end
    return data
end

function GearAnalyzer:GetEffectiveEnchantID(id, slot)
    if not id or id == 0 then return 0 end
    local searchID = tonumber(id)

    local data, serverID = self:GetEnchantInfo(searchID)
    if data and serverID then
        local dataSlot = data.slot
        local match = not slot or not dataSlot or dataSlot == slot
        
        if not match and slot and dataSlot then
            if (slot == "ring1" or slot == "ring2") and dataSlot == "finger" then match = true end
        end

        if match then
            return serverID
        end
    end
    
    return searchID
end

function GearAnalyzer:BuildActiveMapping()
    self.identityCache = nil
    
    local translated = {}
    local matchCount = 0
    local scanData = self.db.global.ServerDatabase and self.db.global.ServerDatabase.enchantMappings
    
    if self.EnchantMasterDB then
        for serverID, data in pairs(self.EnchantMasterDB) do
            local entry = {}
            for k, v in pairs(data) do entry[k] = v end
            
            entry.serverID = serverID
            entry.originalID = data.originalID or serverID
            
            translated[serverID] = entry
            matchCount = matchCount + 1
        end
    end

    if scanData and next(scanData) ~= nil then
        for serverID, scanEntry in pairs(scanData) do
            if translated[serverID] then
                translated[serverID].stats = scanEntry.text or translated[serverID].stats
                translated[serverID].name = scanEntry.name or translated[serverID].name
            else
                translated[serverID] = {
                    name = scanEntry.name,
                    serverID = serverID,
                    originalID = serverID,
                    stats = scanEntry.text,
                    slot = scanEntry.slot
                }
                matchCount = matchCount + 1
            end
        end
    end

    self.db.global.ServerTranslatedDB = translated
    self.EnchantMapping = translated
    self:UpdateReverseLookup()
end
