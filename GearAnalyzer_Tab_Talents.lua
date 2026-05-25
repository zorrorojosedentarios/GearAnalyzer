local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabTalentos")

Tab.isGuideMode = true
Tab.talentIcons = {} -- Cache global de iconos para evitar fugas de memoria

function Tab:Update(page, ignoreForced)
    if not page then return end

    -- Guardar contexto para que RefreshTalentData lo use
    self.ignoreForced = ignoreForced

    -- Re-parentar si cambia la ventana (evita recrear frame con nombre duplicado)
    if self.container and self.lastPage ~= page then
        self.container:SetParent(page)
        self.container:ClearAllPoints()
        self.container:SetAllPoints(page)
    end
    self.lastPage = page

    if not self.container then
        local f = CreateFrame("Frame", "GearAnalyzer_TalentFrame", page)
        f:SetAllPoints()
        self.container = f

        local header = CreateFrame("Frame", nil, f)
        header:SetSize(710, 32); header:SetPoint("TOPLEFT", 25, -5)
        header:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14 })
        header:SetBackdropColor(0, 0, 0, 0.95); header:SetBackdropBorderColor(0.5, 0.5, 0.5)

        local specText = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        specText:SetPoint("LEFT", 15, 0)
        self.specText = specText

        local btnMode = CreateFrame("Button", nil, header, "UIPanelButtonTemplate")
        btnMode:SetSize(170, 24); btnMode:SetPoint("RIGHT", -10, 0)
        btnMode:SetText(L["VIEW_MY_POINTS"])
        btnMode:SetScript("OnClick", function()
            self.isGuideMode = not self.isGuideMode
            btnMode:SetText(self.isGuideMode and L["VIEW_MY_POINTS"] or L["VIEW_SUGGESTED"])
            self:RefreshTalentData()
        end)
        self.btnMode = btnMode
        
        local viewSwitch = CreateFrame("Frame", nil, header)
        viewSwitch:SetSize(300, 32); viewSwitch:SetPoint("RIGHT", -200, 0)
        self.viewSwitch = viewSwitch

        local function CreateViewBtn(text, x, type)
            local b = CreateFrame("Button", nil, viewSwitch, "UIPanelButtonTemplate")
            b:SetSize(120, 22); b:SetPoint("LEFT", x, 0); b:SetText(text)
            b:SetScript("OnClick", function()
                self.viewType = type
                self:RefreshTalentData()
            end)
            return b
        end

        self.btnHunterView = CreateViewBtn(L["HUNTER"], 0, "HUNTER")
        self.btnPetView = CreateViewBtn(L["PET"], 125, "PET")
        self.viewType = "HUNTER"

        local treeArea = CreateFrame("Frame", nil, f)
        treeArea:SetSize(710, 395); treeArea:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -3)

        self.panes = {}
        for i = 1, 3 do
            local p = CreateFrame("Frame", nil, treeArea)
            p:SetSize(230, 395); p:SetPoint("LEFT", (i-1)*240, 0)
            p:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12 })
            p:SetBackdropColor(0, 0, 0, 0.7)
            
            p.bg = p:CreateTexture(nil, "BACKGROUND"); p.bg:SetSize(220, 220); p.bg:SetPoint("CENTER", 0, 10); p.bg:SetAlpha(0.2)
            p.name = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); p.name:SetPoint("TOP", 0, -6); p.name:SetTextColor(1, 0.8, 0)
            p.points = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); p.points:SetPoint("TOP", p.name, "BOTTOM", 0, -2)

            self.panes[i] = p
        end

        local footer = CreateFrame("Frame", nil, f)
        footer:SetSize(710, 30); footer:SetPoint("TOPLEFT", treeArea, "BOTTOMLEFT", 0, -3)
        footer:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14 })
        footer:SetBackdropColor(0, 0, 0, 0.95); footer:SetBackdropBorderColor(0.5, 0.5, 0.5)

        local btnExport = CreateFrame("Button", nil, footer, "UIPanelButtonTemplate")
        btnExport:SetSize(200, 26); btnExport:SetPoint("RIGHT", -15, 0)
        btnExport:SetText(L["EXPORT_TO_TALENTED"])
        btnExport:SetScript("OnClick", function()
            local classToken = GearAnalyzer:GetClassToken(self.ignoreForced)
            local rawSpec = GearAnalyzer:GetCurrentSpecEnhanced(self.ignoreForced) or "Ninguna"
            local spec = GearAnalyzer:NormalizeSpecName(rawSpec)
            local build = GearAnalyzer.ClassData[classToken:upper()] and GearAnalyzer.ClassData[classToken:upper()].Talents and GearAnalyzer.ClassData[classToken:upper()].Talents[spec]

            if not _G.Talented or not _G.Talented.ImportTemplate then
                print("|cffff0000GearAnalyzer:|r " .. L["TALENTED_NOT_ACTIVE"])
                return
            end

            local rCode = build and build.exportCode or "0"
            local url = string.format("http://rpgworld.altervista.org/335/%s.php?%s", classToken:lower(), rCode)
            local template = _G.Talented:ImportTemplate(url)
            if template then
                template.name = (build and build.label) or "Build BiS GearAnalyzer"
                _G.Talented:OpenTemplate(template)
            end
        end)
    end
    self:RefreshTalentData()
