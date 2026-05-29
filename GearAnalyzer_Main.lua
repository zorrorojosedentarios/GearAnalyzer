-- =========================
-- GearAnalyzer (Ace3 Core)
-- =========================
GearAnalyzer = LibStub("AceAddon-3.0"):NewAddon("GearAnalyzer", "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0",
    "AceHook-3.0")
GearAnalyzer.version = "v3.5"

GA_BiSLists = {
    ["DEATHKNIGHT"] = {},
    ["DRUID"] = {},
    ["HUNTER"] = {},
    ["MAGE"] = {},
    ["PALADIN"] = {},
    ["PRIEST"] = {},
    ["ROGUE"] = {},
    ["SHAMAN"] = {},
    ["WARRIOR"] = {},
    ["WARLOCK"] = {}
}
GA_BiSPhases = { "PR", "T9", "T10", "RS" }

local defaults = {
    char = {
        bankCache = {},
        playerName = nil,
        highlight_spec = { class_name = nil, spec_name = nil },
        filter_specs = {},
        filter_class_names = false,
        tooltip_with_ctrl = false,
    },
    profile = {
        specs = {},
        bis = {},
        custom_bis = {},
        top6 = {},
        phase = "T10",
        guidePhase = "T10",
        settings = {
            autoScan = true,
            showTooltipSpec = true,
            showTooltipBis = true,
            minimap = { hide = false },
            fontSize = 12,
            iconSize = 32,
            forcedClass = "DEATHKNIGHT",
            forcedSpec = "Blood Tank",
            devMode = false,
            language = "auto",
        },
        gamePhase = "T10",
    },
    global = {
        customOverrides = { enchants = {}, gems = {}, glyphs = {}, caps = {} },
        EnchantDatabase = { _version = 0 },
        ServerDatabase = { enchantMappings = {} },
        ServerTranslatedDB = {},
        serverCache = {}
    }
}

GearAnalyzer.scannedEquipment = GearAnalyzer.scannedEquipment or {}
GearAnalyzer.ClassData = {}
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")

GearAnalyzer.StatTrans = {
    ["HIT"] = L["STAT_HIT"] or "Índice de Golpe",
    ["HIT_SPELL"] = L["STAT_HIT_SPELL"] or "Golpe (Hechizos)",
    ["EXPERTISE"] = L["STAT_EXPERTISE"] or "Pericia",
    ["ARP"] = L["STAT_ARP"] or "Pen. Armadura",
    ["ArPen"] = L["STAT_ARP"] or "Pen. Armadura",
    ["ARPEN"] = L["STAT_ARP"] or "Pen. Armadura",
    ["HASTE"] = L["STAT_HASTE"] or "Celeridad",
    ["CRIT"] = L["STAT_CRIT"] or "Crítico",
    ["SP"] = L["STAT_SP"] or "Poder de Hechizos",
    ["STA"] = L["STAT_STA"] or "Aguante",
    ["AGI"] = L["STAT_AGI"] or "Agilidad",
    ["STR"] = L["STAT_STR"] or "Fuerza",
    ["INT"] = L["STAT_INT"] or "Intelecto",
    ["SPIRIT"] = L["STAT_SPIRIT"] or "Espíritu",
    ["DEF"] = L["STAT_DEF"] or "Defensa",
    ["DEFENSE"] = L["STAT_DEF"] or "Defensa",
    ["ARMOR"] = L["STAT_ARMOR"] or "Armadura",
    ["DODGE"] = L["STAT_DODGE"] or "Esquiva",
    ["PARRY"] = L["STAT_PARRY"] or "Parada",
    ["AP"] = L["STAT_AP"] or "Poder de Ataque",
    ["RAP"] = L["STAT_RAP"] or "P. Ataque Rango",
}

function GearAnalyzer:GetItemInfoFallback(id)
    if not id then return nil end
    local name = GetItemInfo(id)
    if name then return name end

    if not self.ScannerTooltip then
        self.ScannerTooltip = CreateFrame("GameTooltip", "GAScannerTooltip", UIParent, "GameTooltipTemplate")
        self.ScannerTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    end

    self.ScannerTooltip:ClearLines()
    self.ScannerTooltip:SetHyperlink("item:" .. id .. ":0:0:0:0:0:0:0")

    local fontString = _G["GAScannerTooltipTextLeft1"]
    if fontString then
        local text = fontString:GetText()
        if text and text ~= "" and text ~= "Recuperando información del objeto" and text ~= "Retrieving item information" then
            return text
        end
    end

    return nil
end

function GearAnalyzer.SafeL(key)
    if not key or key == "" or key == "AUTO" or key == "None" then
        if key == "AUTO" then return "Automático" end
        if key == "None" then return "Ninguna" end
        return ""
    end
    local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer", true)
    if L then
        local val = rawget(L, key)
        if val then return val end
    end
    return tostring(key)
end

GearAnalyzer._cacheCounts = { item = 0, bis = 0, eval = 0, score = 0 }

