-- =========================
-- GearAnalyzer Tab: Config
-- Herramientas de configuracion y automatizacion
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabConfig", "AceTimer-3.0")

function Tab:Update(page, ignoreForced)
    if not page then return end

    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f
        
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -5)
        title:SetText(L["INTERFACE_SETTINGS"])
        GearAnalyzer:ApplyStyle(title, true)
        f.title = title

        -- 1. BOTONES DE MODO DESARROLLADOR
        local devToggle = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        devToggle:SetSize(140, 26)
        devToggle:SetPoint("TOPLEFT", 10, -40)
        devToggle:SetScript("OnClick", function()
            local settings = GearAnalyzer.charDB and GearAnalyzer.charDB.settings
            if not settings then return end
            settings.devMode = not settings.devMode
            print("|cff3fc7ebGearAnalyzer:|r " .. string.format(L["DEV_MODE_TOGGLED"], settings.devMode and "|cff00ff00" .. L["ON"] .. "|r" or "|cffff0000" .. L["OFF"] .. "|r"))
            GearAnalyzer:FullReload()
        end)
        self.devToggle = devToggle
        
        local exportBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        exportBtn:SetSize(140, 26)
        exportBtn:SetPoint("LEFT", devToggle, "RIGHT", 5, 0)
        exportBtn:SetText(L["EXPORT_CHANGES"])
        exportBtn:SetScript("OnClick", function()
            GearAnalyzer:ExportCustomChanges()
        end)
        self.exportBtn = exportBtn

        local showErrBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        showErrBtn:SetSize(100, 26)
        showErrBtn:SetPoint("LEFT", exportBtn, "RIGHT", 5, 0)
        showErrBtn:SetText(L["SHOW_ERRORS"])
        showErrBtn:SetScript("OnClick", function()
            SetCVar("scriptErrors", 1)
            print("|cff3fc7ebGearAnalyzer:|r Script errors ON.")
        end)
        self.showErrBtn = showErrBtn

        local hideErrBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        hideErrBtn:SetSize(100, 26)
        hideErrBtn:SetPoint("LEFT", showErrBtn, "RIGHT", 5, 0)
        hideErrBtn:SetText(L["HIDE_ERRORS"])
        hideErrBtn:SetScript("OnClick", function()
            SetCVar("scriptErrors", 0)
            print("|cff3fc7ebGearAnalyzer:|r Script errors OFF.")
        end)
        self.hideErrBtn = hideErrBtn

        -- BOTON ESCANEO PROFESION
        local scanProfBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        scanProfBtn:SetSize(180, 26)
        scanProfBtn:SetPoint("LEFT", hideErrBtn, "RIGHT", 15, 0)
        scanProfBtn:SetText("|cff00ff00" .. L["SCAN_OPEN_PROF"] .. "|r")
        scanProfBtn:SetScript("OnClick", function()
            GearAnalyzer:ScanProfession()
        end)
        self.scanProfBtn = scanProfBtn
        
        -- BOTON DEBUG GEMAS (SOLO DEV)
        local debugGemsBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        debugGemsBtn:SetSize(140, 26)
        debugGemsBtn:SetPoint("TOPLEFT", devToggle, "BOTTOMLEFT", 0, -100)
        debugGemsBtn:SetText(L["DEBUG_GEMS"])
        debugGemsBtn:SetScript("OnClick", function()
            GearAnalyzer:ShowGemDebugWindow()
        end)
        self.debugGemsBtn = debugGemsBtn

        -- 3. OPCIONES DE INTERFAZ
        local minimapCheck = CreateFrame("CheckButton", "GAMinimapToggle", f, "ChatConfigCheckButtonTemplate")
        minimapCheck:SetPoint("TOPLEFT", devToggle, "BOTTOMLEFT", 0, -15)
        _G[minimapCheck:GetName() .. "Text"]:SetText(L["SHOW_MINIMAP_ICON"])
        minimapCheck:SetScript("OnClick", function(self)
            local settings = GearAnalyzer.charDB and GearAnalyzer.charDB.settings
            if not settings then return end
            settings.minimap = settings.minimap or { hide = false }
            settings.minimap.hide = not self:GetChecked()
            
            local LDBIcon = LibStub("LibDBIcon-1.0", true)
            if LDBIcon then
                if settings.minimap.hide then
                    LDBIcon:Hide("GearAnalyzer")
                else
                    LDBIcon:Show("GearAnalyzer")
                end
            end
        end)
        self.minimapCheck = minimapCheck

        -- 4. AJUSTES DE TAMAÑO (STYLING)
        local fontSlider = CreateFrame("Slider", "GAFontSlider", f, "OptionsSliderTemplate")
        fontSlider:SetPoint("TOPLEFT", minimapCheck, "BOTTOMLEFT", 10, -40)
        fontSlider:SetMinMaxValues(8, 24)
        fontSlider:SetValueStep(1)
        fontSlider:SetWidth(180)
        _G[fontSlider:GetName() .. "Low"]:SetText("8")
        _G[fontSlider:GetName() .. "High"]:SetText("24")
        _G[fontSlider:GetName() .. "Text"]:SetText(L["FONT_SIZE"])
        
        fontSlider:SetScript("OnValueChanged", function(self, value)
            if self.isUpdating then return end
            local settings = GearAnalyzer.db.profile.settings
            settings.fontSize = math.floor(value)
            _G[self:GetName() .. "Text"]:SetText(L["FONT_SIZE"] .. ": " .. settings.fontSize)
            GearAnalyzer:FullReload()
        end)
        self.fontSlider = fontSlider

        local iconSlider = CreateFrame("Slider", "GAIconSlider", f, "OptionsSliderTemplate")
        iconSlider:SetPoint("LEFT", fontSlider, "RIGHT", 40, 0)
        iconSlider:SetMinMaxValues(20, 64)
        iconSlider:SetValueStep(2)
        iconSlider:SetWidth(180)
        _G[iconSlider:GetName() .. "Low"]:SetText("20")
        _G[iconSlider:GetName() .. "High"]:SetText("64")
        _G[iconSlider:GetName() .. "Text"]:SetText(L["ICON_SIZE"])
        
        iconSlider:SetScript("OnValueChanged", function(self, value)
            if self.isUpdating then return end
            local settings = GearAnalyzer.db.profile.settings
            settings.iconSize = math.floor(value)
            _G[self:GetName() .. "Text"]:SetText(L["ICON_SIZE"] .. ": " .. settings.iconSize)
            GearAnalyzer:FullReload()
        end)
        self.iconSlider = iconSlider

        -- 5. BOTÓN DE RESET VISUAL
        local resetStyle = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        resetStyle:SetSize(120, 26)
        resetStyle:SetPoint("LEFT", iconSlider, "RIGHT", 40, 0)
        resetStyle:SetText(L["RESET_VISUAL"])
        resetStyle:SetScript("OnClick", function()
            local settings = GearAnalyzer.db.profile.settings
            settings.fontSize = 12
            settings.iconSize = 32
            if self.fontSlider then self.fontSlider:SetValue(12) end
            if self.iconSlider then self.iconSlider:SetValue(32) end
            print("|cff3fc7ebGearAnalyzer:|r " .. L["VISUAL_RESET_MSG"])
        end)
        self.resetStyle = resetStyle

        -- 6. LANGUAGE SELECTOR
        local langLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        langLabel:SetPoint("TOPLEFT", fontSlider, "BOTTOMLEFT", -10, -30)
        langLabel:SetText(L["LANGUAGE"] .. ":")
        self.langLabel = langLabel

        local langDropdown = CreateFrame("Frame", "GA_LangDropdown", f, "UIDropDownMenuTemplate")
        langDropdown:SetPoint("LEFT", langLabel, "RIGHT", -5, -3)
        UIDropDownMenu_SetWidth(langDropdown, 140)

        UIDropDownMenu_Initialize(langDropdown, function()
            local langs = {
                { name = L["AUTOMATIC"] .. " (" .. GetLocale() .. ")", val = "auto" },
                { name = "English", val = "enUS" },
                { name = "Español", val = "esES" },
            }
            for _, lang in ipairs(langs) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = lang.name
                info.value = lang.val
                info.func = function(s)
                    UIDropDownMenu_SetSelectedValue(langDropdown, s.value)
                    GearAnalyzer.db.profile.settings.language = s.value
                    print("|cff3fc7ebGearAnalyzer:|r " .. L["LANGUAGE_CHANGE_MSG"])
                end
                info.checked = (GearAnalyzer.db.profile.settings.language == lang.val)
                UIDropDownMenu_AddButton(info)
            end
        end)
        self.langDropdown = langDropdown

        -- Reload UI button (needed for language change)
        local reloadBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        reloadBtn:SetSize(100, 22)
        reloadBtn:SetPoint("LEFT", langDropdown, "RIGHT", -10, 3)
        reloadBtn:SetText(L["RELOAD_UI"])
        reloadBtn:SetScript("OnClick", function() ReloadUI() end)
        self.reloadBtn = reloadBtn
    end

    -- Actualizar visibilidad y estado de los botones
    local settings = GearAnalyzer.db.profile.settings
    local global = GearAnalyzer.db.global
    
    if settings then
        -- 1. Visibilidad Modo Dev
        local isDev = settings.devMode
        if self.devToggle then
            if isDev then self.devToggle:Show() else self.devToggle:Hide() end
        end
        if self.exportBtn then
            if isDev then self.exportBtn:Show() else self.exportBtn:Hide() end
        end
        if self.showErrBtn then
            if isDev then self.showErrBtn:Show() else self.showErrBtn:Hide() end
        end
        if self.hideErrBtn then
            if isDev then self.hideErrBtn:Show() else self.hideErrBtn:Hide() end
        end
        if self.scanProfBtn then
            if isDev then self.scanProfBtn:Show() else self.scanProfBtn:Hide() end
        end
        if self.debugGemsBtn then
            if isDev then self.debugGemsBtn:Show() else self.debugGemsBtn:Hide() end
        end
        
        -- El Minimapa SIEMPRE visible
        if self.minimapCheck then self.minimapCheck:Show() end
        
        -- Reposicionar elementos según modo dev
        if isDev then
            -- Modo Dev ON: Botones arriba, minimap abajo de ellos
            if self.devToggle then self.devToggle:SetPoint("TOPLEFT", 10, -40) end
            if self.debugGemsBtn then self.debugGemsBtn:SetPoint("TOPLEFT", self.devToggle, "BOTTOMLEFT", 0, -45) end
            if self.minimapCheck then self.minimapCheck:SetPoint("TOPLEFT", self.debugGemsBtn, "BOTTOMLEFT", 0, -10) end
            if self.fontSlider then self.fontSlider:SetPoint("TOPLEFT", self.minimapCheck, "BOTTOMLEFT", 10, -40) end
            if self.resetStyle then self.resetStyle:SetPoint("LEFT", self.iconSlider, "RIGHT", 40, 0) end
            self.container.title:SetText(L["DEV_SETTINGS_TITLE"])
        else
            -- Modo Dev OFF: Minimap arriba del todo
            if self.minimapCheck then self.minimapCheck:SetPoint("TOPLEFT", 10, -40) end
            if self.fontSlider then self.fontSlider:SetPoint("TOPLEFT", self.minimapCheck, "BOTTOMLEFT", 10, -40) end
            if self.resetStyle then self.resetStyle:SetPoint("LEFT", self.iconSlider, "RIGHT", 40, 0) end
            self.container.title:SetText(L["INTERFACE_SETTINGS"])
        end

        if self.devToggle then
            self.devToggle:SetText(L["DEV_MODE"] .. ": " .. (isDev and "|cff00ff00" .. L["ON"] .. "|r" or "|cffff0000" .. L["OFF"] .. "|r"))
        end
        
        if self.minimapCheck then
            self.minimapCheck:SetChecked(not (settings.minimap and settings.minimap.hide))
        end
        if self.fontSlider then
            self.fontSlider.isUpdating = true
            self.fontSlider:SetValue(settings.fontSize or 12)
            self.fontSlider.isUpdating = false
            _G[self.fontSlider:GetName() .. "Text"]:SetText(L["FONT_SIZE"] .. ": " .. (settings.fontSize or 12))
        end
        if self.iconSlider then
            self.iconSlider.isUpdating = true
            self.iconSlider:SetValue(settings.iconSize or 32)
            self.iconSlider.isUpdating = false
            _G[self.iconSlider:GetName() .. "Text"]:SetText(L["ICON_SIZE"] .. ": " .. (settings.iconSize or 32))
        end
        
        -- Update language dropdown display
        if self.langDropdown then
            local lang = settings.language or "auto"
            local displayNames = { auto = L["AUTOMATIC"], enUS = "English", esES = "Español" }
            UIDropDownMenu_SetSelectedValue(self.langDropdown, lang)
            UIDropDownMenu_SetText(self.langDropdown, displayNames[lang] or lang)
        end
    end
end
