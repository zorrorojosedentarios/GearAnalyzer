-- ============================================================
-- GearAnalyzer: Utilities & Debug
-- Chat commands, Dev mode, and Exporting
-- ============================================================

function GearAnalyzer:ApplyLanguageOverride()
    local lang = self.db.profile.settings.language
    if not lang or lang == "auto" then return end
    
    local source
    if lang == "enUS" then
        source = GearAnalyzer_Locale_enUS
    elseif lang == "esES" then
        source = GearAnalyzer_Locale_esES
    end
    
    if not source then return end
    
    local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer", true)
    if L then
        for k, v in pairs(source) do
            rawset(L, k, v)
        end
    end
end

function GearAnalyzer:ToggleDevMode()
    local settings = self.db.profile.settings
    settings.devMode = not settings.devMode
    self:Print("Modo Desarrollador " .. (settings.devMode and "|cff00ff00ACTIVADO|r" or "|cffff0000DESACTIVADO|r"))
    
    if settings.devMode then
        if not self:IsHooked(GameTooltip, "OnTooltipSetItem") then
            self:SecureHookScript(GameTooltip, "OnTooltipSetItem", "OnTooltipSetItem")
        end
    else
        if self:IsHooked(GameTooltip, "OnTooltipSetItem") then
            self:Unhook(GameTooltip, "OnTooltipSetItem")
        end
    end

    self:FullReload()
end

function GearAnalyzer:DebugTranslation()
    local global = self.db.global
    local translated = global.ServerTranslatedDB
    local scan = global.ServerDatabase and global.ServerDatabase.enchantMappings
    
    local scanCount = 0
    if scan then for _ in pairs(scan) do scanCount = scanCount + 1 end end
    local tCount = 0
    if translated then for _ in pairs(translated) do tCount = tCount + 1 end end
    
    print("|cff00ff00=== GearAnalyzer Debug ===|r")
    print("Scan: " .. scanCount .. " | Traducidos: " .. tCount)
    
    local check = {
        {id=3345, label="Cuchilla de Hielo (internet)", slot="INVTYPE_WEAPON"},
        {id=3370, label="Cruzado Caido (internet)", slot="INVTYPE_WEAPON"},
        {id=3367, label="Gargola Piel Piedra (internet)", slot="INVTYPE_WEAPON"},
        {id=3847, label="Nerubian (internet)", slot="INVTYPE_HEAD"},
        {id=3852, label="Inscripcion Hacha (internet)", slot="INVTYPE_SHOULDER"},
        {id=3853, label="Inscripcion Pinaculo (internet)", slot="INVTYPE_SHOULDER"},
    }
    for _, e in ipairs(check) do
        local serverID = self:GetEffectiveEnchantID(e.id, e.slot)
        if serverID ~= e.id then
            print(string.format("|cff00ff00  [OK]|r %s: %d -> %d", e.label, e.id, serverID))
        else
            print(string.format("|cffffff00  [=]|r %s: %d (sin traducir)", e.label, e.id))
        end
    end
end

function GearAnalyzer:TestSpecDetection()
    local talentSpec = self:GetCurrentSpec()
    local gearSpec = self:DetectSpecFromGear()
    local enhancedSpec = self:GetCurrentSpecEnhanced()
    
    print("|cff00ff00=== GearAnalyzer: Detección de Especialización ===|r")
    print("|cffFFFF00Por Talentos:|r " .. (talentSpec or "Desconocido"))
    print("|cff00CCFFPor Equipo:|r " .. (gearSpec or "No detectado"))
    print("|cff00FF00Resultado Final:|r " .. (enhancedSpec or "Error"))
    print("|cff888888Usa /gaspec para ver esta información|r")
end