function GearAnalyzer:OnInitialize()
    local scanner = CreateFrame("GameTooltip", "GearAnalyzerScanner", nil, "GameTooltipTemplate")
    scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
    self.scanner = scanner

    self.db = LibStub("AceDB-3.0"):New("GearAnalyzerDB", defaults)

    -- [LAZY LOADING] Metatabla para cargar datos de clase automáticamente bajo demanda
    setmetatable(self.ClassData, {
        __index = function(t, classTag)
            if type(classTag) == "string" then
                return self:LoadClassData(classTag)
            end
            return nil
        end
    })

    -- Anuncio de inicialización ligera
    print("|cff3fc7eb[GearAnalyzer]|r " .. self.version .. " core iniciado. Escribe /ga para abrir.")

    local name = UnitName("player")
    if self.db.char.playerName ~= name then
        self.db.char.playerName = name
        self.db.char.bankCache = {}
    end

    local BZ = LibStub("LibBabble-Zone-3.0", true)
    if BZ then
        local es = BZ:GetUnstrictLookupTable("esMX") or BZ:GetUnstrictLookupTable("esES")
        if es and not es["The Ruby Sanctum"] then es["The Ruby Sanctum"] = "El Sagrario Rubí" end
    end

    self:RegisterChatCommand("ga", "ChatHandler")
    self:RegisterChatCommand("gag", "ToggleGuide")
    self:RegisterChatCommand("gadev", "ToggleDevMode")
    self:RegisterChatCommand("gascan", "StartJewelScan")
    self:RegisterChatCommand("gaprof", "ScanProfession")
    self:RegisterChatCommand("gadebug", "DebugTranslation")
    self:RegisterChatCommand("gaspec", "TestSpecDetection")

    self:SetupMinimapButton()
    self.lastHandledSpec = nil
    if self.evaluationCache then wipe(self.evaluationCache) end

    if self.initBisTooltip then self:initBisTooltip() end

    -- Registrar prefijo para comunicación entre jugadores
    if RegisterAddonMessagePrefix then
        RegisterAddonMessagePrefix("GearAnalyzer")
    end
end

function GearAnalyzer:OnEnable()
    self:InitializeAddonData()
    self:BuildActiveMapping()

    if IsLoggedIn() then
        self:PLAYER_LOGIN("PLAYER_LOGIN")
    else
        self:RegisterEvent("PLAYER_LOGIN")
    end

    self:RegisterEvent("BANKFRAME_OPENED", "OnBankOpened")
    self:RegisterEvent("BANKFRAME_CLOSED", "OnBankClosed")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnCombatEnter")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnCombatLeave")
    self:RegisterEvent("GET_ITEM_INFO_RECEIVED", "OnItemInfoReceived")
    self:RegisterEvent("CHAT_MSG_ADDON", "OnAddonMessage")

    -- Talent events registered globally so spec caching is always invalidated on changes
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "OnTalentChanged")
    self:RegisterEvent("PLAYER_TALENT_UPDATE", "OnTalentChanged")
    self:RegisterEvent("CHARACTER_POINTS_CHANGED", "OnTalentChanged")
    self:RegisterEvent("GLYPH_UPDATED", "OnTalentChanged")
    self:RegisterEvent("GLYPH_ADDED", "OnTalentChanged")
end

function GearAnalyzer:InitializeAddonData()
    local global = self.db.global
    local profile = self.db.profile

    if global.customOverrides.enchants then
        local stale = {}
        for key, val in pairs(global.customOverrides.enchants) do
            if not tonumber(val) and type(val) ~= "boolean" then table.insert(stale, key) end
        end
        for _, key in ipairs(stale) do global.customOverrides.enchants[key] = nil end
    end

    local MASTER_DB_VERSION = 22
    if (global.EnchantDatabase._version or 0) ~= MASTER_DB_VERSION then
        wipe(global.EnchantDatabase)
        global.EnchantDatabase._version = MASTER_DB_VERSION
        if global.ServerDatabase and global.ServerDatabase.enchantMappings then
            wipe(global.ServerDatabase.enchantMappings)
        end
        if self.EnchantMasterDB then
            for id, data in pairs(self.EnchantMasterDB) do
                local entry = {}
                for k, v in pairs(data) do entry[k] = v end
                entry.originalID = id
                global.EnchantDatabase[id] = entry
            end
        end
    end
    self.charDB = profile
    self.lastHandledSpec = nil
    self.lastSpec = nil
    if self.evaluationCache then wipe(self.evaluationCache) end
end