end

function Tab:RefreshTalentData()
    local iF = self.ignoreForced  -- Contexto de la ventana actual
    local classToken = GearAnalyzer:GetClassToken(iF):upper()
    local playerToken = select(2, UnitClass("player")):upper()
    local isSimulated = (classToken ~= playerToken)
    local layoutDB = GA_TalentLayoutDB and GA_TalentLayoutDB[classToken]

    local rawSpec = GearAnalyzer:GetCurrentSpecEnhanced(iF) or "Ninguna"
    local spec = GearAnalyzer:NormalizeSpecName(rawSpec)
    local classData = GearAnalyzer.ClassData[classToken]
    local build = classData and classData.Talents and classData.Talents[spec]
    local exportCode = build and build.exportCode

    local headerTitle = string.format("%s - %s", GearAnalyzer:GetLocalizedClassName(self.ignoreForced), (self.isGuideMode and ("|cff00ff00" .. L["SUGGESTED_MAP"] .. "|r") or ("|cffffffff" .. L["MY_CONFIGURATION"] .. "|r")))
    if self.isGuideMode and build and build.label then
        headerTitle = headerTitle .. " (" .. GearAnalyzer:LocalizeText(build.label) .. ")"
    end
    self.specText:SetText(headerTitle)

    if classToken ~= "HUNTER" then self.viewSwitch:Hide(); self.viewType = "HUNTER" else self.viewSwitch:Show() end
    if self.viewType == "PET" then self:RefreshPetTalentData(); return end

    for i = 1, 3 do
        local p = self.panes[i]
        p:Show()
        -- Resetear posiciones/tamaños por si venimos de vista Mascota
        p:SetSize(230, 395)
        p:SetPoint("LEFT", (i-1)*240, 0)
        p.bg:SetAlpha(0.2)

        local name, icon, points = GetTalentTabInfo(i)
        
        -- Si simulamos, forzar nombres/iconos de la clase simulada desde ClassData si están disponibles
        if isSimulated and classData and classData.TalentTrees and classData.TalentTrees[i] then
            name = classData.TalentTrees[i].name
            icon = classData.TalentTrees[i].icon
        end

        p.bg:SetTexture(icon)
        p.name:SetText(GearAnalyzer:LocalizeText(name) or (L["TREE"] .. " " .. i))
        
        local branchData = {}
        if self.isGuideMode and exportCode then
            local offset = 0
            for prevIdx = 1, i - 1 do
                local nInTree = GetNumTalents(prevIdx)
                if isSimulated and layoutDB and layoutDB[prevIdx] then
                    nInTree = 0
                    for _ in pairs(layoutDB[prevIdx]) do nInTree = nInTree + 1 end
                end
                offset = offset + nInTree
            end
            
            local branchSize = GetNumTalents(i)
            if isSimulated and layoutDB and layoutDB[i] then
                branchSize = 0
                for _ in pairs(layoutDB[i]) do branchSize = branchSize + 1 end
            end
            
            local branchStr = string.sub(exportCode, offset + 1, offset + branchSize)
            for talentIdx = 1, string.len(branchStr) do
                branchData[talentIdx] = tonumber(string.sub(branchStr, talentIdx, talentIdx)) or 0
            end

            local bTotal = 0
            for _, pts in pairs(branchData) do bTotal = bTotal + pts end
            p.points:SetText(L["SUGGESTED_POINTS"] .. " " .. bTotal)
        else
            p.points:SetText(L["INVESTED_POINTS"] .. " " .. (points or 0))
        end

        self:RenderTreeGrid(p, i, branchData, isSimulated, layoutDB)
    end
end

