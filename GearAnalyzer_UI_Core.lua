-- ============================================================
-- GearAnalyzer UI: Core (REESTRUCTURACIÓN INTEGRAL DEFINITIVA)
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local UI = GearAnalyzer:NewModule("UI", "AceEvent-3.0")

local function SafeL(key)
    if GearAnalyzer.SafeL then return GearAnalyzer.SafeL(key) end
    return key or ""
end

UI.tabsPJ = { "TAB_EQUIPMENT", "TAB_GEMS", "TAB_ENCHANTS", "TAB_GLYPHS", "TAB_TALENTS", "TAB_CAPS", "TAB_BIS", "TAB_EXPORT", "TAB_INFO", "TAB_CONFIG" }
UI.modulesPJ = { "TabEquipo", "TabGemas", "TabEncantamientos", "TabGlifos", "TabTalentos", "TabCaps", "TabBiSTops", "TabExportarIA", "TabInfo", "TabConfig" }

UI.tabsGuide = { "TAB_GENERAL", "TAB_ENCHANTS", "TAB_TALENTS", "TAB_BIS" }
UI.modulesGuide = { "TabGeneralGuide", "TabEncantamientosGuide", "TabTalentosGuide", "TabBiSTopsGuide" }

function UI:OnInitialize()
    self.pages = { PJ = {}, Guide = {} }
end