function GearAnalyzer:ExportCustomChanges()
    local text = "-- GEARANALYZER OVERRIDES EXPORT (NaerZone Structure) --\n"
    text = text .. "-- Comparte este texto para reportar IDs corregidos --\n\n"
    text = text .. "Overrides = {\n"
    
    local categories = {"caps", "gems", "enchants", "glyphs"}
    
    for _, cat in ipairs(categories) do
        local items = self.db.global.customOverrides[cat]
        if items and next(items) then
            text = text .. "  [\"" .. cat .. "\"] = {\n"
            local keys = {}
            for k in pairs(items) do table.insert(keys, k) end
            table.sort(keys)
            
            for _, k in ipairs(keys) do
                local v = items[k]
                local comment = ""
                if cat == "enchants" then
                    local spec, slotKey = k:match("^(.-)_(.*)$")
                    comment = " -- Spec: " .. (spec or "??") .. " | Slot: " .. (slotKey or "??")
                elseif cat == "gems" then
                    local name = GetItemInfo(k) or ("ID: " .. k)
                    comment = " -- " .. name
                elseif cat == "caps" then
                    comment = " -- Stat: " .. (k or "unknown")
                end
                text = text .. "    [\"" .. k .. "\"] = " .. tostring(v) .. "," .. comment .. "\n"
            end
            text = text .. "  },\n"
        end
    end
    text = text .. "}"

    if not self.exportFrame then
        local f = CreateFrame("Frame", "GAExportFrame", UIParent)
        f:SetSize(600, 450)
        f:SetPoint("CENTER")
        f:SetFrameLevel(60)
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left=8, right=8, top=8, bottom=8 }
        })
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -20)
        title:SetText("Exportar Cambios Personalizados")
        
        local scroll = CreateFrame("ScrollFrame", "GAExportScroll", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 20, -50)
        scroll:SetPoint("BOTTOMRIGHT", -35, 60)
        
        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetSize(scroll:GetWidth(), 500)
        edit:SetMultiLine(true)
        edit:SetAutoFocus(false)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(530)
        scroll:SetScrollChild(edit)
        f.edit = edit
        
        local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        close:SetSize(100, 30)
        close:SetPoint("BOTTOMRIGHT", -20, 20)
        close:SetText("Cerrar")
        close:SetScript("OnClick", function() f:Hide() end)
        
        local resetBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        resetBtn:SetSize(120, 30)
        resetBtn:SetPoint("BOTTOMLEFT", 20, 20)
        resetBtn:SetText("|cffff0000Borrar Todo|r")
        resetBtn:SetScript("OnClick", function()
            StaticPopup_Show("GA_CONFIRM_RESET_ALL")
        end)
        
        StaticPopupDialogs["GA_CONFIRM_RESET_ALL"] = {
            text = "¿Estás seguro de que quieres borrar TODOS tus cambios manuales?",
            button1 = "Sí, borrar",
            button2 = "No",
            OnAccept = function()
                self.db.global.customOverrides = { enchants={}, gems={}, glyphs={}, caps={} }
                GearAnalyzer:FullReload()
                f:Hide()
            end,
            timeout = 0,
            whileDead = true,
        }
        self.exportFrame = f
    end
    
    self.exportFrame.edit:SetText(text)
    self.exportFrame.edit:HighlightText()
    self.exportFrame:Show()
end

function GearAnalyzer:ChatHandler(input)
    local arg1 = self:GetArgs(input, 1)
    if not arg1 or arg1 == "" then
        self:ToggleUI()
    else
        arg1 = arg1:lower()
        if arg1 == "dev" then
            self:ToggleDevMode()
            -- Solo abrimos la UI si no estaba abierta, pero sin llamar a ToggleUI dos veces
            if not (self.frame and self.frame:IsShown()) then 
                self:ToggleUI() 
            end
            local UI = self:GetModule("UI", true)
            if UI then UI:SelectTab(10) end -- Tab 10 es Configuración en el nuevo Core
        elseif arg1 == "scan" then
            self:StartJewelScan()
        elseif arg1 == "prof" then
            self:ScanProfession()
        elseif arg1 == "help" then
            self:Print("Comandos: /ga, /ga dev, /ga scan, /ga prof, /ga ver")
        elseif arg1 == "ver" or arg1 == "version" then
            self:VersionCheck()
        else
            self:ToggleUI()
        end
    end
end

function GearAnalyzer:VersionCheck()
    local channel = nil
    if IsInRaid() then
        channel = "RAID"
    elseif GetNumPartyMembers() > 0 then
        channel = "PARTY"
    end

    if not channel then
        self:Print("No estás en un grupo o banda.")
        return
    end

    self:Print("Iniciando chequeo de versión en " .. channel .. "...")
    self.versionResults = {}
    SendAddonMessage("GearAnalyzer", "VER_QUERY", channel)

    -- Esperar 3 segundos para recolectar respuestas
    self:ScheduleTimer(function()
        self:Print("--- Resultados de Versión (GearAnalyzer) ---")
        local members = {}
        if IsInRaid() then
            for i = 1, GetNumRaidMembers() do
                local name = GetRaidRosterInfo(i)
                if name then table.insert(members, name) end
            end
        else
            table.insert(members, UnitName("player"))
            for i = 1, GetNumPartyMembers() do
                local name = UnitName("party" .. i)
                if name then table.insert(members, name) end
            end
        end

        local count = 0
        local results = {}
        for _, name in ipairs(members) do
            if name == UnitName("player") then
                table.insert(results, string.format("|cff00ff00%s|r: %s (Tú)", name, self.version or "Unknown"))
                count = count + 1
            elseif self.versionResults[name] then
                table.insert(results, string.format("|cff00ff00%s|r: %s", name, self.versionResults[name]))
                count = count + 1
            else
                table.insert(results, string.format("|cffff0000%s|r: No instalado", name))
            end
        end

        -- Ordenar resultados alfabéticamente
        table.sort(results)
        for _, res in ipairs(results) do
            print(res)
        end
        
        self:Print("Chequeo finalizado. " .. count .. " jugadores con el addon.")
        self.versionResults = nil
    end, 3)
end