function Tab:RefreshPetTalentData()
    local iF = self.ignoreForced
    local classToken = GearAnalyzer:GetClassToken(iF):upper()
    local rawSpec = GearAnalyzer:GetCurrentSpecEnhanced(iF) or "Ninguna"
    local spec = GearAnalyzer:NormalizeSpecName(rawSpec)
    local classData = GearAnalyzer.ClassData[classToken]
    local build = classData and classData.Talents and classData.Talents[spec]
    local petCode = build and build.petCode

    for i = 1, 3 do self.panes[i]:Hide() end
    
    local p = self.panes[2]
    p:Show()
    p:SetPoint("CENTER", 0, -5)
    p:SetSize(450, 440)
    
    -- Detectar icono de la familia de mascota actual
    local petIcon = "Interface\\Icons\\Ability_Hunter_BestialDiscipline"
    if HasPetUI() then
        petIcon = GetPetIcon() or petIcon
    end
    p.bg:SetTexture(petIcon)
    p.bg:SetAlpha(0.15)
    
    local petLabel = L["PET_TALENTS"]
    if self.isGuideMode and build and build.label then
        petLabel = petLabel .. " (" .. GearAnalyzer:LocalizeText(build.label) .. ")"
    end
    p.name:SetText(petLabel)
    
    local pData = {}
    if self.isGuideMode and petCode then
        for i = 1, string.len(petCode) do
            pData[i] = tonumber(string.sub(petCode, i, i)) or 0
        end
        
        local total = 0
        for _, v in pairs(pData) do total = total + v end
        p.points:SetText(L["SUGGESTED_POINTS"] .. " " .. total)
    else
        local _, _, spent = GetTalentTabInfo(1, false, true)
        p.points:SetText(L["INVESTED_POINTS"] .. " " .. (spent or 0))
    end
    
    self:RenderTreeGrid(p, 1, pData, false, nil, true)
end

function Tab:RenderTreeGrid(pane, tabIndex, guideData, isSimulated, layoutDB, isPet)
    if not pane.talentIcons then pane.talentIcons = {} end
    for _, icon in pairs(pane.talentIcons) do icon:Hide() end

    -- Store per-call data on pane so pre-set scripts can read them
    pane._guideData = guideData
    pane._isSimulated = isSimulated
    pane._showGuide = self.isGuideMode

    local numTalents = 0
    if isPet then
        numTalents = GetNumTalents(1, false, true) or 0
    elseif isSimulated and layoutDB and layoutDB[tabIndex] then
        for _ in pairs(layoutDB[tabIndex]) do numTalents = numTalents + 1 end
    else
        numTalents = GetNumTalents(tabIndex) or 0
    end

    local spacingH, spacingV = (isPet and 85 or 35), (isPet and 65 or 31)
    local xOff, yOff = (isPet and 95 or 48), (isPet and 75 or 38)

    for i = 1, numTalents do
        local name, icon, tier, column, rank, maxRank
        if isSimulated and layoutDB then
            local d = layoutDB[tabIndex][i]
            name, icon, tier, column, maxRank = d.name, d.icon, d.tier, d.column, d.maxRank
            rank = guideData and guideData[i] or 0
        else
            name, icon, tier, column, rank, maxRank = GetTalentInfo(tabIndex, i)
            if self.isGuideMode and guideData then rank = guideData[i] or 0 end
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
                f:SetScript("OnEnter", function(s)
                    local par = s:GetParent()
                    GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
                    if s._isPet then GameTooltip:SetTalent(1, s._talentIdx, false, true) else GameTooltip:SetTalent(s._tabIdx, s._talentIdx) end
                    local gd = par._guideData
                    if gd and par._showGuide then
                        local sug = gd[s._talentIdx] or 0
                        local act = 0
                        if not par._isSimulated then
                            if s._isPet then
                                local _, _, _, _, petRank = GetTalentInfo(1, s._talentIdx, false, true)
                                act = petRank or 0
                            else
                                local _, _, _, _, playerRank = GetTalentInfo(s._tabIdx, s._talentIdx)
                                act = playerRank or 0
                            end
                        end
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine("|cffffd100" .. (L["SUGGESTED_POINTS"] or "Puntos sugeridos:") .. "|r |cffffffff" .. sug .. " / " .. (s._maxRank or 5) .. "|r")
                        if not par._isSimulated then
                            GameTooltip:AddLine("|cff00ff00Puntos invertidos:|r |cffffffff" .. act .. " / " .. (s._maxRank or 5) .. "|r")
                        end
                    end
                    GameTooltip:Show()
                end)
                f:SetScript("OnLeave", function() GameTooltip:Hide() end)
                pane.talentIcons[i] = f
            end

            -- Update per-talent data for pre-set script
            f._tabIdx = tabIndex
            f._talentIdx = i
            f._isPet = isPet
            f._maxRank = maxRank

            f:SetPoint("TOPLEFT", (column - 1) * spacingH + xOff, -(tier - 1) * spacingV - yOff)
            f.tex:SetTexture(icon)
            f.count:SetText(rank > 0 and rank or "")
            
            if self.isGuideMode and guideData then
                local isSelected = (guideData[i] or 0) > 0
                f.tex:SetDesaturated(not isSelected)
                f.tex:SetAlpha(isSelected and 1 or 0.2)
                f.border:SetVertexColor(isSelected and 1 or 0.5, isSelected and 0.8 or 0.5, 0, isSelected and 1 or 0.3)
            else
                f.tex:SetDesaturated(rank == 0)
                f.tex:SetAlpha(rank > 0 and 1 or 0.3)
                f.border:SetVertexColor(rank == maxRank and 1 or 0, rank > 0 and 0.8 or 0.5, 0, rank > 0 and 1 or 0.3)
            end

            f:Show()
        end
    end
end