function GearAnalyzer:LoadClassData(classTag)
    if not classTag then return end
    if rawget(self.ClassData, classTag) then return rawget(self.ClassData, classTag) end

    -- Reentrancy guard: prevent recursive calls for the same class while loading
    self._loadingClass = self._loadingClass or {}
    if self._loadingClass[classTag] then return nil end
    self._loadingClass[classTag] = true

    local loaders = {
        ["DEATHKNIGHT"] = self.LoadDeathKnightData,
        ["DRUID"] = self.LoadDruidData,
        ["HUNTER"] = self.LoadHunterData,
        ["MAGE"] = self.LoadMageData,
        ["PALADIN"] = self.LoadPaladinData,
        ["PRIEST"] = self.LoadPriestData,
        ["ROGUE"] = self.LoadRogueData,
        ["SHAMAN"] = self.LoadShamanData,
        ["WARLOCK"] = self.LoadWarlockData,
        ["WARRIOR"] = self.LoadWarriorData,
    }
    local loader = loaders[classTag]
    if loader then
        loader(self)
    end

    self._loadingClass[classTag] = nil -- Release guard

    if rawget(self.ClassData, classTag) then
        print("|cff3fc7eb[GearAnalyzer]|r Módulo de datos: |cffffff00" .. classTag .. "|r cargado en memoria.")
    end

    self:WarmupClassData(classTag)
    return rawget(self.ClassData, classTag)
end

function GearAnalyzer:WarmupClassData(classTag)
    local data = rawget(self.ClassData, classTag) -- rawget avoids __index trigger
    if not data then return end

    self:ScheduleTimer(function()
        local function Request(id)
            if not id or id == 0 then return end
            -- Triple petición para asegurar que el servidor responda
            GetItemInfo(id)
            GetItemInfo("item:" .. id)
            -- Crear un link falso para forzar al cliente a pedirlo
            local link = string.format("|Hitem:%d:0:0:0:0:0:0:0|h[Item]|h", id)
            GetItemInfo(link)
        end

        -- Gemas
        if data.Gems then
            for _, gems in pairs(data.Gems) do
                Request(gems.meta); Request(gems.red); Request(gems.yellow); Request(gems.blue)
            end
        end
        -- Glifos
        if data.Glyphs then
            for _, glyphs in pairs(data.Glyphs) do
                for _, id in ipairs(glyphs.major or {}) do Request(id) end
                for _, id in ipairs(glyphs.minor or {}) do Request(id) end
            end
        end
    end, 0.1)
end

function GearAnalyzer:StartJewelScan()
    if not self.RunUnifiedScan then return end
    self:RunUnifiedScan(1, 52000, "JOYERIA")
end

function GearAnalyzer:ScanProfession()
    if self.ScanProfessionWindow then self:ScanProfessionWindow() end
end

function GearAnalyzer:OnBankOpened()
    self.isBankOpen = true
    self:ScanBagsAndBank()
end

function GearAnalyzer:OnBankClosed()
    self.isBankOpen = false
end

function GearAnalyzer:ToggleUI()
    local UI = self:GetModule("UI", true)
    if UI then UI:TogglePJ() end
end

function GearAnalyzer:ToggleGuide()
    local UI = self:GetModule("UI", true)
    if UI then UI:ToggleGuide() end
end

function GearAnalyzer:RegisterHeavyEvents()
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "OnGearChanged")
    self:RegisterEvent("BAG_UPDATE_DELAYED", "OnGearChanged")
    self:RegisterEvent("SOCKET_INFO_UPDATE", "OnGearChanged")
end

function GearAnalyzer:UnregisterHeavyEvents()
    self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
    self:UnregisterEvent("BAG_UPDATE_DELAYED")
    self:UnregisterEvent("SOCKET_INFO_UPDATE")
end

function GearAnalyzer:OnStatsChanged()
    if self.inCombat or InCombatLockdown() then return end
    if self.statsTimer then self:CancelTimer(self.statsTimer) end
    self.statsTimer = self:ScheduleTimer(function()
        if (self.frame and self.frame:IsShown()) or (self.guideFrame and self.guideFrame:IsShown()) then
            local UI = self:GetModule("UI", true)
            if UI then UI:Update() end
        end
    end, 0.5)
end

function GearAnalyzer:OnItemInfoReceived()
    if (self.frame and self.frame:IsShown()) or (self.guideFrame and self.guideFrame:IsShown()) then
        if self.itemInfoTimer then self:CancelTimer(self.itemInfoTimer) end
        self.itemInfoTimer = self:ScheduleTimer(function()
            local UI = self:GetModule("UI", true)
            if UI then UI:Update() end
        end, 0.5)
    end
end

function GearAnalyzer:ApplyStyle(fontString, isTitle)
    if not fontString then return end
    local font, size, flags = fontString:GetFont()
    local targetSize = self.db.profile.settings.fontSize or 12
    if isTitle then targetSize = targetSize + 2 end
    fontString:SetFont(font, targetSize, flags)
end

function GearAnalyzer:After(delay, func)
    self:ScheduleTimer(func, delay)
end

function GearAnalyzer:OnAddonMessage(event, prefix, msg, channel, sender)
    if prefix ~= "GearAnalyzer" then return end
    if sender == UnitName("player") then return end

    if msg == "VER_QUERY" then
        local response = "VER_RESPONSE:" .. (self.version or "Unknown")
        SendAddonMessage("GearAnalyzer", response, channel)
    elseif msg:find("^VER_RESPONSE:") then
        local ver = msg:sub(14)
        if self.versionResults then
            self.versionResults[sender] = ver
        end
    end
end