local function ApplyFrameStyle(f, titleText)
    f:SetSize(800, 580)
    f:SetPoint("CENTER", UIParent, "CENTER")
    f:SetBackdrop({
        bgFile = nil,
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    f:SetMovable(true); f:EnableMouse(true); f:SetClampedToScreen(true)

    -- Imagen de fondo
    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\AddOns\\GearAnalyzer\\fondo.tga")
    bg:SetAllPoints(f)
    bg:SetVertexColor(0.5, 0.5, 0.5, 0.95) -- Brillo al 50% para que se distinga el arte de fondo manteniendo legibilidad
    f.bgTexture = bg
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText(titleText)
    
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 0, 0)
end

function UI:CreateMainFrame()
    if GearAnalyzer.frame then return GearAnalyzer.frame end
    local f = CreateFrame("Frame", "GearAnalyzerFrame", UIParent)
    f:Hide()
    ApplyFrameStyle(f, "GearAnalyzer (PJ)")
    tinsert(UISpecialFrames, "GearAnalyzerFrame")
    GearAnalyzer.frame = f

    f:SetScript("OnShow", function()
        GearAnalyzer:RegisterHeavyEvents()
    end)
    f:SetScript("OnHide", function()
        GearAnalyzer:UnregisterHeavyEvents()
    end)

    local btnGuide = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btnGuide:SetSize(110, 24); btnGuide:SetPoint("TOPLEFT", 20, -12); btnGuide:SetText(L["OPEN_GUIDE"] or "Abrir Guía")
    btnGuide:SetScript("OnClick", function() UI:ToggleGuide() end)

    for i, key in ipairs(UI.tabsPJ) do
        local tab = CreateFrame("Button", "GearAnalyzerFrameTab"..i, f, "CharacterFrameTabButtonTemplate")
        tab:SetID(i); tab:SetText(SafeL(key))
        if i == 1 then tab:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 5, 10) -- Subido para evitar que se pierdan
        else tab:SetPoint("LEFT", _G["GearAnalyzerFrameTab"..(i-1)], "RIGHT", -15, 0) end
        tab:SetScript("OnClick", function() UI:SelectTab(i, "PJ") end)
        
        local page = CreateFrame("Frame", nil, f)
        page:SetPoint("TOPLEFT", 20, -60); page:SetPoint("BOTTOMRIGHT", -20, 5); page:Hide()
        
        if i == 1 then
            local scroll = CreateFrame("ScrollFrame", "GABainScroll_v2", page, "UIPanelScrollFrameTemplate")
            scroll:SetPoint("TOPLEFT", 5, -5); scroll:SetPoint("BOTTOMRIGHT", -9, 10)
            local content = CreateFrame("Frame", nil, scroll)
            content:SetSize(725, 500)
            scroll:SetScrollChild(content)
        end
        UI.pages.PJ[i] = page
    end
    PanelTemplates_SetNumTabs(f, #UI.tabsPJ)
    return f
end

function UI:CreateGuideFrame()
    if GearAnalyzer.guideFrame then return GearAnalyzer.guideFrame end
    
    -- Ensure we don't start with "AUTO" in the Guide window
    if GearAnalyzer.db.profile.settings.forcedClass == "AUTO" or not GearAnalyzer.db.profile.settings.forcedClass then
        GearAnalyzer.db.profile.settings.forcedClass = "DEATHKNIGHT"
    end
    if GearAnalyzer.db.profile.settings.forcedSpec == "AUTO" or not GearAnalyzer.db.profile.settings.forcedSpec then
        GearAnalyzer.db.profile.settings.forcedSpec = "Blood Tank"
    end

    local f = CreateFrame("Frame", "GearAnalyzerGuideFrame", UIParent)
    f:Hide()
    ApplyFrameStyle(f, "GearAnalyzer (Guía)")
    tinsert(UISpecialFrames, "GearAnalyzerGuideFrame")
    GearAnalyzer.guideFrame = f

    f:SetScript("OnShow", function()
        GearAnalyzer:RegisterHeavyEvents()
    end)
    f:SetScript("OnHide", function()
        GearAnalyzer:UnregisterHeavyEvents()
    end)

    local btnPJ = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    btnPJ:SetSize(110, 24); btnPJ:SetPoint("TOPLEFT", 20, -12); btnPJ:SetText(L["PANEL_PJ"] or "Panel PJ")
    btnPJ:SetScript("OnClick", function() UI:TogglePJ() end)

    local specDropDown = CreateFrame("Frame", "GASpecDropDownGuide", f, "UIDropDownMenuTemplate")
    specDropDown:SetPoint("TOPRIGHT", -10, -35); UIDropDownMenu_SetWidth(specDropDown, 125)
    local classDropDown = CreateFrame("Frame", "GAClassDropDownGuide", f, "UIDropDownMenuTemplate")
    classDropDown:SetPoint("RIGHT", specDropDown, "LEFT", 10, 0); UIDropDownMenu_SetWidth(classDropDown, 110)

    UIDropDownMenu_Initialize(classDropDown, function()
        local classes = {"DEATHKNIGHT","DRUID","HUNTER","MAGE","PALADIN","PRIEST","ROGUE","SHAMAN","WARLOCK","WARRIOR"}
        for _, c in ipairs(classes) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = SafeL(c); info.value = c; info.func = function(b) 
                GearAnalyzer.db.profile.settings.forcedClass = b.value
                local firstSpec = GearAnalyzer.ClassSpecsMap[b.value] and GearAnalyzer.ClassSpecsMap[b.value][1] or "None"
                GearAnalyzer.db.profile.settings.forcedSpec = firstSpec
                UIDropDownMenu_SetText(classDropDown, SafeL(b.value))
                UIDropDownMenu_SetText(specDropDown, SafeL(firstSpec))
                GearAnalyzer:LoadClassData(b.value)
                GearAnalyzer:FullReload(); UI:Update()
            end
            info.checked = (c == GearAnalyzer.db.profile.settings.forcedClass)
            UIDropDownMenu_AddButton(info)
        end
    end)
    UIDropDownMenu_SetText(classDropDown, SafeL(GearAnalyzer.db.profile.settings.forcedClass))
    
    UIDropDownMenu_Initialize(specDropDown, function()
        local class = GearAnalyzer.db.profile.settings.forcedClass
        local specs = GearAnalyzer.ClassSpecsMap[class] or {}
        for _, s in ipairs(specs) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = SafeL(s); info.value = s; info.func = function(b)
                GearAnalyzer.db.profile.settings.forcedSpec = b.value
                UIDropDownMenu_SetText(specDropDown, SafeL(b.value))
                GearAnalyzer:FullReload(); UI:Update()
            end
            info.checked = (s == GearAnalyzer.db.profile.settings.forcedSpec)
            UIDropDownMenu_AddButton(info)
        end
    end)
    UIDropDownMenu_SetText(specDropDown, SafeL(GearAnalyzer.db.profile.settings.forcedSpec))

    -- Aumentar tiempo de cierre del menú para que no se cierre al bajar el mouse
    if not GearAnalyzer._origDropdownTime then
        GearAnalyzer._origDropdownTime = UIDROPDOWNMENU_CLOSE_TIME_WAIT
    end
    UIDROPDOWNMENU_CLOSE_TIME_WAIT = 3

    for i, key in ipairs(UI.tabsGuide) do
        local tab = CreateFrame("Button", "GearAnalyzerGuideFrameTab"..i, f, "CharacterFrameTabButtonTemplate")
        tab:SetID(i); tab:SetText(SafeL(key))
        if i == 1 then tab:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 5, 10) -- Subido
        else tab:SetPoint("LEFT", _G["GearAnalyzerGuideFrameTab"..(i-1)], "RIGHT", -15, 0) end
        tab:SetScript("OnClick", function() UI:SelectTab(i, "Guide") end)
        
        local page = CreateFrame("Frame", nil, f)
        page:SetPoint("TOPLEFT", 20, -75); page:SetPoint("BOTTOMRIGHT", -20, 20); page:Hide()
        UI.pages.Guide[i] = page
    end
    PanelTemplates_SetNumTabs(f, #UI.tabsGuide)
    return f
end

-- FUNCIÓN MAESTRA DE CONTROL (GESTIÓN CENTRALIZADA)
function UI:OpenFrame(type)
    local main = self:CreateMainFrame()
    local guide = self:CreateGuideFrame()

    -- OCULTAMOS AMBAS PRIMERO (Reset limpio)
    main:Hide()
    guide:Hide()

    local target = (type == "PJ") and main or guide

    -- [BUGFIX] Si la especialización cambió mientras la ventana estaba cerrada,
    -- forzar FullReload() para recargar la base de datos de prioridad y el caché del personaje.
    local currentSpec = GearAnalyzer:GetCurrentSpecEnhanced()
    if GearAnalyzer.lastHandledSpec ~= currentSpec then
        GearAnalyzer:FullReload()
    end

    target:Show()
    target:Raise()
    
    -- Forzar la selección de pestaña inmediatamente
    self:SelectTab(target.selectedTab or 1, type)
end

function UI:TogglePJ()
    if GearAnalyzer.frame and GearAnalyzer.frame:IsShown() then
        GearAnalyzer.frame:Hide()
    else
        self:OpenFrame("PJ")
    end
end

function UI:ToggleGuide()
    if GearAnalyzer.guideFrame and GearAnalyzer.guideFrame:IsShown() then
        GearAnalyzer.guideFrame:Hide()
    else
        self:OpenFrame("Guide")
    end
end

function UI:SelectTab(id, type)
    local f = (type == "PJ") and GearAnalyzer.frame or GearAnalyzer.guideFrame
    if not f then return end
    id = id or f.selectedTab or 1
    f.selectedTab = id
    PanelTemplates_SetTab(f, id)
    PanelTemplates_UpdateTabs(f)
    
    local pages = (type == "PJ") and UI.pages.PJ or UI.pages.Guide
    local modules = (type == "PJ") and UI.modulesPJ or UI.modulesGuide
    
    for i, page in pairs(pages) do page:Hide() end
    if pages[id] then
        pages[id]:Show()
        local modName = modules[id]
        if modName then
            local mod = GearAnalyzer:GetModule(modName, true)
            if mod and mod.Update then 
                local status, err = pcall(function() mod:Update(pages[id], type == "PJ") end)
                if not status then print("|cffff0000GearAnalyzer Error en Tab:|r", err) end
            end
        end
    end
end

function UI:Update()
    if GearAnalyzer.frame and GearAnalyzer.frame:IsShown() then
        self:SelectTab(nil, "PJ")
    end
    if GearAnalyzer.guideFrame and GearAnalyzer.guideFrame:IsShown() then
        self:SelectTab(nil, "Guide")
    end
end
