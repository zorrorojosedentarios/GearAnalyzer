-- ===================================================
-- GearAnalyzer Guide Tab: Talentos (Ventana Guía)
-- Módulo independiente - siempre usa ignoreForced=false
-- Muestra el build sugerido para la clase/spec del dropdown
-- ===================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabTalentosGuide")

function Tab:Update(page, ignoreForced)
    if not page then return end
    self.ignoreForced = false  -- Siempre usa los dropdowns de Guía

    -- Re-parentar si cambia la ventana (evita problemas de visibilidad)
    if self.container and self.lastPage ~= page then
        self.container:SetParent(page)
        self.container:ClearAllPoints()
        self.container:SetAllPoints(page)
    end
    self.lastPage = page

    if not self.container then
        local f = CreateFrame("Frame", "GearAnalyzer_TalentFrame_Guide", page)
        f:SetAllPoints()
        self.container = f

        local header = CreateFrame("Frame", nil, f)
        header:SetSize(710, 32); header:SetPoint("TOPLEFT", 25, -5)
        header:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14 })
        header:SetBackdropColor(0, 0, 0, 0.95); header:SetBackdropBorderColor(0.5, 0.5, 0.5)

        local specText = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        specText:SetPoint("LEFT", 15, 0)
        self.specText = specText

        -- Botones "VER: SUGERIDOS" y "EXPORTAR" eliminados a petición del usuario
        self.isGuideMode = true

        local treeArea = CreateFrame("Frame", nil, f)
        treeArea:SetSize(710, 395); treeArea:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -3)
        self.treeArea = treeArea

        self.panes = {}
        for i = 1, 3 do
            local p = CreateFrame("Frame", nil, treeArea)
            p:SetSize(230, 395); p:SetPoint("LEFT", (i-1)*240, 0)
            p:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12 })
            p:SetBackdropColor(0, 0, 0, 0.7)
            p.bg = p:CreateTexture(nil, "BACKGROUND"); p.bg:SetSize(220, 220); p.bg:SetPoint("CENTER", 0, 10); p.bg:SetAlpha(0.25)
            p.name = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); p.name:SetPoint("TOP", 0, -6); p.name:SetTextColor(1, 0.8, 0)
            p.points = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); p.points:SetPoint("TOP", p.name, "BOTTOM", 0, -2)
            self.panes[i] = p
        end

    end

    self:RefreshData()
end

function Tab:RefreshData()
    local classToken = GearAnalyzer:GetClassToken(false):upper()
    local layoutDB   = GA_TalentLayoutDB and GA_TalentLayoutDB[classToken]
    local rawSpec    = GearAnalyzer:GetCurrentSpecEnhanced(false) or "Ninguna"
    local spec       = GearAnalyzer:NormalizeSpecName(rawSpec)
    local classData  = GearAnalyzer.ClassData[classToken]
    local build      = classData and classData.Talents and classData.Talents[spec]
    local exportCode = build and build.exportCode

    local displayClassName = GearAnalyzer:GetLocalizedClassName(false)
    local headerTitle = string.format("%s - %s", displayClassName, "|cff00ff00" .. L["SUGGESTED_MAP"] .. "|r")
    
    if build and build.label then
        headerTitle = headerTitle .. " (" .. GearAnalyzer:LocalizeText(build.label) .. ")"
    end
    self.specText:SetText(headerTitle)
    GearAnalyzer:SetupGuideIcons(self.lastPage, classToken, spec)

    local _, playerClass = UnitClass("player")
    local isSimulated = (classToken ~= playerClass:upper())

    for i = 1, 3 do
        local p = self.panes[i]
        local tabName, tabIcon, tabPoints = GetTalentTabInfo(i)
        
        if isSimulated or not tabName then
            if classData and classData.TalentTrees and classData.TalentTrees[i] then
                tabName = classData.TalentTrees[i].name
                tabIcon = classData.TalentTrees[i].icon
            else
                tabName = GearAnalyzer.TalentTreeNames and GearAnalyzer.TalentTreeNames[classToken] and GearAnalyzer.TalentTreeNames[classToken][i] or (L["TREE"] .. " " .. i)
                tabIcon = nil
            end
            tabPoints = 0
        end

        if tabName then
            p:Show()
            if p.bg then
                if tabIcon then
                    p.bg:SetTexture(tabIcon)
                elseif layoutDB and layoutDB[i] and layoutDB[i].icon then
                    p.bg:SetTexture(layoutDB[i].icon)
                end
            end
            p.name:SetText(GearAnalyzer:LocalizeText(tabName) or tabName)

            local branchData = {}
            local guideTotal = 0
            if exportCode then
                local offset = 0
                for prevIdx = 1, i - 1 do
                    local nInTree = 0
                    if isSimulated and layoutDB and layoutDB[prevIdx] then
                        nInTree = #layoutDB[prevIdx]
                    else
                        nInTree = GetNumTalents(prevIdx) or 0
                    end
                    offset = offset + nInTree
                end
                
                local branchSize = 0
                if isSimulated and layoutDB and layoutDB[i] then
                    branchSize = #layoutDB[i]
                else
                    branchSize = GetNumTalents(i) or 0
                end
                
                local branchStr = string.sub(exportCode, offset + 1, offset + branchSize)
                for talentIdx = 1, string.len(branchStr) do
                    local pts = tonumber(string.sub(branchStr, talentIdx, talentIdx)) or 0
                    branchData[talentIdx] = pts
                    guideTotal = guideTotal + pts
                end
            end
            
            p.points:SetText(L["SUGGESTED_POINTS"] .. " " .. guideTotal)
            self:RenderTreeGrid(p, i, branchData, isSimulated, layoutDB)
        else
            p:Hide()
        end
    end
