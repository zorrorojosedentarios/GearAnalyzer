-- =============================================
-- GearAnalyzer Guide Tab: Gemas (Ventana Guía)
-- Módulo independiente - siempre usa ignoreForced=false
-- =============================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabGemasGuide")

function Tab:Update(page, ignoreForced)
    if not page then return end

    -- Este módulo siempre usa los dropdowns de clase/spec (ignoreForced = false)
    local class     = GearAnalyzer:GetClassToken(false)
    local activeSpec = GearAnalyzer:GetCurrentSpecEnhanced(false)
    local spec      = GearAnalyzer:NormalizeSpecName(activeSpec)
    local classLoc  = GearAnalyzer:GetLocalizedClassName(false)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)

    -- Creación única del scroll (nombre propio para evitar conflicto con PJ)
    if not self.scroll then
        local title = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        GearAnalyzer:ApplyStyle(title, true)
        self.titleString = title

        local scroll = CreateFrame("ScrollFrame", "GAGemsScrollGuide", page, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)
        self.scroll = scroll

        local f = CreateFrame("Frame", nil, scroll)
        local w = scroll:GetWidth()
        if not w or w <= 0 then w = 725 end
        f:SetSize(w, 500)
        scroll:SetScrollChild(f)
        self.container = f

        local help = CreateFrame("Frame", nil, f)
        help:SetSize(500, 60)
        local hText = help:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        hText:SetPoint("TOPLEFT", 0, 0)
        hText:SetJustifyH("LEFT")
        hText:SetWidth(500)
        self.helpText = hText

        self.rows = {}
    end

    self.titleString:SetText(L["RECOMMENDED_GEMS"] .. " - " .. classLoc .. " " .. specLabel)
    GearAnalyzer:SetupGuideIcons(page, class, spec)

    local classData = GearAnalyzer.ClassData[class]
    local specData  = classData and classData.Gems and classData.Gems[spec]
    local capsData  = classData and classData.Caps and classData.Caps[spec]

    local helpMsg = L["GEM_PRIORITY_HINT"]
    if specData and specData.note then
        helpMsg = "|cff00ff00" .. L["GUIDE_LABEL"] .. "|r " .. GearAnalyzer:LocalizeText(specData.note)
    end
    if capsData and capsData.priorities then
        local prioStr = "\n|cffffd100" .. L["PRIORITY_LABEL"] .. "|r "
        for i, p in ipairs(capsData.priorities) do
            local localizedLabel = rawget(L, p.label) or p.label
            prioStr = prioStr .. localizedLabel .. (i < #capsData.priorities and " > " or "")
        end
        helpMsg = helpMsg .. prioStr
    end
    self.helpText:SetText(helpMsg)
    GearAnalyzer:ApplyStyle(self.helpText)

    -- Render filas
    for _, r in ipairs(self.rows) do r:Hide() end

    local gemList = {
        { type = L["GEM_META"],   id = 0, color = "|cffffffff" },
        { type = L["GEM_RED"],    id = 0, color = "|cffff0000" },
        { type = L["GEM_YELLOW"], id = 0, color = "|cffffff00" },
        { type = L["GEM_BLUE"],   id = 0, color = "|cff0000ff" },
    }

    local dynamicGems = GearAnalyzer:GetDynamicGems(class, spec)
    if dynamicGems then
        gemList[1].id = dynamicGems.meta   or 0 ; gemList[1].reason = dynamicGems.metaReason
        gemList[2].id = dynamicGems.red    or 0 ; gemList[2].reason = dynamicGems.redReason or dynamicGems.redOK
        gemList[3].id = dynamicGems.yellow or 0 ; gemList[3].reason = dynamicGems.yellowReason or dynamicGems.yellowOK
        gemList[4].id = dynamicGems.blue   or 0 ; gemList[4].reason = dynamicGems.blueReason or dynamicGems.blueOK
        if dynamicGems.redJC then
            table.insert(gemList, 2, { type = L["PROFESSION_ONLY"], id = dynamicGems.redJC, color = "|cffff00ff", reason = dynamicGems.redJCReason })
        end
    end

    local y = -35
    for i, gData in ipairs(gemList) do
        local row = self:GetOrCreateRow(i)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 10, y)
        row:Show()

        local name, link, quality, _, _, _, _, _, _, texture = GetItemInfo(gData.id)
        if not name and GearAnalyzer.scanner and gData.id > 0 then
            GearAnalyzer.scanner:SetHyperlink("item:" .. gData.id)
            name, link, quality, _, _, _, _, _, _, texture = GetItemInfo(gData.id)
        end

        row.icon:SetTexture(texture or (gData.id > 0 and GetItemIcon(gData.id)))
        row.itemID = gData.id
        row.itemLink = link

        local reasonText = gData.reason or ""
        row.typeText:SetText(gData.color .. gData.type .. ":|r " .. reasonText)
        GearAnalyzer:ApplyStyle(row.typeText)

        row.nameText:SetText(link or (gData.id > 0 and "Cargando..." or "|cffaaaaaa" .. L["NO_GEM_FOUND"] .. "|r"))
        GearAnalyzer:ApplyStyle(row.nameText)

        y = y - 58
        i = i + 1
    end

    -- Ajustar altura del contenido
    self.container:SetHeight(math.max(200, math.abs(y) + 20))
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end

    local row = CreateFrame("Frame", nil, self.container)
    row:SetSize(self.container:GetWidth() - 20, 52)
    row:EnableMouse(true)

    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(38, 38)
    icon:SetPoint("LEFT", 10, 0)
    row.icon = icon

    local typeText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    typeText:SetPoint("LEFT", icon, "RIGHT", 12, 10)
    row.typeText = typeText

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("LEFT", icon, "RIGHT", 12, -10)
    row.nameText = nameText

    -- Tooltips y Link
    row:SetScript("OnEnter", function(self)
        if self.itemID and self.itemID > 0 then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. self.itemID)
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function() GameTooltip:Hide() end)
    row:SetScript("OnMouseUp", function(self, button)
        if self.itemID and self.itemID > 0 then
            HandleModifiedItemClick(self.itemLink or ("item:"..self.itemID))
        end
    end)

    self.rows[i] = row
    return row
end