end

function Tab:RenderTreeGrid(pane, tabIndex, guideData, isSimulated, layoutDB)
    if not pane.talentIcons then pane.talentIcons = {} end
    for _, icon in pairs(pane.talentIcons) do icon:Hide() end

    local numTalents = 0
    if isSimulated and layoutDB and layoutDB[tabIndex] then
        numTalents = #layoutDB[tabIndex]
    else
        numTalents = GetNumTalents(tabIndex) or 0
    end

    local spacingH, spacingV = 35, 31
    local xOff, yOff = 48, 38

    for i = 1, numTalents do
        local name, icon, tier, column, rank, maxRank, spellID
        if isSimulated and layoutDB and layoutDB[tabIndex] and layoutDB[tabIndex][i] then
            local d = layoutDB[tabIndex][i]
            name, icon, tier, column, maxRank, spellID = d.name, d.icon, d.tier, d.column, d.maxRank, d.spellID
            rank = guideData and guideData[i] or 0
        else
            name, icon, tier, column, rank, maxRank = GetTalentInfo(tabIndex, i)
            if guideData then rank = guideData[i] or 0 end
        end

        if name then
            local f = pane.talentIcons[i]
            if not f then
                f = CreateFrame("Frame", nil, pane)
                f:SetSize(28, 28)
                f:EnableMouse(true)
                f.tex = f:CreateTexture(nil, "ARTWORK"); f.tex:SetAllPoints()
                f.border = f:CreateTexture(nil, "OVERLAY"); f.border:SetTexture("Interface\\Buttons\\UI-Quickslot2"); f.border:SetSize(42, 42); f.border:SetPoint("CENTER")
                f.count = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                f.count:SetPoint("BOTTOMRIGHT", 2, -1)
                pane.talentIcons[i] = f
            end

            f:SetPoint("TOPLEFT", (column - 1) * spacingH + xOff, -(tier - 1) * spacingV - yOff)
            f.tex:SetTexture(icon)
            f.count:SetText(rank > 0 and rank or "")
            
            local isSelected = (rank > 0)
            f.tex:SetDesaturated(not isSelected)
            f.tex:SetAlpha(isSelected and 1 or 0.2)
            f.border:SetVertexColor(isSelected and 1 or 0.5, isSelected and 0.8 or 0.5, 0, isSelected and 1 or 0.3)

            f:Show()
            f:SetScript("OnEnter", function(s) 
                GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
                if isSimulated and spellID then
                    GameTooltip:SetHyperlink("spell:"..spellID)
                else
                    GameTooltip:SetTalent(tabIndex, i)
                end
                
                local sug = guideData and guideData[i] or 0
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cffffd100" .. (L["SUGGESTED_POINTS"] or "Puntos sugeridos:") .. "|r |cffffffff" .. sug .. " / " .. (maxRank or 5) .. "|r")
                
                if not isSimulated then
                    local _, _, _, _, actRank = GetTalentInfo(tabIndex, i)
                    local act = actRank or 0
                    GameTooltip:AddLine("|cff00ff00Puntos invertidos:|r |cffffffff" .. act .. " / " .. (maxRank or 5) .. "|r")
                end
                
                GameTooltip:Show()
            end)
            f:SetScript("OnLeave", function() GameTooltip:Hide() end)
        end
    end
end
